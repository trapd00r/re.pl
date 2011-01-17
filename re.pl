#!/usr/bin/perl
use vars qw($VERSION);
my $APP  = 're.pl';
$VERSION = '0.112';

use Storable;
use strictures 1;
use Pod::Usage;
use Data::Dumper;
use Getopt::Long;
use Term::ReadLine;
use File::Find::Rule;
use Eval::WithLexicals;
use B::Keywords qw/@Symbols @Barewords/;

push(@Symbols, @Barewords);
push(@Symbols, 'perldoc');

my $module_db = "$ENV{HOME}/.re.pl.db";

{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}

my %modules;
GetOptions(
  'g|genmod' => sub {
    unlink($module_db); 
  },
  'h|help'    => sub { pod2usage(verbose => 1); },
  'v|version' => sub { printf("%s v%s\n", $APP, $VERSION) and exit 0; },
  'm|man'     => sub { pod2usage(verbose => 3); },
);

get_installed_modules();

my $eval = Eval::WithLexicals->new;

my $read = Term::ReadLine->new('re.pl');
my $attr = $read->Attribs;
$attr->{completion_function} = sub {
  my($text, $line, $start) = @_;
  return @Symbols;
};

while(defined(my $line = $read->readline('re.pl$ '))) {
  my @ret;
  if($line =~ m/^(perldoc.+)$/) {
    #delete($ENV{PAGER});
    system($1);
    next;
  }
  eval {
    local $SIG{INT} = sub { die("Caught SIGINT"); };
    @ret = $eval->eval($line);
    1;
  } or @ret = ("Error!", $@);

  print Dumper @ret;
}

sub get_installed_modules {
  if(-f $module_db) {
    %modules = %{ retrieve($module_db) },
  }
  else {
    local $| = 1;
    print "Generating list of available modules...";
    map {
      s%.+(?:core|site|vendor)_perl/(.+)\z%$1%;
      s|/|::|g;
      s/\.pm\z//;
      ($_ =~ m/^5.10/) ? undef : $modules{$_}++;

    } File::Find::Rule->file()->name('*.pm')->in(@INC);
    printf("%s\n", (scalar(keys(%modules)) > 0) ? "[OK]" : "");
  }
  store(\%modules, $module_db);
  push(@Symbols, keys %modules);
}

=pod

=head1 NAME

re.pl - read, eval, print, loop with tabcompletion

=head1 DESCRIPTION


B<re.pl> tabcompletes to variables, special file handles, built in functions,
operators, control structures and modules if you have L<Term::ReadLine::Gnu>
available.

Documentation is also available straight from the REPL;

  re.pl$ perldoc Term::E<TAB>
  Term::ExtendedColor                     Term::ExtendedColor::TTY::Colorschemes
  Term::ExtendedColor::TTY                Term::ExtendedColor::Xresources

A list of available modules is created on the first run, or when the B<--genmod>
flag is specified.

=head1 OPTIONS

  -g, --genmod    re-create a list of available modules on the system

  -h, --help      show the help and exit
  -v, --version   show version info and exit
  -m, --man       show documentation and exit

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 HISTORY

Based on mst's example REPL in the awesome L<Eval::WithLexicals> distribution.

=head1 COPYRIGHT

Copyright (C) 2011 Magnus Woldrich. All right reserved.
This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;
