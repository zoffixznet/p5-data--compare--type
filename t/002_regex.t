#!perl -w
use utf8;
use strict;
use Test::More;

use Data::Compare::Type::Regex;

# test Data::Compare::Type here

# NOT_BLANK

ok Data::Compare::Type::Regex::NOT_BLANK(1);
ok Data::Compare::Type::Regex::NOT_BLANK("aaa");
ok Data::Compare::Type::Regex::NOT_BLANK(0);
ok Data::Compare::Type::Regex::NOT_BLANK("0");
ok !Data::Compare::Type::Regex::NOT_BLANK();


# INT
ok Data::Compare::Type::Regex::INT(1);
ok Data::Compare::Type::Regex::INT(100);
ok Data::Compare::Type::Regex::INT(-100);
ok Data::Compare::Type::Regex::INT("1000000000000000000000000");
ok Data::Compare::Type::Regex::INT("-100000000000001");

ok !Data::Compare::Type::Regex::INT("aaa");
ok !Data::Compare::Type::Regex::INT("111aaa");
ok !Data::Compare::Type::Regex::INT("aaa111");
ok !Data::Compare::Type::Regex::INT("aaa111aaa");
ok !Data::Compare::Type::Regex::INT("111aaa111");

ok !Data::Compare::Type::Regex::INT(0.13);
ok !Data::Compare::Type::Regex::INT(-0.13);
ok !Data::Compare::Type::Regex::INT(1.13);
ok !Data::Compare::Type::Regex::INT(-1.13);

# ASCII
ok Data::Compare::Type::Regex::ASCII(1);
ok Data::Compare::Type::Regex::ASCII("0");
ok Data::Compare::Type::Regex::ASCII(0.1);
ok Data::Compare::Type::Regex::ASCII("0.1");
ok Data::Compare::Type::Regex::ASCII("hoge");
ok Data::Compare::Type::Regex::ASCII(0);
ok Data::Compare::Type::Regex::ASCII(0.0);

ok !Data::Compare::Type::Regex::ASCII("あいうえお");

# DECIMAL

ok Data::Compare::Type::Regex::DECIMAL(0.13);
ok Data::Compare::Type::Regex::DECIMAL(-0.13);
ok Data::Compare::Type::Regex::DECIMAL(1.13);
ok Data::Compare::Type::Regex::DECIMAL(-1.13);

ok Data::Compare::Type::Regex::DECIMAL(13);
ok Data::Compare::Type::Regex::DECIMAL(-13);
ok !Data::Compare::Type::Regex::DECIMAL("aaa");
ok !Data::Compare::Type::Regex::DECIMAL("111aaa");
ok !Data::Compare::Type::Regex::DECIMAL("aaa111");
ok !Data::Compare::Type::Regex::DECIMAL("aaa111aaa");
ok !Data::Compare::Type::Regex::DECIMAL("111aaa111");

ok Data::Compare::Type::Regex::DATETIME("2012-12-20 00:23:59");
ok Data::Compare::Type::Regex::DATETIME("2012/12/20 00:23:59");
ok Data::Compare::Type::Regex::DATETIME("2012-12-20 00-23-59");
ok Data::Compare::Type::Regex::DATETIME("2012/12/20 00-23-59");
ok !Data::Compare::Type::Regex::DATETIME("2012-12-20 24:28:59");
ok !Data::Compare::Type::Regex::DATETIME("2012-12-32 00:23:59");
ok !Data::Compare::Type::Regex::DATETIME("aaaaa");

ok Data::Compare::Type::Regex::DATE("2012-12-20");
ok Data::Compare::Type::Regex::DATE("2012/12/20");
ok Data::Compare::Type::Regex::DATE("2012-12-20");
ok Data::Compare::Type::Regex::DATE("2012/12/20");
ok Data::Compare::Type::Regex::TIME("24-28-59");
ok Data::Compare::Type::Regex::TIME("00-23-59");
ok Data::Compare::Type::Regex::TIME("24:28:59");
ok Data::Compare::Type::Regex::TIME("00:23:59");
ok !Data::Compare::Type::Regex::DATE("aaaaa");
ok !Data::Compare::Type::Regex::TIME("aaaaa");

ok Data::Compare::Type::Regex::TINYINT(0);
ok Data::Compare::Type::Regex::TINYINT(1);
ok Data::Compare::Type::Regex::TINYINT("0");
ok Data::Compare::Type::Regex::TINYINT("1");
ok !Data::Compare::Type::Regex::TINYINT(13);
ok !Data::Compare::Type::Regex::TINYINT(-13);
ok !Data::Compare::Type::Regex::TINYINT("aaa");
ok !Data::Compare::Type::Regex::TINYINT("111aaa");
ok !Data::Compare::Type::Regex::TINYINT("aaa111");
ok !Data::Compare::Type::Regex::TINYINT("aaa111aaa");
ok !Data::Compare::Type::Regex::TINYINT("111aaa111");

done_testing;
