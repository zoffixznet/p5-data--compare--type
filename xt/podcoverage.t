#!perl -w
use Test::More;
eval q{use Test::Pod::Coverage 1.04};
plan skip_all => 'Test::Pod::Coverage 1.04 required for testing POD coverage'
    if $@;

all_pod_coverage_ok({
    also_private => [qw(
        unimport 
        BUILD 
        DEMOLISH 
        init_meta new
        ARRAYREF
        BETWEEN_ERROR
        CHARS_ERROR
        HASHREF
        HASHVALUE
        INVALID
        LENGTH_ERROR
        NO_SUCH_CHAR_TYPE
        REF
        load_plugin
        CYRILLIC
        GREEK
        HIRAGANA
        KANJI
        KATAKANA
        MATH
        NUMBER
        PUNCTUATION
        ASCII
        BETWEEN
        DATE
        DATETIME
        DECIMAL
        EMAIL
        INT
        LENGTH
        NOT_BLANK
        STRING
        TIME
        TINYINT
        URL
    )],
});
