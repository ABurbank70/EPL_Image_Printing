package EPL_GW;

use strict;
use Carp;
use Image::Magick;

our (@ISA, @EXPORT, @EXPORT_OK);
our ($GW_x, $GW_y);

require Exporter; @ISA=qw(Exporter);

@EXPORT=qw(GW_create);
@EXPORT_OK=qw($GW_x $GW_y);

sub GW_create {
  my ($pcx_in) = @_;

  if ( -R $pcx_in) {
  my %zebra_map = (
    '0000' => '0' , 
    '0001' => '1' , 
    '0010' => '2' , 
    '0011' => '3' , 
    '0100' => '4' , 
    '0101' => '5' , 
    '0110' => '6' , 
    '0111' => '7' , 
    '1000' => '8' , 
    '1001' => '9' , 
    '1010' => 'A' , 
    '1011' => 'B' , 
    '1100' => 'C' , 
    '1101' => 'D' , 
    '1110' => 'E' , 
    '1111' => 'F' , 
  );

  my ($test, $return);
  if (!$GW_x or !$GW_y) {
	$GW_x = 10;
	$GW_y = 10;
	$test = 1;
  }

  my $pcx_image = Image::Magick->new;
  $pcx_image->Read($pcx_in);
  $pcx_image->Set(monochrome=>'True');	
  
  my ($width, $height) = $pcx_image->Get('width','height');
  my $zebra_width = int ($width/8);
  my $zebra_height = $height;

  # Image gets slanty if width %8 != 0, crop it here
  # or fix it yourself before using it here.
  if ( ($zebra_width * 8) != $width) {
    my $error = $pcx_image->Crop(width=>($zebra_width * 8));
    ($width, $height) = $pcx_image->Get('width','height');
  }
  my $raw_hex_image_string;
  my $lf = "\x0A";

  for (my $row=0;$row<=$height;$row++) {
	my (@row_of_px, @bitmap_row);
	@row_of_px = $pcx_image->GetPixels('x'=>0,'y'=>$row,'normalize'=>'True');
	for (my $i=0; $i<= $#row_of_px; $i++) {
	  if ($i % 3 == 0) {
	    push @bitmap_row, $row_of_px[$i];
	  }
	}
	for (my $j=0; $j<= $#bitmap_row; $j +=4) {
	  my $four_tuple = $bitmap_row[$j];
  	  $four_tuple .= $bitmap_row[$j+1];
	  $four_tuple .= $bitmap_row[$j+2];
	  $four_tuple .= $bitmap_row[$j+3];
	  $raw_hex_image_string .= $zebra_map{$four_tuple};
	}
  }
  my $zebra_bmp = pack "H*" , $raw_hex_image_string;	

  if($test) {
    $return = "N$lf" . "ZT$lf" . "GW$GW_x,$GW_y,$zebra_width,$zebra_height,$zebra_bmp" . "$lf" . "P1$lf";
  }
  else {
    $return = "GW${GW_x},${GW_y},${zebra_width},${zebra_height},${zebra_bmp}";
  }
  
  return $return;

  }
}
1;

=pod

=head1 Name

EPL_GW Perl module for printing PCX images to an Eltron / Zebra Thermal Printer in EPL2 language (using GW command)

=head1 Synopsis

Convert a PCX image (monochrome, please) into binary format to send to an EPL2 compliant printer, which involves a bit of math.

=head1 Authors

Esumina-san, Anthony Burbank

=head2 Requires

=over 5

=item *

B<Image::Magick> from C<perlmagick> in the repository to get information about the image

=item *

B<filename.pcx> image must be a monochrome PCX image to pass to the function as C<$image = GW_create("filename.pcx");>.  The default position for testing is 10px down, 10px left on label stock.  However, you can import $GW_x and $GW_y and set them to position the image where you want.  In fact, you need to do that or you'll get a complete test label.

=item *

B<use EPL_GW qw(GW_create $GW_x $GW_y);> should be in your program to use this code properly.

=back

=head1 Bugs

There's no error checking on values.  The code will only test to see if the filename supplied is readable.  It won't check to make sure it's a valid PCX file, that it's monochrome, or that it will fit on the page (NOTE: Older Eltrons will drop the whole image if it won't fit, newer ones will truncate the image so part of it shows).  A standard 4x6 label is around 750px wide.
Also, you may end up with a slanty image if the width in px is not divisable by 8 ($width % 8 != 0).  The package will crop the image for you to prevent that from happening, but that may drop off something you want.
If you don't specify 'x' and 'y', the return value will be a complete label "Start -> GW Data -> Print one copy" for testing purposes.  Otherwise, it will return just the image data (a complete GW line not terminated by \x0A -- you have to add that yourself) to plug into your own label.

=head1 Credit

I didn't create this.  It's taken from code examples from L<http://blog.esumina.com/2011/10/printing-bitmaps-and-chinese-to-zebra.html>, who did all the work and figured out the math.  I just cleaned up (I hope) the code and packaged this into a module for my own (and others) use.

=head1 License

  Copyright (c) 2017 Anthony Burbank

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
 
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

=cut
