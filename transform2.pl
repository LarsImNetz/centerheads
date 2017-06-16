#!/usr/bin/perl

use strict;
use Getopt::Long;
use File::Basename;

sub errorAdaption($);
sub splitExtension($);
sub print_usage(*);

our $help;                    # Help option flag
our $version;                 # Version option flag

# Parse command line options
if (!GetOptions(
         "help"         => \$help,
         "version"      => \$version
    )) {
    print_usage(*STDERR);
    exit(1);
}
# Check for help option
if ($help) {
    print_usage(*STDOUT);
    exit(0);
}

my $statusFile;
if ($#ARGV < 0) {
    print("No parameter to check-face.txt given use default\n");
    $statusFile = "check-face/check-face.txt";
}
else {
    $statusFile = $ARGV[0]
}
print " statusfile: $statusFile\n";

if ( ! -e "$statusFile" ) {
    print "Das Status-File $statusFile konnte nicht gefunden werden!\n";
    exit(1);
}

my $line;
local *FILE;
my @values;

if (open(FILE, "$statusFile")) {
    while ($line = <FILE>) {
        chomp($line);
        print $line . "\n";
        @values = split (' ', $line);
        if ($values[0] eq '#' || $values[0] eq "##") {
            next;
        }

        print "File: $values[0] size: $values[2] $values[3]\n";
        my $outfile = createOutfile($values[0]);
        if ( -e "$outfile" ) {
            print "Picture already exists.\n";
            next;
        }

        createImage($values[5], $values[6], $values[7], $values[8], 50, $values[0], $outfile, $values[2], $values[3]);
    }
    close(FILE);
}
else {
    print "Can't open $statusFile\n";
    exit(1);
}
exit(0);

sub createOutfile($) {
    my $source = shift;
    my $picbasename = basename($source);
    my $picbasename_no_extension;
    my $extension;
    ($picbasename_no_extension, $extension) = splitExtension($picbasename);

    my $outfile = "new-image/${picbasename_no_extension}.png";
    return $outfile;
}

sub createImage($$$$$$$) {
    my $x = shift;
    my $y = shift;
    my $w = shift;
    my $h = shift;
    my $percent = shift;
    my $source = shift;
    my $outfile = shift;
    my $fullx = shift;
    my $fully = shift;
    
#     my $hhalf = $h / 2;
#     print "hhalf:=$hhalf\n";
#     my $h1 = $hhalf + 0.2 * $hhalf + 0.2 * $hhalf;
#     print "h1:=$h1\n";
#     my $newy = $y + 0.8 * $hhalf - 2 * $h1;
#     print "newy:=$newy\n";
#     my $newh = int(6 * $h1);
#     print "newh:=$newh\n";
# 
#     my $newx = $x + $hhalf - 3 * $h1;
#     print "newx:=$newx\n";
#     my $neww = int(6 * $h1);
#     print "neww:=$neww\n";
#

    my $sizeOverHead = 5/8 * $h;
    my $sizeUnderHead = 3/4 * $h;
    
    my $newy = $y - $sizeOverHead;
    print "newy:=$newy\n";
    my $newh = int($sizeOverHead + $h + $sizeUnderHead);
    print "newh:=$newh\n";

    my $sizeLeftFromHead = 3/4 * $h;
    my $newx = $x - $sizeLeftFromHead;
    print "newx:=$newx\n";
    my $neww = $newh;
    print "neww:=$neww\n";
    
    $newx = int($newx);
    $newy = int($newy);
    
    # Wenn unten etwas fehlt, einfach etwas nach oben schieben
    if ($newy + $newh > $fully) {
        my $deltay = $newy + $newh - $fully;
        print "deltay:=$deltay";
        $newy = $newy - $deltay;
    }
#     if ($newx < 0) {
#         $newx = 0;
#     }
#     if ($newy < 0) {
#         $newy = 0;
#     }
# 
#     if ($newx + $neww > $fullx) {
#         $neww = $fullx - $newx - 1;
#         print "WARNING: too wide\n";
#     }
#     if ($newy + $newh > $fully) {
#         $newh = $fully - $newy - 1;
#         print "WARNING: too high\n";
#     }
#     
    my $vznewx = "+${newx}";
    my $vznewy = "+${newy}";
    my $important = "";
    $important = "\\!";
    
    if ($newx < 0) {
        $vznewx = "${newx}";
    }
    if ($newy < 0) {
        $vznewy = "${newy}";
    }
    my $geometry = "${neww}x${newh}${vznewx}${vznewy}${important}";

    my $command = "convert $source -crop $geometry -background transparent -flatten $outfile";
    print $command . "\n";
    system($command);
    my $error = errorAdaption($?);
    if ( $error != 0 ) {
        print "Warning: $error failed at Percent:$percent on image: $source\n";
    }
    print "\n";

    return $error;
}

# ------------------------------------------------------------------------------
sub errorAdaption($)
{
    my $error = shift;
    if ($error != 0)
    {
        $error = $error / 256;
    }
    if ($error > 127)
    {
        $error = $error - 256;
    }
    return $error;
}
# ------------------------------------------------------------------------------
#
# split a given name into its real name and a extension with dot
#
#
sub splitExtension($)
{
    my $sCurrentName = shift;

    my $sExtension = "";
    my $sNameWithoutExtension;

    # search for the last point in the current filename
    my $nLastPoint = rindex($sCurrentName, ".");
    if ($nLastPoint > 0)
    {
        $sExtension = substr($sCurrentName, $nLastPoint);
        $sNameWithoutExtension = substr($sCurrentName, 0, $nLastPoint);
    }
    else
    {
        $sNameWithoutExtension = $sCurrentName;
    }
    return $sNameWithoutExtension, $sExtension;
}
# ----------------------------------------------------------------------------
sub print_usage(*)
{
    local *HANDLE = $_[0];
    my $tool_name = basename($0);

    print(HANDLE <<END_OF_USAGE);

Usage: $tool_name [OPTIONS] path

    -f, --filter              File filter, default if not given (.wav\$)
    -h, --help                Print this help, then exit
    -v, --version             Print version number, then exit

END_OF_USAGE
    ;
}
