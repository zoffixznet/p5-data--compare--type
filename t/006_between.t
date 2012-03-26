#!perl -w
use strict;
use Test::More;

use Data::Compare::Type;

# test Data::Compare::Type here

sub HASHREF {'excepted hash ref'};
sub ARRAYREF {'excepted array ref'};
sub REF {'excepted ref'};
sub INVALID{'excepted ' . $_[0]};

my $v = Data::Compare::Type->new();

ok $v->check({hoge =>  8 },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 1 , 15]]});
ok $v->check({hoge =>  15 },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 1 , 15]]});
ok $v->check({hoge =>  1 },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 1 , 15]]});
ok !$v->check({hoge =>  16 },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 1 , 15]]});
ok !$v->check({hoge =>  0 },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 1 , 15]]});

ok $v->check({hoge =>  4  },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 4]]});
ok !$v->check({hoge => 4  },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 3]]});
ok !$v->check({hoge => 4  },{hoge=> ["INT","NOT_BLANK" , ['BETWEEN' , 5]]});

done_testing;
