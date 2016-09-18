# APL-Image-Utilities
Utility functions to get images in and out of  (GNU) APL.

The goal of this library is meant to assist in getting images in and out of APL, and not for processing images within APL.For example, computer vision algorithms and resizing an image are not in scope.


Currently only uncompressed  BMP3 (Microsoft Windows bitmap image (V3)) format is supported. If you have ImageMagick installed on your machine, The following line will turn any supported image file (here, input.png) into an uncompressed BMP3 file:

```convert input.png -compress NONE BMP3:output.bmp```

If you don't know if your system supports a specific file type, run:

```identify -list format```. 


# Usage:
There are only two top level functions that an application developer would use right now:


```IMG∆BMP∆40_read_from_path``` and ```IMG∆BMP∆bitmap_image_to_file```

```IMG∆BMP∆40_read_from_path``` takes a path as its right argument and returns a three-dimension array. The ```40``` in the function name is related to the size of the metadata in the uncompressed BMP3 format.  

```IMG∆BMP∆bitmap_image_to_file``` takes a path as a left argument, and expects a three-dimension array as the right argument. Any matrix that is of size 3×X×Y will work, for example: 

```'image.bmp ' IMG∆BMP∆bitmap_image_to_file 3 20 30 ⍴ ⍳100```
