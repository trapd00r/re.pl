#!/usr/bin/perl
use vars qw($VERSION);
my $APP  = 're.pl';
$VERSION = '0.002';

use strictures 1;
use Eval::WithLexicals;
use Term::ReadLine;
use Data::Dumper;
use B::Keywords qw/@Symbols @Barewords/;
push(@Symbols, @Barewords);

{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}

my $eval = Eval::WithLexicals->new;

my $read = Term::ReadLine->new('re.pl');
my $attr = $read->Attribs;
$attr->{completion_function} = sub {
  my($text, $line, $start) = @_;
  return @Symbols;
};

while(defined(my $line = $read->readline('re.pl$ '))) {
  my @ret;
  eval {
    local $SIG{INT} = sub { die("Caught SIGINT"); };
    @ret = $eval->eval($line);
    1;
  } or @ret = ("Error!", $@);

  print Dumper @ret;
}

=pod

=head1 NAME

re.pl - read, eval, print, loop with tabcompletion

=head1 USAGE

  ./re.pl

  re.pl$ $_ = 42
  42

  re.pl$ $_ * 2
  84

  re.pl$ my $foo = sub { $_ = 0; $_++ until $_ == 3; return $_ }; $foo
  sub {
      package Eval::WithLexicals::Scratchpad;
      BEGIN {${^WARNING_BITS} = "\377\377\377\377\377\377\377\377\377\377\377\377\017"}
      use strict 'refs';
      $_ = 0;
      ++$_ until $_ == 3;
      return $_;
  }

  re.pl$ my $foo = sub { $_ = 0; $_++ until $_ == 3; return $_ }; $foo->()
  3


=head1 DESCRIPTION

Based on mst's example REPL in the awesome L<Eval::WithLexicals> distribution.

B<re.pl> tabcompletes to variables, special file handles, built in functions,
operators and control structures if you have L<Term::ReadLine::Gnu> available.

=head1 OPTIONS

None.

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 COPYRIGHT

Copyright (C) 2011 Magnus Woldrich. All right reserved.
This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
