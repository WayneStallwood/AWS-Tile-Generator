# AWS-Tile-Generator
Simple 3D Tile Generator for AWS Service Icons using OpenSCAD


# Usage

The most common icons are already generated in the "samples" directory, note these have the new magnet hole option (8x1mm round magnet), regenerate with the instructions below if you don't want that. or for a missing service. See tile_list.csv for the samples included.

Simply download the AWS Icon Assets package from here:
https://aws.amazon.com/architecture/icons/ and place the ZIP file in your working directory.

Unzip and adjust the parameters in OpenSCAD to point to the "64" version of the SVG and set the tile title you want to use

The SVG files need a small modification to remove the rectangular background, you can either manually remove the background from the SVG in the "64" directory by removing the line from the SVG starting "<rect" in your favourite text editor or use the included Python to preprocess the file and automatically submit it into OpenSCAD

There is also a multi-processor which will take batches of Tiles from a manifest csv and convert them

(see Python usage insructions below)



# Usage (python autoprocessor)

* Currently untested on Windows *

To use the Python autoprocessor, place the Assets Zip file downloaded above into your working directory.

Adjust the path at the top to point to your local copy of OpenSCAD

python3 convert.py -f [Assets File Zip] -s [Search string for icon] -t [Label for Tile]

example:
python3 convert.py -f assets.zip -s Lambda -t Lambda

The result will be added to the samples directory

In some cases the autoprocesor may match more than one Icon, if so then please use more specific search terms (such as the full filename)


# I have lots of tiles to generate !

* Currently untested on Windows *

python3 multi_convert.py -f [Assets File Zip] 
Will generate a batch of tiles, as specified in the manifest (tile_list.csv)

The CSV is in the header format  (title,search,colour)

* Title is the Label for the tile

* Search is the file search string for the service icon

* Colour is a feature that adds a prefix to the generated tile, This is used to provide hints in the stl filename of the Tile colour to match the official icon colours by service (makes it a lot easier when printing them)

The sample manifest creates the list of Tiles in the samples folder by default.
This script will multithread OpenSCAD based on number of CPU cores you have
