# EPL_Image_Printing
Perl module to help print images to a Eltron / Zebra (that speaks EPL2) Thermal printer

This module converts a PCX MONOCHROME image into binary data to feed to a 
Eltron or Zebra thermal printer (used in shipping, mostly).

If $GW_x and $GW_y values are not supplied, it returns a complete label to send
to the printer for testing.  

You must supply $GW_x and $GW_y values to get the correct data back to insert into
your own label.
