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

ok !$v->check({hoge =>  "Д" },{hoge=> [['CHARTYPE' , 'HIRAGANA']]});
ok $v->check({hoge =>  "Д" },{hoge=> [['CHARTYPE' , 'CYRILLIC']]});

ok $v->check({hoge =>  "α" },{hoge=> [['CHARTYPE' , 'GREEK']]});

ok $v->check({hoge =>  "∀" },{hoge=> [['CHARTYPE' , 'MATH']]});

ok $v->check({hoge =>  "Ⅳ" },{hoge=> [['CHARTYPE' , 'NUMBER']]});

ok $v->check("あ",['CHARTYPE' , 'HIRAGANA']);

ok $v->check("†",['CHARTYPE' , 'PUNCTUATION']);

ok $v->check('((((；ﾟДﾟ))))ｶﾞｸｶﾞｸﾌﾞﾙﾌﾞﾙ',['CHARTYPE' , qw/HIRAGANA KATAKANA GREEK ASCII CYRILLIC MATH NUMBER/]);

ok $v->check("藤",['CHARTYPE' , 'KANJI']);

done_testing;
