# EPL_Image_Printing
Perl module to help print images to a Eltron / Zebra (that speaks EPL2) Thermal printer

This module converts a PCX MONOCHROME image into binary data to feed to a 
Eltron or Zebra thermal printer (used in shipping, mostly).

If $GW_x and $GW_y values are not supplied, it returns a complete label to send
to the printer for testing.  

You must supply $GW_x and $GW_y values to get the correct data back to insert into
your own label.

Normally, you can open the finished label in a text editor to see the commands
being sent to the printer.
THAT'S NOT THE CASE HERE!
Because the image is in raw binary, text editors will freak out when you try to
open the label file (in the test case, it's called EPL2_document.lp).

If you want to see the contents, you'll need to use a HEX editor (or something that
can deal with binary)
