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
        my $source = $values[0];
        
        print "File: $source size: $values[2] $values[3]\n";
        my $outfile = createOutfile($values[0]);
        if ( -e "$outfile" ) {
            print "Picture already exists.\n";
            next;
        }
        my $fx;
        my $fy;
        my $fw;
        my $fh;
        if ( $values[4] eq "HANDMADE" ) {
            # Handgemachte Erkennung
            # Angegeben wird ein Punkt auf dem Nasenruecken und 
            # ein Punkt links am Ohr, der grob beschreibt wie gross das Gesicht ist
            # Tip: Ist das Gesicht zu gross, den Punkt etwas weiter nach links legen.
            my $nosex = $values[5];
            my $nosey = $values[6];
            my $noseleft = $values[7];
            my $delta = $nosex - $noseleft;
            $fx = $nosex - $delta;
            $fy = $nosey - $delta;
            $fw = 2 * $delta;
            $fh = 2 * $delta;
        }
        elsif ( $values[4] eq "FACE" ) {
            # Die automatische Erkennung ueber das facedetect Tool
            $fx = $values[5];
            $fy = $values[6];
            $fw = $values[7];
            $fh = $values[8];
        }
        else {
            print "WARNING: unknown line: $line\n";
            next;
        }
        createImage($fx, $fy, $fw, $fh, 50, $source, $outfile, $values[2], $values[3]);
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
    
    my $sizeOverHead = 5/8 * $h;
    my $sizeUnderHead = 3/4 * $h;
    
    my $newy = $y - $sizeOverHead;
    my $newh = int($sizeOverHead + $h + $sizeUnderHead);

    my $sizeLeftFromHead = 3/4 * $h;
    my $newx = $x - $sizeLeftFromHead;
    my $neww = $newh;
    
    $newx = int($newx);
    $newy = int($newy);
    
    # Wenn unten etwas fehlt, einfach etwas nach oben schieben
    if ($newy + $newh > $fully) {
        my $deltay = $newy + $newh - $fully;
        $newy = $newy - $deltay;
    }

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
