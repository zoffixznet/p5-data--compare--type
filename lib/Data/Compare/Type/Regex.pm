package Data::Compare::Type::Regex;
use 5.008_001;
use strict;
use warnings;
use Email::Valid;
use Time::Piece;

our $VERSION = '0.01';

sub NOT_BLANK{
    my $s = shift;
    if (defined $s and length($s) > 0 ){
        return 1;
    }

    !!$s;
}

sub INT{
    my $s = shift;
    return 1 unless $s;
    $s =~ m/^\d+$|^-\d+$/;
}

sub ASCII{
    my $s = shift;
    return 1 unless $s;
    $s =~ /^[\x21-\x7E]+$/;
}

sub STRING{
    my $s = shift;
    return 1 unless $s;
    1;
}

sub DECIMAL{
    my $s = shift;
    return 1 unless $s;
    $s =~ m/^\d+\.\d+$|^-\d+\.\d+$/ or INT($s); 
}

sub EMAIL{
    my $s = shift;
    return 1 unless $s;
    Email::Valid->address(-address => $s);
}

sub DATETIME{
    my $s = shift;
    return 1 unless $s;
    eval{
        Time::Piece->strptime($s , "%Y-%m-%d %H:%M:%S");
    };
    if($@){
        eval{
            Time::Piece->strptime($s , "%Y/%m/%d %H:%M:%S");
        }
    }
    if($@){
        eval{
            Time::Piece->strptime($s , "%Y-%m-%d %H-%M-%S");
        }
    }
    if($@){
        eval{
            Time::Piece->strptime($s , "%Y/%m/%d %H-%M-%S");
        }
    }
    !$@
}

sub DATE{
    my $s = shift;
    return 1 unless $s;
    eval{
        Time::Piece->strptime($s , "%Y-%m-%d");
    };
    if($@){
        eval{
            Time::Piece->strptime($s , "%Y/%m/%d");
        }
    }
    if($@){
        eval{
            Time::Piece->strptime($s , "%Y-%m-%d");
        }
    }
    if($@){
        eval{
            Time::Piece->strptime($s , "%Y/%m/%d");
        }
    }
    !$@
}

sub TIME{
    my $s = shift;
    return 1 unless $s;
    $s =~ m/\d{2}-\d{2}-\d{2}|\d{2}:\d{2}:\d{2}/; 
}

sub TINYINT{
    my $s = shift;
    return 1 unless $s;
    return ($s eq "0" or $s eq "1");
}

sub LENGTH{
    my ($s , $min , $max) = @_;
    my $len = length($s);
    if($len == 0 or $len >= $min and $len <= $max){
        return 1;
    }else{
        return 0;
    }
}

sub BETWEEN{
    my ($s , $min , $max) = @_;
    if($s >= $min and $s <= $max){
        return 1;
    }else{
        return 0;
    }
}

sub URL{
    my ($s) = @_;
    return 1 unless $s;
    $s =~ m/^http:\/\/|^https:\/\//; 
}

1;
__END__

=head1 NAME

Data::Compare::Type::Regex - Perl extention to do something

=head1 VERSION

This document describes Data::Compare::Type::Regex version 0.01.

=head1 SYNOPSIS

    use Data::Compare::Type::Regex;

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

Data::Compare::Type::Regex - Perl extention to do something

=head1 VERSION

This document describes Data::Compare::Type::Regex version 0.01.

=head1 SYNOPSIS

    use Data::Compare::Type::Regex;

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
