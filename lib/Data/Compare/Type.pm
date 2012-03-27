package Data::Compare::Type;
use 5.008_001;
use strict;
use warnings;
use Data::Compare::Type::Regex;
use Carp;
use Test::More;
use Data::Dumper;

our $VERSION = '0.01';

# static values
sub HASHREF {'excepted hash ref'};
sub HASHVALUE {'excepted hash value'};
sub ARRAYREF {'excepted array ref'};
sub REF {'excepted ref'};
sub INVALID{'excepted ' . $_[0]};

sub new{
    bless {} , $_[0];
}

sub check{
    my($self , $param , $rule) = @_;
    $self->{error} = 1;
    croak('set params') if !$param or !$rule;

    $self->{error} = 0;
    $self->{error_object} = [];
    $self->_check($param,$rule,'$param');
    
    !$self->{error};
}

sub _check{
    my($self , $param , $rule , $position , $name) = @_;

    if(ref $param eq 'Hash::MultiValue'){
        $param = $param->as_hashref;
    }

    if(ref $param){
        my $ref = ref $rule;
        if(ref $param ne $ref){
            if($ref eq 'ARRAY'){
                $self->_set_error(HASHREF, $position , $name);
            }elsif($ref eq 'HASH'){
                $self->_set_error(ARRAYREF, $position , $name);
            }else{
                croak('declareother types : HASH or ARRAY');
            }
        }else{
            if($ref eq 'HASH'){
                for(keys %$rule){
                    unless(exists $param->{$_}){
                        if(_instr($rule->{$_},'NOT_BLANK')){
                            $self->_set_error(HASHVALUE, $position, $_ ,'NOT_BLANK');
                        }
                    }else{
                        $self->_check($param->{$_} , $rule->{$_} , $position . "->{$_}" , $_);
                    }
                }
            }elsif($ref eq 'ARRAY'){
                for(0..$#{$param}){
                    $self->_check($param->[$_] || "" , $rule->[0] , $position . "->[$_]" , $name);
                }
            }else{
                croak($ref . ':declare other types : HASH or ARRAY');
            }
        }
    }else{
        if(ref $rule eq 'HASH'){
            $self->_set_error(HASHREF, $position , $name , 'HASH');
            return;
        }elsif(ref $rule eq 'ARRAY'){
            for(@$rule){
                if (ref $_ eq 'ARRAY'){
                    my ($type,$min,$max) = @$_;
                    
                    $max = $min unless defined $max;

                    if($max < $min ){
                        ($max , $min) = ($min , $max);
                    }
                    
                    if($type eq 'LENGTH' or $type eq 'BETWEEN'){
                        no strict;
                        unless(&{"Data::Compare::Type::Regex::$type"}($param,$min,$max)){
                            $self->_set_error(INVALID($rule), $position , $name ,$param);
                        }
                    }else{
                        die;
                    }
                }elsif (ref $_){
                    $self->_set_error(HASHREF, $position , $name,'ARRAY');
                    return;
                }else{
                    no strict;
                    unless(&{"Data::Compare::Type::Regex::$_"}($param)){
                        $self->_set_error(INVALID($_), $position , $name , $param);
                    }
                }
            }
        }else{
            no strict;
            unless(&{"Data::Compare::Type::Regex::$rule"}($param)){
                $self->_set_error(INVALID($rule), $position , $name ,$param);
            }
        }
    }
}

sub has_error{
    $_[0]->{error};
}

sub _set_error{
    my ($self,$message,$position,$param_name , $error) = @_;
    $self->{error} = 1;
    $self->{error_object} ||= [];
    push @{$self->{error_object}} , {
        message => $message ,position =>  $position , 
        param_name => $param_name , error => $error
    };
}

sub get_error{
    $_[0]->{error_object} ||= [];
}

sub _instr{
    my ($array , $word) = @_;
    for(@$array){
        if($_ eq $word){
            return 1;
        }
    }
    return 0;
}

1;
__END__

=head1 NAME

Data::Compare::Type - Perl extention to do something

=head1 VERSION

This document describes Data::Compare::Type version 0.01.

=head1 SYNOPSIS

    use Data::Compare::Type;

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
