package Music::Scales;
use strict;
use Text::Abbrev;

BEGIN {
	use Exporter ();
	use vars qw ($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
	$VERSION     = 0.01;
	@ISA         = qw (Exporter);
	@EXPORT      = qw (get_scale_notes get_scale_nums get_scale_offsets);
}


=head1 NAME

 Scales - supply necessary notes / offsets for musical scales

=head1 SYNOPSIS

    use Music::Scales;

    my @maj = get_scale_notes('Eb');           # defaults to major
    print join(" ",@maj);                      # "Eb F G Ab Bb C D Eb"
    my @blues = get_scale_nums('bl');		   # 'bl','blu','blue','blues'
    print join(" ",@blues);                    # "Eb F G Ab Bb C D Eb"
    my %min = get_scale_offsets ('G','m',1);   # ascending harmonic minor
    print map {"$_=$min{$_}" } sort keys %min; # "A=0 B=-1 C=0 D=0 F=1 G=0"


=head1 DESCRIPTION

Given a keynote A-G and a scale-name, will return the scale, either as an array of notenames or as a hash of semitone-offsets for each note.

=head1 METHODS

=head2 get_scale_notes($notename[,$scale,$ascending,$keypref])

returns an array of notenames, starting from the given keynote and ascending up the given scale for one octave.

Scaletypes and valid values for $scale are listed below.

If $ascending is set and the mode is "minor" ('min' or 'm'), the leading note will be sharpened, providing an ascending melodic minor.

Enharmonic equivalencies are calculated using a set of defaults for each key, but can be overidden with $keypref, setting this to be either '#' or 'b' 
for sharps and flats respectively. These defaults are:
 
C='' Db='b' D='#' Eb='b' E='#' F='b' Gb='b' G='#' Ab='b' A='#' Bb='b' B='#'
 
'Minor' mode (where the keynote is shifted up a minor 3rd, resulting in G minor using 'Bb' rather than 'A#') are used for modes 2 and 6.
All other modes use the default mapping.

=head2 get_scale_offsets($notename[,$scale,$ascending,$keypref])

as get_scale(), except it returns a hash of notenames with the values being a semitone offset (-1, 0 or 1) as shown in the synopsis.

=head2 get_scale_nums($scale[,$ascending])

returns an array of semitone offsets for the requested scale.

=head1 SCALES 

Scales can be passed either by name or number.
The default scale is 'major' if none  / invalid is given.
Text::Abbrev is used on scalenames, so they can be as abbreviated as unambiguously possible ('dor','io' etc.).
Other abbreviations are shown in brackets.

  1 ionian
  1 major 
  2 dorian
  3 phrygian 
  4 lydian 
  5 mixolydian 
  6 aeolian 
  6 minor (m)
  7 locrian 
  8 blues 
  9 pentatonic (pmajor)
 10 chromatic 
 11 diminished 
 12 wholetone 
 13 augmented 
 14 hungarian minor 
 15 3 semitone 
 16 4 semitone 
 17 neapolitan minor (nmin)
 18 neapolitan major (nmaj)
 19 todi 
 20 marva 
 21 persian 
 22 oriental 
 23 romanian 
 24 pelog 
 25 iwato 
 26 hirajoshi 
 27 egyptian 
 28 pentatonic minor (pminor)

=head1 EXAMPLE

This will print every scale in every key, adjusting the enharmonic equivalents accordingly.

	foreach my $note qw (C C# D D# E F F# G G# A A# B) {
        foreach my $mode (1..28) {
            my @notes = get_scale_notes($note,$mode);
            print join(" ",@notes),"\n";
        }
    }


=head1 TODO
 
 Add further range of scales from http://www.cs.ruu.nl/pub/MIDI/DOC/scales.zip
 Improve enharmonic eqivalents.
 Microtones
 Frequency generation (although this is already done by PDL::Audio::Scale)
 Generate ragas,gamelan etc.  - maybe needs an 'ethnic' subset of modules

=head1 AUTHOR

Ben Daglish (bdaglish@surfnet-ds.co.uk)

=head1 BUGS 
 
Minor 'flat' scales not using sharps properly for leading notes etc. - to be fixed in a later version, hopefully.

All feedback most welcome.

=head1 COPYRIGHT

 Copyright (c) 2003, Ben Daglish. All Rights Reserved.
 This program is free software; you can redistribute
 it and/or modify it under the same terms as Perl itself.

 The full text of the license can be found in the
 LICENSE file included with this module.


=head1 SEE ALSO

PDL::Audio::Scale, perl(1).

=cut

my %modes = qw(ionian 1 major 1 dorian 2 phrygian 3 lydian 4 mixolydian 5
	aeolian 6 minor 6 m 6 locrian 7
	blues 8 pentatonic 9 pmaj 9 chromatic 10 diminished 11	wholetone 12
	augmented 13 hungarianminor 14 3semitone 15 4semitone 16 
	neapolitanminor 17 nmin 17 neapolitanmajor 18 nmaj 18
	todi 19 marva 20 persian 21 oriental 22 romanian 23 pelog 24
	iwato 25 hirajoshi 26 egyptian 27 pminor 28 pentatonicminor 28
);

my %abbrevs = abbrev(keys %modes);
while (my ($k,$v) = each %abbrevs) {
	$modes{$k} = $modes{$v};
}

my @scales=([0,2,4,5,7,9,11],	# Major (1-7)
			[0,3,5,6,7,10],		# Blues (8)
			[0,2,4,7,9],		# Pentatonic (9)
			[0,1,2,3,4,5,6,7,8,9,10,11],# Chromatic (10)
			[0,2,3,5,6,8,9,11],	# Diminished (11)
			[0,2,4,6,8,10],		# Whole tone(12)
			[0,3,4,7,8,11],		# Augmented (13)
			[0,2,3,6,7,8,11],	# Hungarian minor (14)
			[0,3,6,9],			# 3 semitone (dimished arpeggio) (15)
			[0,4,8],			# 4 semitone (augmented arpeggio) (16)
			[0,1,3,5,7,8,11],	# Neapolitan minor  (17)
			[0,1,3,5,7,9,11],	# Neapolitan major (18)
			[0,1,3,6,7,8,11],	# Todi (Indian) (19)
			[0,1,4,6,7,9,11],	# Marva (Indian) (20)
			[0,1,4,5,6,8,11],	# Persian (21)
			[0,1,4,5,6,9,10],	# Oriental (22)
			[0,2,3,6,7,9,10],	# Romanian (23)
			[0,1,3,7,10],		# Pelog (Balinese) (24)
			[0,1,5,6,10],		# Iwato (Japanese) (25)
			[0,2,3,7,8],		# Hirajoshi (Japanese) (26)
			[0,2,5,7,10],		# Egyptian (27)
			[0,3,5,7,10],		# Pentatonic Minor (28)
);

sub get_scale_nums {
	my ($mode,$ascending) = @_;
	$mode = get_mode($mode);
	$ascending = 0 unless ($ascending && $mode == 2);
	my @dists = @{$scales[($mode < 8)? 0 : $mode - 7]};
	$mode = 1 if ($mode > 7);
	$dists[4]++ if $ascending;
	foreach (1..$mode-1) {push @dists, shift @dists;}
	@dists;
}

sub get_scale_notes {
	my ($keynote,$mode,$ascending,$keypref) = @_;
	my %note2num = qw(C 0 C# 1 DB 1 D 2 D# 3 EB 3 E 4 F 5 F# 6 GB 6 G 7 G# 8 AB 8 A 9 A# 10 BB 10 B 11);
	$keynote = $note2num{uc($keynote)} unless $keynote =~/^[0-9]+$/;
	return if $keynote eq '';
	$mode = get_mode($mode);
	my @dists = get_scale_nums($mode,$ascending);
	my @scale = map {($_+$keynote-$dists[0])%12} @dists;
	my $kpstr = "#b#b#bb#b#b#";
	$kpstr = "b#bb#b#b##b#" if ($mode == 2 || $mode == 6);
	$keypref = substr($kpstr,$keynote,1) unless $keypref;
	my %num2note = (($keypref eq 'b') 
		? qw(0 C 1 Db 2 D 3 Eb 4 E 5 F 6 Gb 7 G 8 Ab 9 A 10 Bb 11 B)
		: qw(0 C 1 C# 2 D 3 D# 4 E 5 F 6 F# 7 G 8 G# 9 A 10 A# 11 B));
	return map {$num2note{$_}} @scale;
}

sub get_scale_offsets {
	my @scale = get_scale_notes(@_);
	my %key_alts = qw(C 0 D 0 E 0 F 0 G 0 A 0 B 0);
	foreach (@scale) {
		$key_alts{$_}++ if s/#//;
		$key_alts{$_}-- if s/b//;
	}
	%key_alts;
}

sub get_mode {
	my $mode = shift();
	$mode =~ s/[^a-zA-Z0-9]//g;
	$mode = $modes{lc($mode)} unless $mode =~/^[0-9]+$/;
	$mode = 1 if ($mode > 28);
	$mode || 1 ;	#default to major
}

1; 
__END__

