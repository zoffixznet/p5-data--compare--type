use strict;
use 5.14.0;

use lib './lib';
use Data::Compare::Type;

my $validate = Data::Compare::Type->new();
$validate->check([111] , ["ASCII"]);

