# -*- perl -*-

# t/004_scalePDL.t - check scale_to_PDL is ok

use Test::Simple tests => 3;
use Music::Scales;

ok(join(" ",scale_to_PDL(4,get_scale_notes('G','hm'))) eq "g4 a4 bf4 c5 d5 ef5 fs5");
ok(join(" ",scale_to_PDL(2,get_scale_notes('C#','30'))) eq "cs2 e2 fs2 gs2 b2");
ok(join(" ",scale_to_PDL(5,get_scale_notes('F#','30'))) eq "fs5 a5 b5 cs6 e6");

