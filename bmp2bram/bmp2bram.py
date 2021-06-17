#!/usr/bin/python3
# Convert a bmp file to a synthesizable VHDL BRAM description
#
# Author: Hipolito Guzman Miranda

# To print errors to stderr
import sys

# To easily get command-line arguments
import argparse

# To read and process images
from PIL import Image

# To know if we are opening a .bmp file or a different image format
import imghdr

# To use the 'repeat' iterator
import itertools

# To use log2 and ceil functions
import math

# To get the name of a file without path or extension
from pathlib import Path

# Configure the argument parser
parser = argparse.ArgumentParser(description='Convert a bmp file to a synthesizable BRAM VHDL description.')
parser.add_argument('inputfile', help='input file (image)')
parser.add_argument('--nbits', default=4, help='number of bits per color component in the output BRAM (default: %(default)s)')
parser.add_argument('--mono', action='store_true', help='generate a binary image (1 bit per pixel) instead of a color image. If set, NBITS is ignored for the output BRAM generation (default: %(default)s)')
parser.add_argument('--threshold', default=127, help='threshold for generating the binary image. Must be between 0 and 255. Only affects the output BRAM generation when --mono is set (default: %(default)s)')
parser.add_argument('--show', action='store_true', help='show a collage with the original, quantized and binarized images (default: %(default)s)')
#TODO: parser.add_argument('--dpram', action='store_true', help='generate a dual-port BRAM (default: %(default)s)')

# Get arguments from command-line
args = parser.parse_args()
FILE = args.inputfile
NBITS = int(args.nbits)
THRESHOLD = int(args.threshold)

# Check correct values of arguments
assert NBITS > 0 and NBITS <=8, "nbits should be between 1 and 8"
assert THRESHOLD >= 0 and THRESHOLD <= 255, "threshold should be between 0 and 255"

# Calculate if a number is a power of two
# (explanation at https://stackoverflow.com/a/600306 )
def is_power_of_two(n):
    return (n != 0) and (n & (n-1) == 0)

# Map 8bit values to nbits values, by shifting right 8 - nbits times
def quantize_value(input, nbits):
    assert nbits > 0 and nbits <=8, "nbits should be between 1 and 8"
    return input >> (8 - nbits)

# Map nbit values to 8bit values, by shifting left 8 - nbits times
def unquantize_value(input, nbits):
    assert nbits > 0 and nbits <=8, "nbits should be between 1 and 8"
    return (input << (8 - nbits))


# Map 255 to 1 and 0 to 0
def binarize_value(input):
    assert input == 0 or input == 255, "input should be either 0 or 255"
    return 0 if input == 0 else 1

# Open the image file
im = Image.open(FILE, 'r')

# Check that the file is in bmp format
# If not, issue a warning and check if there is an alpha layer. In that case,
# make a quick conversion: extract r, g, b, and alpha, and merge only r, g, b
# into a bitmap
if imghdr.what(FILE) != 'bmp':
    print('Warning: input file not in bmp format. Will attempt conversion, but you should really use a bmp file as input.', file = sys.stderr)
    if im.mode == "RGBA" or "transparency" in im.info:
        r, g, b, a = im.split()
        im = Image.merge("RGB", (r, g, b))

# Binarize the image in case we need to output a binary image
# This outputs a single list of size_x*size_y elements
binarized = lambda x : 255 if x > THRESHOLD else 0
binim = im.convert('L').point(binarized, mode='1')
binarized_pixels = list(binim.getdata())

# Check that image dimensions are a multiple of 2
if (not is_power_of_two(im.size[0])) or (not is_power_of_two(im.size[1])):
    print('Warning: Image size', im.size, 'not a power of 2', file = sys.stderr)

# Extract the pixel values
pixel_values = list(im.getdata())

# Use a list comprehension to apply the quantize_value function to all
# components of all pixels. pixel_values is a list of tuples, each tuple being
# a pixel that has three components:
quantized_pixels = [[ quantize_value(component, NBITS) for component in pixel] for pixel in pixel_values ]

# Create a preview of the quantized image to show
# unquantized_pixels is a list of lists, but putdata() needs a list of tuples,
# so we convert a list of list to a list of tuples by doing:
# [tuple(x) for x in list]
colorim = Image.new(im.mode, im.size)
unquantized_pixels = [[ unquantize_value(component, NBITS) for component in pixel] for pixel in quantized_pixels ]
unquantized_pixels_list_of_tuples = [tuple(x) for x in unquantized_pixels]
colorim.putdata(unquantized_pixels_list_of_tuples)

# Optionally show original, quantized and monochrome images
if args.show:
    collage = Image.new('RGB', (3*im.width, im.height))
    collage.paste(im, (0,0))
    collage.paste(colorim, (im.width, 0))
    collage.paste(binim, (2*im.width, 0))
    collage.show()


# Calculate DATA_WIDTH
if args.mono:
    DATA_WIDTH = 1
else:
    DATA_WIDTH = NBITS*3

# Calculate ADDR_WIDTH
MAX_ADDR = im.size[0] * im.size[1]
ADDR_WIDTH = math.ceil(math.log2(MAX_ADDR))

# Name our VHDL entity and architecture
ENTITY = Path(FILE).stem
ARCH_NAME = ENTITY + '_arch'

# Now print the VHDL code, beginning with the entity section
print(
"""-- Automatically generated by bmp2bram with arguments:
--""", vars(args), """
-- Image size: """, im.size, """
-- This code infers a BRAM when synthesized

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity""", ENTITY, """is
  generic (
    DATA_WIDTH : integer :=""", DATA_WIDTH, """;
    ADDR_WIDTH : integer :=""", ADDR_WIDTH, """);
  port (clk   : in  std_logic;
        addri : in  unsigned (ADDR_WIDTH-1 downto 0);
        datai : in  std_logic_vector (DATA_WIDTH-1 downto 0);
        we    : in  std_logic;
        datao : out std_logic_vector (DATA_WIDTH-1 downto 0));
end""", ENTITY, """;""")

# Print a commented hex version of the drawing.
# At the end of each line, the index i will be just (N*im.size[0])-1, so when
# i+1 is a multiple of im.size[0], print a newline at the end of the pixel.
print('--')
print('--', end='')

# Read different pixel lists depending on whether we want the color or
# monochrome image.
# For the monochrome image, pixels are just a single component: 255 or 0
if args.mono:
    for i, pixel in enumerate(binarized_pixels):
        component = binarize_value(pixel)
        if (i+1) % im.size[0] == 0:
            endchar = '\n--'
        else:
            endchar = ''
        print('{0:x}'.format(component, 'x').zfill(math.ceil(DATA_WIDTH)), end=endchar)
else:
    for i, pixel in enumerate(quantized_pixels):
        component_R='{0:b}'.format(pixel[0]).zfill(NBITS)
        component_G='{0:b}'.format(pixel[1]).zfill(NBITS)
        component_B='{0:b}'.format(pixel[2]).zfill(NBITS)
        if (i+1) % im.size[0] == 0:
            endchar = '\n--'
        else:
            endchar = ''
        print('{0:x}'.format(int(component_R+component_G+component_B,2), 'x').zfill(math.ceil(NBITS*3/4)), end=endchar)

# Print the architecture
print()
print("""architecture""", ARCH_NAME,"""of""", ENTITY,""" is

  type ram_type is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector (DATA_WIDTH-1 downto 0);
  signal ram : ram_type := (""")

# Print BRAM init data as fixed-width binary values.
# Note that the last value doesn't need a ',', it needs a ');'
#
# Print all pixel values except the last
if args.mono:
    for pixel in binarized_pixels[:-1]:
        component = binarize_value(pixel)
        print('                            '+'"'+str(component)+'",')
else:
    for pixel in quantized_pixels[:-1]:
        component_R='{0:b}'.format(pixel[0]).zfill(NBITS)
        component_G='{0:b}'.format(pixel[1]).zfill(NBITS)
        component_B='{0:b}'.format(pixel[2]).zfill(NBITS)
        print('                            '+'"'+component_R+component_G+component_B+'",')
#
# Print the last value, which needs a closing parenthesis and a semicolon:
if args.mono:
    pixel = binarized_pixels[-1]
    component = binarize_value(pixel)
    print('                            '+'"'+str(component)+'");')
else:
    pixel = quantized_pixels[-1]
    component_R='{0:b}'.format(pixel[0]).zfill(NBITS)
    component_G='{0:b}'.format(pixel[1]).zfill(NBITS)
    component_B='{0:b}'.format(pixel[2]).zfill(NBITS)
    print('                            '+'"'+component_R+component_G+component_B+'");')

# Finally, print the VHDL BRAM footer
print(
"""
begin

  -- When synthesizing this process, the synthesizer infers a BRAM
  process(clk)
  begin
    if (rising_edge(clk)) then
      if (we = '1') then
        ram(to_integer(addri)) <= datai;
      end if;
      datao <= ram(to_integer(addri));
    end if;
  end process;

end""", ARCH_NAME,""";"""
)
