package Data::Compare::Type;
use 5.008_001;
use strict;
use warnings;
use Data::Compare::Type::Regex;
use Data::Compare::Type::CharTypes;
use Carp;
use Test::More;
use Data::Dumper;
use class::load;

our $VERSION = '0.01';

# static values
sub HASHREF {'excepted hash ref'};
sub HASHVALUE {'excepted hash value'};
sub ARRAYREF {'excepted array ref'};
sub NO_SUCH_CHAR_TYPE {'was not declare ' . $_->[0]};
sub REF {'excepted ref'};
sub INVALID{'excepted ' . $_[0]};

sub LENGTH_ERROR{'LENGTH IS WRONG'};
sub BETWEEN_ERROR{'BETWEEN IS WRONG'};
sub CHARS_ERROR{'NOT ALLOWED CHAR EXIST'};

sub new{
    my $class = bless {} , $_[0];
    $class->load_plugin('Data::Compare::Type::CharTypes');
    $class;
}

sub load_plugin {
    my ($class, $pkg, $opt) = @_;
    Class::Load::load_class($pkg);
    no strict 'refs';
    for my $meth ( @{"${pkg}::EXPORT"} ) {
        my $dest_meth =
          ( $opt->{alias} && $opt->{alias}->{$meth} )
          ? $opt->{alias}->{$meth}
          : $meth;
        *{"${class}::${dest_meth}"} = *{"${pkg}::$meth"};
    }
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
                if(@$rule != 1 && @$rule != @$param){
                    $self->_set_error(
                        '$rule\'s length differs from $param\'s length',
                        $position,
                        $name , 'ARRAY_LENGTH');
                    return;
                }
                for(0..$#{$param}){
                    if(defined $rule->[$_]){
                        $self->_check($param->[$_] || "" , $rule->[$_] , $position . "->[$_]" , $name);
                    }else{
                        $self->_check($param->[$_] || "" , $rule->[0] , $position . "->[$_]" , $name);
                    }
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
            if($rule->[0] eq 'CHARTYPE'){
                my (undef , @allow_chars) = @$rule;
                
                my $range = '';
                for my $chars_name(@allow_chars){
                    my $code = $self->can($chars_name);
                    die NO_SUCH_CHAR_TYPE($chars_name) unless $code;
                    $range .= $code->();
                }
                
                if ($param =~ m/[$range]/){
                    my $message = CHARS_ERROR;
                    $self->_set_error($message, $position , $name , '');
                }
            }else{
                for(@$rule){
                    if (ref $_ eq 'ARRAY'){
                        my ($type,$min,$max) = @$_;
                        
                        $max = $min unless defined $max;

                        if($type eq 'LENGTH' or $type eq 'BETWEEN'){
                            if($max < $min ){
                                ($max , $min) = ($min , $max);
                            }
                            no strict;
                            unless(&{"Data::Compare::Type::Regex::$type"}($param,$min,$max)){
                                my $message;
                                if($type eq 'LENGTH'){
                                    $message = LENGTH_ERROR;
                                }else{
                                    $message = BETWEEN_ERROR;
                                }
                                $self->_set_error($message, $position , $name , $type, $min , $max);
                            }
                        }elsif($type eq 'CHARTYPE'){
                            my (undef , @allow_chars) = @$_;
                            
                            my $range = '';
                            for my $chars_name(@allow_chars){
                                my $code = $self->can($chars_name);
                                die NO_SUCH_CHAR_TYPE($chars_name) unless $code;
                                $range .= $code->();
                            }
                            
                            if ($param =~ m/[$range]/){
                                my $message = CHARS_ERROR;
                                $self->_set_error($message, $position , $name , '');
                            }
                        }else{
                            croak "Not declare type:" . $type;
                        }
                    }elsif (ref $_){
                        $self->_set_error(HASHREF, $position , $name ,'ARRAY');
                        return;
                    }else{
                        no strict;
                        unless(&{"Data::Compare::Type::Regex::$_"}($param)){
                            $self->_set_error(INVALID($_), $position , $name , $_);
                        }
                    }
                }
            }
        }else{
            no strict;
            unless(&{"Data::Compare::Type::Regex::$rule"}($param)){
                $self->_set_error(INVALID($rule), $position , $param , $rule);
            }
        }
    }
}

sub has_error{
    $_[0]->{error};
}

sub _set_error{
    my ($self,$message,$position,$param_name,$error,$min,$max) = @_;
    $self->{error} = 1;
    $self->{error_object} ||= [];
    push @{$self->{error_object}} , {
        message => $message ,position =>  $position , 
        param_name => $param_name , error => $error,
        min_value => $min , max_value => $max ,
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
