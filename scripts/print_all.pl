#!/usr/bin/perl

use strict;
use Music::Scales;

foreach my $note qw (C C# D D# E F F# G G# A A# B) {
	foreach my $mode (1..28) {
		my @notes = get_scale_notes($note,$mode);
		print join(" ",@notes),"\n";
		my %m = get_scale_offsets ($note,$mode);
		print join(" ",map {"$_=$m{$_}" } sort keys %m),"\n";
	}
}



