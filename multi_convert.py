import subprocess
import zipfile
import os
import fnmatch
import argparse
import csv
import concurrent.futures

PATTERN = '*64.svg'
ICON_PATH = "icons"
OPENSCAD_PATH = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
THREADS = os.cpu_count() # This is only partially effective due to GIL, but couldn't use multiprocessing.pool as csv lib hates that!

print('Using: '+str(THREADS)+' Threads')

# Initialize parser
parser = argparse.ArgumentParser()
parser.add_argument("-f", "--filename", help = "Input Archive (zip file)", required=True)

# Read arguments from command line
args = parser.parse_args()

def unzip(file):
    with zipfile.ZipFile(file,"r") as zip_ref:
        zip_ref.extractall(ICON_PATH)

def exec_openscad(icon_file,title,prefix):
    # Uses subprocess.run to allow threading of SCAD without hitting the GIL 
    subprocess.run([OPENSCAD_PATH, '-o', 'samples/'+prefix+title+'.stl', '-D source_svg = "'+icon_file+'"', '-D text = "'+title+'"', 'Generate_tile.scad'])

def remove_rect(filename,title):
    with open(filename, "r", encoding='unicode_escape') as input:
        with open(title+".svg", "w") as output:
            # iterate all lines from file
            for line in input:
                # if substring contained in a line then don't write it
                if "<rect" not in line.strip("\n"):
                    output.write(line)


def process_tile(row):
    # Preprocess and run SCAD for each match
    print("SCAD Thread for: "+row['title']+" using -"+row['search'])

    for dirpath, dirnames, filenames in os.walk(ICON_PATH):
        if not filenames:
            continue

        pythonic_files = fnmatch.filter(filenames, PATTERN)
        if pythonic_files:
            for file in pythonic_files:
                if row['search'] in file:
                    #print ('Found an icon match:')
                    #print('{}/{}'.format(dirpath, file))
                    remove_rect('{}/{}'.format(dirpath, file),row['title'])
                    exec_openscad(row['title']+'.svg',row['title'],row['colour'])    
    print("*DONE* SCAD Thread for: "+row['title'])
    if os.path.isfile(row['title']+'.svg'):
     os.remove(row['title']+'.svg')

def process_csv(file_name):
    # Create a ThreadPoolExecutor. The `with` statement is used for proper cleanup.
    with concurrent.futures.ThreadPoolExecutor(max_workers=THREADS) as executor:
        # Open the file and create a CSV reader object.
        with open(file_name, newline='') as csvfile:
            reader = csv.DictReader(csvfile)

            # Use `map` to apply the `process_row` function to each row. `map`
            # will return a generator that produces the results, so you don't
            # have to worry about storage.
            executor.map(process_tile, reader)

print ('Using: '+args.filename)
unzip(args.filename)

process_csv('tile_list.csv')

print('Tiles generated are saved in "samples" directory')