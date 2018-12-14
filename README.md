[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=65SFZJ25PSKG8&currency_code=SEK&source=url) - Every tiny cent helps a lot!

# re.pl

read, eval, print, loop with tabcompletion and persistent lexicals

![repl](/extra/re.pl.png)

# DESCRIPTION

**re.pl** tabcompletes to variables, special file handles, built in functions,
operators, control structures and modules if you have [Term::ReadLine::Gnu](https://metacpan.org/pod/Term::ReadLine::Gnu)
or [Term::ReadLine::Zoid](https://metacpan.org/pod/Term::ReadLine::Zoid) installed.

Documentation is also available straight from the REPL;

    re.pl$ perldoc Term::E<TAB>
    Term::ExtendedColor                     Term::ExtendedColor::TTY::Colorschemes
    Term::ExtendedColor::TTY                Term::ExtendedColor::Xresources

A list of available modules is created on the first run, or when the **--genmod**
flag is specified.

# OPTIONS

    -g, --genmod    re-create a list of available modules on the system

    -h, --help      show the help and exit
    -v, --version   show version info and exit
    -m, --man       show documentation and exit

# COMMANDS

    perldoc My::Module # Invoke perldoc; will use the system $PAGER
    :q, exit           # exit re.pl

# ENVIRONMENT

The behavior in the prompt is controlled by several variables. First, it's
recommended to have the `Term::ReadLine::Gnu` module installed. Without it,
tab-completion and a _vi_ keymap can not be guaranteed.

A couple of records in $HOME/.inputrc will make working with perldoc easier,
assuming you are using Bash (or anything other that uses readline) as your
shell:

    set editing-mode vi
    set keymap vi-insert

    $if re.pl
      "\C-e": "perldoc perlre\n"
      "\C-g": "perldoc perlguts\n"
      "\C-o": "perldoc perlop\n"¶
      "\C-p": "perldoc perlipc\n"
      "\C-u": "perldoc perlunicode\n"¶
      "\C-v": "perldoc perlvar\n"¶
    $endif

# AUTHOR

    Magnus Woldrich
    CPAN ID: WOLDRICH
    magnus@trapd00r.se
    http://japh.se

# HISTORY

Based on mst's example REPL in the awesome [Eval::WithLexicals](https://metacpan.org/pod/Eval::WithLexicals) distribution.

# COPYRIGHT

Copyright (C) 2011 Magnus Woldrich.
This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 157:

    Non-ASCII character seen before =encoding in 'perlop\\n"¶'. Assuming UTF-8
