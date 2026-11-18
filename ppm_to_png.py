# Requires Pillow: py -m pip install pillow
from PIL import Image
Image.open('vga_output.ppm').save('vga_output.png')
print('Saved vga_output.png')
