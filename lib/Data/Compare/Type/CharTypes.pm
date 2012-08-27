package Data::Compare::Type::CharTypes;
use 5.008_001;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use base 'Exporter';
our @EXPORT= qw/HIRAGANA KATAKANA GREEK ASCII CYRILLIC MATH NUMBER/;

sub HIRAGANA{
    '^\x{3040}-\x{309F}';
}

sub KATAKANA{
    '^\x{30A0}-\x{30FF}\x{FF00}-\x{FFEF}';
}

sub KANJI{
    '^\x{F900}-\x{FAFF}';
}

sub ASCII{
    '^\x{0000}-\x{007F}';
}

sub GREEK{
    '^\x{0370}-\x{03FF}';
}

sub NUMBER{
    '^\x{2150}-\x{218F}';
}

sub CYRILLIC{
    '^\x{0400}-\x{04FF}';
}

sub MATH{
    '^\x{2200}-\x{22FF}';
}

1;

__END__

=head1 NAME

Data::Compare::Type::AllowChars - Perl extention to do something

=head1 VERSION

This document describes Data::Compare::Type::AllowChars version 0.01.

=head1 SYNOPSIS

    use Data::Compare::Type::AllowChars;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

S2 E<lt>s2otsa@hotmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, S2. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

}

1;
__END__

=head1 NAME

Data::Compare::Type::AllowChars - Perl extention to do something

=head1 VERSION

This document describes Data::Compare::Type::AllowChars version 0.01.

=head1 SYNOPSIS

    use Data::Compare::Type::AllowChars;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

S2 E<lt>s2otsa@hotmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, S2. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
