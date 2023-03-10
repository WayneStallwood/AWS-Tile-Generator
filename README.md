# AWS-Tile-Generator
Simple 3D Tile Generator for AWS Service Icons using OpenSCAD


# Usage

The most common icons are already generated in the "samples" directory, for a missing service simply download the AWS Icon Assets package from here:
https://aws.amazon.com/architecture/icons/ and place the ZIP file in your working directory.

Unzip and adjust the parameters in OpenSCAD to point to the "64" version of the SVG and set the tile title you want to use

The SVG files need a small modification to remove the rectangular background, you can either manually remove the background from the SVG in the "64" directory by removing the line from the SVG starting "<rect" in your favourite text editor or use the included Python to preprocess the file and automatically submit it into OpenSCAD

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
