#!/usr/bin/perl
#
#	NOTE: the image (cat_mono.pcx) needs to be a monochrome PCX file!  
#   Reduce color depth to '2' (GRAYSCALE is too many colors)

use strict;
use warnings;
use EPL_GW qw(GW_create $GW_x $GW_y);
my $filename = "EPL2_document.lp";

#  For TESTING, uncomment this block
#  This will generate a complete test label (because $GW_x and $GW_y are not set)
#my $image = GW_create("cat_mono.pcx");
#open my $fh, ">", $filename or die "$filename: $!\n";
#print $fh $image;

#  For PRODUCTION, use this block
#  this will generate a GW command block to insert into your EPL2 statement
$GW_x = 50;
$GW_y = 120;
my $picture = GW_create("cat_mono.pcx");
my $lf = "\x0A";										# EPL requires LF only (not CR/LF)
my $image = "N${lf}ZT${lf}";							# New label, start from TOP
$image .=  "A60,40,0,4,1,1,N,\"cat_mono.pcx\"${lf}";	# Write text
$image .= "${picture}${lf}P1${lf}";						# Draw image with binary data in $picture
open my $fh, ">", $filename or die "$filename: $!\n";	
print $fh $image;

#   From command line (assuming ZEBRA_PRINTER is installed
#   on your workstation as a RAW print device) or look into
#   the Printer module in CPAN to print from your code.
#~$ lp -d ZEBRA_PRINTER EPL2_document.txt


