#!perl -w
use strict;
use Test::More tests => 4;

package Foo;

use Carp;

use overload
    fallback => 1,
    '%{}' => sub { $_[0][0] },  # returns hash
    'qr'  => sub { $_[0][1] },  # returns regex
    ;

sub new {
    my($class) = @_;
    return bless [ {x => 'y'}, qr/z/ ] => $class;
}

package main;

use UNIVERSAL::DOES qw[ does ];

my $foo = Foo->new;

ok does({},    'HASH'  ), 'plain HASH';      # true
ok does($foo,  'HASH'  ), 'overload HASH';   # true
ok does(qr/x/, 'Regexp'), 'plain Regexp';    # true
ok does($foo,  'Regexp'), 'overload Regexp'; # false <-- this is the problem!
