#!perl -w
use strict;
use Test::More;
use utf8;

use Data::Compare::Type;

# test Data::Compare::Type here

sub HASHREF {'excepted hash ref'};
sub ARRAYREF {'excepted array ref'};
sub REF {'excepted ref'};
sub INVALID{'excepted ' . $_[0]};

my $v = Data::Compare::Type->new();

ok $v->check({hoge =>  "あ" },{hoge=> [['CHARTYPE' , 'HIRAGANA']]});
ok !$v->check({hoge =>  "ア" },{hoge=> [['CHARTYPE' , 'HIRAGANA']]});
ok !$v->check({hoge =>  "あ" },{hoge=> [['CHARTYPE' , 'KATAKANA']]});
ok $v->check({hoge =>  "ア" },{hoge=> [['CHARTYPE' , 'KATAKANA']]});

ok !$v->check({hoge =>  "アあ" },{hoge=> [['CHARTYPE' , 'HIRAGANA']]});
ok !$v->check({hoge =>  "あア" },{hoge=> [['CHARTYPE' , 'KATAKANA']]});

ok $v->check({hoge =>  "アあ" },{hoge=> [['CHARTYPE' , 'HIRAGANA','KATAKANA']]});
ok $v->check({hoge =>  "あア" },{hoge=> [['CHARTYPE' , 'KATAKANA','HIRAGANA']]});

done_testing;
