# -*- perl -*-

# t/003_ismode.t - check mode names are ok

use Test::Simple tests => 6;
use Music::Scales;

ok(!is_mode('x'));
ok(is_mode('major'));
ok(is_mode('maj'));
ok(is_mode('minor'));
ok(is_mode('min'));
ok(is_mode('m'));

