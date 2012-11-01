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

ok $v->check({hoge =>  "hoge" },{hoge=> ["ASCII","NOT_BLANK" , ['LENGTH' , 1 , 15]]});
ok !$v->check({hoge =>  "hogehogehogehoge" },{hoge=> ["ASCII","NOT_BLANK" , ['LENGTH' , 1 , 15]]});

use Data::Dumper;
warn Dumper $v->get_error;

ok $v->check({hoge =>  "hoge" },{hoge=> ["ASCII","NOT_BLANK" , ['LENGTH' , 4]]});
ok !$v->check({hoge =>  "hoge" },{hoge=> ["ASCII","NOT_BLANK" , ['LENGTH' , 3]]});
ok !$v->check({hoge =>  "hoge" },{hoge=> ["ASCII","NOT_BLANK" , ['LENGTH' , 5]]});
ok $v->check({},{hoge=> ["ASCII", ['LENGTH' , 5]]});
ok $v->check({ hoge=> ""},{hoge=> ["ASCII", ['LENGTH' , 5]]});
ok !$v->check({},{hoge=> ["ASCII", 'NOT_BLANK', ['LENGTH' , 5]]});

ok $v->check("hoge" ,["ASCII","NOT_BLANK" , ['LENGTH' , 1 , 15]]);

done_testing;
