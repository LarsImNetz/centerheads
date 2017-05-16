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

if ($#ARGV < 0) {
    print("No parameter given, assume '.'\n");
    exit(1);
}
# print "echo $#ARGV\n";

my $x = $ARGV[0];
my $y = $ARGV[1];

print "Start position: $x,$y";

my $w = $ARGV[2];
my $h = $ARGV[3];

print " size: $w,$h";

my $picname = $ARGV[4];
print " picture: $picname\n";

if ( ! -e "$picname" ) {
    print "Das Bild $picname konnte nicht gefunden werden!\n";
    exit(1);
}

my $picbasename = basename($picname);
my $picbasename_no_extension;
my $extension;
($picbasename_no_extension, $extension) = splitExtension($picbasename);

my $percent = 90;
my $outfile = "${picbasename_no_extension}_${percent}.png";

if ( -e "$outfile" ) {
    print "Picture already exists.\n";
    exit(0);
}

my $error = 0;
do {
    $outfile = "${picbasename_no_extension}_${percent}.png";

    my $identify = "identify $picname";
    system($identify);
    
    $error = createImage($x,$y,$w,$h,$percent,$outfile, $picname);
    $percent -= 2;
} while ($error != 0 && $percent > 40);

sub createImage($$$$$$$) {
    my $x = shift;
    my $y = shift;
    my $w = shift;
    my $h = shift;
    my $percent = shift;
    my $outfile = shift;
    my $source = shift;
    
    my $xpercent = $w / 100 * $percent;
    my $ypercent = $h / 100 * $percent;
    
    my $newx = int($x - $xpercent);
    my $newy = int($y - $ypercent);

    if ($newx < 0) {$newx = 0;}
    if ($newy < 0) {$newy = 0;}
    
    my $neww = int($w + 2 * $xpercent);
    my $newh = int($h + 2 * $xpercent);
    
    my $geometry = "${neww}x${newh}+${newx}+${newy}";

    my $command = "convert $source -crop $geometry +repage $outfile";
    print $command . "\n";
    system($command);
    my $error = errorAdaption($?);
    if ( $error != 0 ) {
        print "Warning: $error failed at Percent:$percent on image: $picname\n";
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
