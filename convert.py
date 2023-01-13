import zipfile
import os
import fnmatch
import argparse

PATTERN = '*64.svg'
ICON_PATH = "icons"
OPENSCAD_PATH = '/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'


# Initialize parser
parser = argparse.ArgumentParser()
# Adding optional arguments
parser.add_argument("-t", "--tile_name", help = "Set Tile Name", required=True)
parser.add_argument("-s", "--search", help = "Search Term for SVG", required=True)
parser.add_argument("-f", "--filename", help = "Input Archive (zip file)", required=True)

# Read arguments from command line
args = parser.parse_args()


if args.search:
    print("Looking for: % s" % args.search)
    print("Tile Text will be: % s" % args.tile_name)

search_term = args.search
title = args.tile_name

def unzip(file):
    with zipfile.ZipFile(file,"r") as zip_ref:
        zip_ref.extractall(ICON_PATH)

def exec_openscad(icon_file,title):
    # I know I should be using subprocess.run here, but it kept munging the quoting scad needs
    os.system(OPENSCAD_PATH+ """ -o samples/"""+title+""".stl -D 'source_svg = \""""+icon_file+"""\"' -D 'text = \""""+title+"""\"' Generate_tile.scad""")


def remove_rect(filename):
    with open(filename, "r", encoding='unicode_escape') as input:
        with open("icon.svg", "w") as output:
            # iterate all lines from file
            for line in input:
                # if substring contain in a line then don't write it
                if "<rect" not in line.strip("\n"):
                    output.write(line)

    # replace file with original name
    #os.replace(filename+'.tmp', filename)  

unzip(args.filename)

# lookup recursive
for dirpath, dirnames, filenames in os.walk(ICON_PATH):
    if not filenames:
        continue

    pythonic_files = fnmatch.filter(filenames, PATTERN)
    if pythonic_files:
        for file in pythonic_files:
            if search_term in file:
                print ('Found an icon match:')
                print('{}/{}'.format(dirpath, file))
                remove_rect('{}/{}'.format(dirpath, file))
                exec_openscad('icon.svg',title)
