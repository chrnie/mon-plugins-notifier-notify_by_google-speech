#!/usr/bin/perl -w
#this script uses google translate and needs an internet connection

=head1 NAME

notify_by_google-speech.pl uses voice output from translate.google.com and offers text-to-speech for icinga

=head1 SYNOPSIS

notify_by_google-speech.pl
    -v
    -h
    -V

offers text-to-speech for icinga

=head1 OPTIONS

=over

=item -n|NOTIFICATIONTYPE

=item -S|HOSTSTATE

=item -O|HOSTOUTPUT

=item -a|NOTIFICATIONAUTHORNAME

=item -c|NOTIFICATIONCOMMENT

=item -d|SERVICEDESC

=item -H|HOSTALIAS

=item -s|SERVICESTATE

=item -D|LONGDATETIME

=item -o|SERVICEOUTPUT

=item -v|--verbose <path to logfile>

Verbose mode. If no logfile is specified, verbose output will be printend to STDOUT

=item -h|--help

print help page

=item -V|--version

print plugin version

=cut

use strict;
use File::Basename;
use Pod::Usage;
use Getopt::Long;
use Speech::Google::TTS;


use vars qw(
  $version
  $progname
  $NOTIFICATIONTYPE
  $HOSTSTATE
  $HOSTOUTPUT
  $NOTIFICATIONAUTHORNAME
  $NOTIFICATIONCOMMENT
  $SERVICEDESC
  $HOSTALIAS
  $SERVICESTATE
  $LONGDATETIME
  $SERVICEOUTPUT
  $optHelp
  $optVersion
  $optVerbose
  $text
  );

$progname = basename($0);
$version = 0.002;



# get options
Getopt::Long::Configure('bundling');
GetOptions (
   "n|NOTIFICATIONTYPE:s"        => \$NOTIFICATIONTYPE,
   "S|HOSTSTATE:s"               => \$HOSTSTATE,
   "O|HOSTOUTPUT:s"              => \$HOSTOUTPUT,
   "a|NOTIFICATIONAUTHORNAME:s"  => \$NOTIFICATIONAUTHORNAME,
   "c|NOTIFICATIONCOMMENT:s"     => \$NOTIFICATIONCOMMENT,
   "d|SERVICEDESC:s"             => \$SERVICEDESC,
   "H|HOSTALIAS:s"               => \$HOSTALIAS,
   "s|SERVICESTATE:s"            => \$SERVICESTATE,
   "D|LONGDATETIME:s"            => \$LONGDATETIME,
   "o|SERVICEOUTPUT:s"           => \$SERVICEOUTPUT,
   "h|help"                      => \$optHelp,
   "v|verbose"                   => \$optVerbose,
   "V|version"                   => \$optVersion
  ) || die "Try `$progname --help' for more information.\n";



# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
# help and version page and sample config...
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# should print version?
if (defined $optVersion) { print $version."\n"; exit 0; }

# should print help?
if ($optHelp) { pod2usage(1); }


if (defined $SERVICEDESC) {
  $text = "$NOTIFICATIONTYPE: Service $SERVICEDESC on $HOSTALIAS is $SERVICESTATE since $LONGDATETIME.";
  print "Verbose: $text\n" if defined $optVerbose;
} else {
  $text = "$NOTIFICATIONTYPE: Host $HOSTALIAS is $HOSTSTATE since $LONGDATETIME.";
  print "Verbose: $text\n" if defined $optVerbose;
}

my $tts = Speech::Google::TTS->new();

$tts->{'lang'} = 'de';
$tts->say_text("$text");
system "mplayer", $tts->as_filename();

