#!/usr/bin/perl -w

use strict;
use Speech::Google::TTS;


my $bla = $ARGV[0];


my $tts = Speech::Google::TTS->new();

$tts->{'lang'} = 'de';
$tts->say_text("$bla");
system "mplayer", $tts->as_filename();
