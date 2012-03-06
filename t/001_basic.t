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
# no nest scalar 
ok $v->check("aaa" , "ASCII");
ok $v->check("111" , "INT");

# no nest scalar exception
ok !$v->check("aaa" , "INT");
ok $v->has_error;
is $v->get_error->[0]{message},INVALID('INT');
is $v->get_error->[0]{position},'$param';
ok $v->check("111" , "ASCII");
ok !$v->has_error;

# arrayref 
ok $v->check([111 , 1222, 333] , ["INT"]);
ok !$v->has_error;
# arrayref exception
ok !$v->check([qw/aaa 222 ccc/] , ["INT"]);
ok $v->has_error;
is $v->get_error->[0]{message},INVALID('INT');
is $v->get_error->[0]{position},'$param->[0]';
is $v->get_error->[1]{message},INVALID('INT');
is $v->get_error->[1]{position},'$param->[2]';
ok !$v->get_error->[2];

# hash ref 
ok $v->check({ hoge => 'fuga'},{hoge => "ASCII"});
ok $v->check({ hoge => 111},{hoge => "ASCII"});
ok $v->check({ hoge => 111},{hoge => "INT"});

# hash ref exception
ok !$v->check({ hoge => 'fuga'},{hoge => "INT"});
ok $v->has_error;
is $v->get_error->[0]{message},INVALID('INT');
is $v->get_error->[0]{position},'$param->{hoge}';

# hash ref multivalue
ok $v->check({hoge => 'fuga' , fuga => "fuga" },{hoge => "ASCII" , fuga=> "ASCII"});
ok $v->check({hoge => "fuga" , fuga => "fuga" },{hoge => "ASCII" , fuga => "ASCII"});
ok $v->check({hoge => 111 , fuga => "fuga"},{hoge => "INT" , fuga => "ASCII"});

# hash ref multivalue exception
ok !$v->check({hoge => "fuga" , fuga => "fuga" },{hoge => "INT" , fuga => "INT"});
ok $v->has_error;
is $v->get_error->[0]{message},INVALID('INT');
is $v->get_error->[0]{position},'$param->{fuga}';
is $v->get_error->[1]{message},INVALID('INT');
is $v->get_error->[1]{position},'$param->{hoge}';

# nested ref
ok $v->check({hoge => [qw/111 222 333/] , fuga => "fuga" },{hoge => ['INT'] , fuga=> "ASCII"});
ok $v->check({hoge =>  {hoge => "hpge"} , fuga => "fuga" },{hoge => {hoge => "ASCII"}, fuga=> "ASCII"});
ok $v->check({hoge =>  {hoge => 111} , fuga => "fuga" },{hoge => {hoge => "INT"}, fuga=> "ASCII"});

# nested ref exception
ok !$v->check({hoge => [qw/aaa vvv ccc/] , fuga => "fuga" },{hoge => ['INT'] , fuga=> "ASCII"});

ok $v->has_error;
is $v->get_error->[0]{message},INVALID('INT');
is $v->get_error->[0]{position},'$param->{hoge}->[0]';
is $v->get_error->[1]{message},INVALID('INT');
is $v->get_error->[1]{position},'$param->{hoge}->[1]';
is $v->get_error->[2]{message},INVALID('INT');
is $v->get_error->[2]{position},'$param->{hoge}->[2]';

ok !$v->check({hoge =>  {hoge => "hpge"} , fuga => "fuga" },{hoge => {hoge => "INT"}, fuga=> "ASCII"});
ok !$v->check({hoge =>  {hoge => 111} , fuga => "fuga" },{hoge => {hoge => "INT"}, fuga=> "INT"});

done_testing;
