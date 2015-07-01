#!/usr/bin/perl
# Author: Tony Hansmann
#
# converting around - this is a set of tools that should be in
# included with the os but arent. A lot of them are direct rip-offs of
# verbs from perl and python translated for commandline use (lstrip, rstrip, fstrip, reverse)

#alias nl2,="perl -ne 'push @F, \$_;     END { chomp @F; print join(qq{,}, @F) , qq{\n};}' "
#alias nl2space="perl -ne 'push @F, \$_; END { chomp @F; print join(qq{ }, @F) , qq{\n};}' "

use English ;

# use diagnostics;
# use strict;
use Carp;
# use POSIX;
# use Data::Dumper;
use Getopt::Long qw(:config bundling) ;
use Fatal qw(open) ;

#use lib qw(/export/home/anh/bin);
# use lib qw(/export/home/anh/bin /export/home/anh/perl/lib);

GetOptions(
    'egg'    => \$EGG,
    'emacs'  => \$EMACS,
    'noop|n' => \$NOOP,
) ;

$pn = (split(q{/}, $PROGRAM_NAME ))[-1];

if ( $EGG && $PROGRAM_NAME =~ m{ nl2.pl \z}xms ) {
    egg() ;
    exit 1;
}

if ( $EMACS && $PROGRAM_NAME =~ m{ nl2.pl \z}xms ) {
    emacs_fuctions() ;
    exit 2;
}

if ($EMACS) {
    dump_emacs_fuction($PROGRAM_NAME);
    exit 2;
}


my $space_tab_regex = qr{[\ \t]} ;

#my $lstrip_regex = qr{\A $space_tab_regex+}xms ;
my $lstrip_regex = qr{\A \s+}xms ;
my $rstrip_regex = qr{$space_tab_regex+ $}xms ;

$pn =~ m{nl2.pl\z}xms && do { egg() } ;

my $both_strip_regex = qr{\A $space_tab_regex+|$space_tab_regex+\z}xms ;

$pn =~ m{cl_space2nl} && do { cl_space2nl( \@ARGV ) ; exit ; } ;

my $commandline_arg ; 
if (scalar @ARGV ) {
    $commandline_arg = shift @ARGV;
 }

@ALL = (<ARGV>) ;

$pn =~ s{\.pl\z}{}xms ;
$pn =~ m{\Aspace2comma\z}xms && do { space2comma( \@ALL ) ; exit ; } ;
$pn =~ m{\Aspace2nlbackslash\z}xms && do { space2nlbackslash( \@ALL ) ; exit ; } ;
$pn =~ m{\Acomma2space\z}xms && do { comma2space( \@ALL ) ; exit ; } ;
$pn =~ m{\Acomma2nl\z}xms && do { comma2nl( \@ALL ) ; exit ; } ;
$pn =~ m{\Anl2vbar\z}xms && do { nl2vbar( \@ALL ) ; exit ; } ;
$pn =~ m{\Anl2comma\z}xms && do { nl2comma( \@ALL ) ; exit ; } ;
$pn =~ m{\Anl2space\z}xms && do { nl2space( \@ALL ) ; exit ; } ;
$pn =~ m{\Aspace2nl\z}xms && do { space2nl( \@ALL ) ; exit ; } ;
$pn =~ m{\Asqueeze\z}xms && do { squeeze( \@ALL ) ; exit ; } ;
$pn =~ m{\Alstrip\z}xms && do { lstrip( \@ALL ) ; exit ; } ;
$pn =~ m{\Arstrip\z}xms && do { rstrip( \@ALL ) ; exit ; } ;
$pn =~ m{\Afstrip\z}xms&& do { fstrip( \@ALL ) ; exit ; } ;
$pn =~ m{\Astrip_trailing_space\z}xms&& do { strip_trailing_space( \@ALL ) ; exit ; } ;
$pn =~ m{\Anl2semi\z}xms && do { nl2semi( \@ALL ) ; exit ; } ;
$pn =~ m{\Asemi2nl\z}xms && do { semi2nl( \@ALL ) ; exit ; } ;
$pn =~ m{\Acomma2commanl\z}xms && do { comma2commanl( \@ALL ) ; exit ; } ;
$pn =~ m{\Acomma2vbar\z}xms && do { comma2vbar( \@ALL ) ; exit ; } ;
$pn =~ m{\Acommanl2comma\z}xms && do { commanl2comma( \@ALL ) ; exit ; } ;
$pn =~ m{\Anl2amp}xms && do { nl2ampersand( \@ALL ) ; exit ; } ;
$pn =~ m{\A ampersand2nl \z}xms && do { ampersand2nl( \@ALL ) ; exit ; } ;
$pn =~ m{\Areverse\z}xms && do { print reverse @ALL ; exit ; } ;
$pn =~ m{\Acommify\z}xms && do { commify( \@ALL ) ; exit ; } ;
$pn =~ m{\Aprepend\z}xms && do {
        prepend( $commandline_arg, \@ALL ) ;
        exit ; } ;
$pn =~ m{\Aappend\z}xms && do {
        append( $commandline_arg, \@ALL ) ;
        exit ; } ;
$pn =~ m{\Aenum\z}xms && do { enum( \@ALL ) ; exit ; } ;


croak "ERROR: $pn is an unknown command\n" ;


# print a line number for  newline seperated input
# mainly written to do this:
##  <command> | space2nl | enum
## to avoid having to count by hand 
sub enum {
    my $i = 1;
    $a_ref = shift @_;
    map {  print $i++ . " " . $_} @$a_ref;
}



sub commify {
    $a_ref = shift @_;
    #chomp @$a_ref;
    for my $line (@$a_ref) {
        if ($line =~ m{\b\d{4,}\b}xmsg) {
            $line =~ s{
                          \b # a boundry char
                          (\d{4,}) # four or more digits
                          \b # a boundry char
                  }{_commify($1)}xmsge; # note the 'e' to make it eval. # eval the _commify sub to put commas in the matched digits
        }
        print $line;
        
    }
 
}
# gold perl  commify numbers
 sub _commify {
     my $num = shift;
     my $out;
     my @commamed_output;
     if (length($num) > 3) {
         my @no_commas = split //, $num;
         while (@no_commas) {
             unshift @commamed_output, ',', splice  @no_commas, -3;
             if (scalar @no_commas <= 3 ) {
                 unshift @commamed_output,  join '', @no_commas;
                 $out = join '', @commamed_output;
                 last;
             }
         }

       
     } else {
         $out = $num;
     }
     return $out;
 }



sub comma2vbar {
    $a_ref = shift @_;
    chomp @$a_ref;
    map { s{\,}{\|}xmsg } @$a_ref;
    print join("&", @$a_ref), "\n";
    
}

sub nl2ampersand {
    $a_ref = shift @_;
    chomp @$a_ref;
    print join("&", @$a_ref), "\n";
}

sub ampersand2nl {
    $a_ref = shift @_;
    chomp @$a_ref;
    map { s{&}{\n}xmsg } @$a_ref ;
    print @$a_ref, "\n";
}


sub prepend {
    my $prepend  = shift @_; 
    $a_ref = shift @_;
 # map{
 #     #s{\,\s*\n}{ ,  }xmsg }
 #     @$a_ref ;
    map { $_ = $prepend . $_ } @$a_ref;
 print  @$a_ref, "\n";
}


sub append {
    my $append  = shift @_; 
    $a_ref = shift @_;
    chomp @{$a_ref}; 
    map { $_ =  $_ . $append . "\n"} @$a_ref;
 print  @$a_ref, "\n";
}

sub commanl2comma {
 $a_ref = shift @_;
 chomp @$a_ref;
 $space = q{ };
 map{
     s{\,\s*\n}{ ,  }xmsg }
     @$a_ref ;
 print join(" ", @$a_ref), "\n";
}


sub comma2commanl {
 $a_ref = shift @_;
 chomp @$a_ref;
 map{s{,}{,\n}xmsg }  @$a_ref ;
 print join("", @$a_ref), "\n";
}


sub nl2semi {
    $a_ref = shift @_;
    chomp @$a_ref;
    print join(" ; ", @$a_ref), "\n";
} # end nl2semi

sub semi2nl {
    $a_ref = shift @_;
    chomp @$a_ref;
    map{s{;}{\n}xmsg }  @$a_ref ;
    print join(" ; ", @$a_ref), "\n";
} # end semi2nl

sub cl_space2nl {
  $a_ref = shift @_;
  print join("\n", @$a_ref), "\n";
}

sub lstrip {
    $a_ref = shift @_;
    for (@{$a_ref}) {
        s{$lstrip_regex}{}xmgs;
       print;
   }

}

sub rstrip {
    $a_ref = shift @_;
    for (@{$a_ref}) {
        s{$rstrip_regex}{}xmgs;
       print;
   }

}


sub fstrip {
    $a_ref = shift @_;
    for (@{$a_ref}) {
        s{$both_strip_regex}{}xmgs;
       print;
   }

}

sub strip_trailing_space {
    $a_ref = shift @_;
    $color_strip_regex = qr{[\ \t]+\Z};
    for (@{$a_ref}) {
      s{$color_strip_regex}{}g;
      print;
    }
}

sub strip_color {
    $a_ref = shift @_;
    $color_strip_regex = qr{e\[?.*?[\@-~]};  # Strip ANSI escape codes
    for (@{$a_ref}) {
      s{$color_strip_regex}{}g;
      print;
    }
}

sub squeeze {
   $a_ref = shift @_;
   #
   for (@{$a_ref}) {
       s{([\s])+}{$1}xmgs;
       next if m{^$};
       print;
   }

}

sub nl2vbar {
   $a_ref = shift @_;
   chomp @{$a_ref};
   print join(q{|}, @$a_ref), qq{\n};
}

sub space2comma {
    $a_ref = shift @_;
    #chomp @$a_ref;
    my @out;
    for( @{$a_ref}){push @out, split qr{\s+}xms, $_}
    print join(qq{,}, @out), qq{\n};
}
sub comma2space {
    $a_ref = shift @_;
    chomp @$a_ref;
    my @out;
    for( @{$a_ref}){push @out, split qr{,}, $_}
    print join(qq{ }, @out)
        , qq{\n};
}

sub comma2nl {
    $a_ref = shift @_;
    chomp @$a_ref;
    my @out;
    for( @{$a_ref}){push @out, split qr{,}, $_}

    print join("\n", @out)
        , "\n";
}


sub nl2space {
    $a_ref = shift @_;
    chomp @$a_ref;
    print join(q{ }, @$a_ref)
        , qq{\n};
}

sub nl2comma {
    $a_ref = shift @_;
    chomp @$a_ref;
    print join(qq{,}, @$a_ref)
        , qq{\n};
}

sub space2nl {
    $a_ref = shift @_;
    chomp @{$a_ref};
    map {  s{\s+}{\n}xmsg } @{$a_ref};
    print join(qq{\n}, @{$a_ref}), qq{\n};
}


sub space2nlbackslash {
    $a_ref = shift @_;
    chomp @{$a_ref};
    map {  s{\s+}{ \\ \n}xmsg } @{$a_ref};
    print  @{$a_ref}, " \\ \n";
}

sub  egg()  {
    open($us, "$0");
    @US = (<$us>);
    close $us;
    chomp @US;
    # we dont want the emacs stuff or support subs that start with '_' as symlinks
    @our_subs = grep { ! m{emacs|\A_}xms } map { m{\A (?:\s+)? sub (?:\s+) (\w+) }xms }  @US;
    ##grep { $_ }  map { ($a) = m{sub \s+ ([\w\d]+)\b+}xms ; $a } @US;
    print q!## jsh  -Reg jsh "cd /usr/local/bin; ./nl2.pl --egg| xargs -I {} bash -c '{}'"!, "\n";
    for (@our_subs) {
        next if m{egg};
        print "ln -s -v $PROGRAM_NAME $_\n";
        print "ln -s -v $PROGRAM_NAME reverse\n";
    }
    exit 0;
}

sub emacs_fuctions {
    open($us, "$0");
    @US = (<$us>);
    close $us;
    chomp @US;
    @our_subs = grep { ! m{emacs|\A_}xms } map { m{\A (?:\s+)? sub (?:\s+) (\w+) }xms }  @US;
    #@our_subs = map { m{\A (?:\s+)? sub (?:\s+) (\w+) }xms }  @US;

    for $sub (@our_subs) {

        dump_emacs_fuction($sub);
    } 
}

# nice way to get these tools into place
sub dump_emacs_fuction {
    my $sub = shift;
    chomp $sub;
    $sub =  (split(q{/}, $sub))[-1];
    print <<EOF;    
(defun $sub ()
  "$sub change something to something else - fill me in"
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "/usr/local/bin/$sub | /usr/local/bin/squeeze | /usr/local/bin/fstrip" nil t)))
EOF
 
}

# =pod

# =head1 NAME

# =head1 SYNOPSIS 

# =head1 DESCRIPTION

# =head1 OPTIONS  

# =head1 RETURN VALUE

# =head1 ERRORS

# =head1 EXAMPLES  

# =head1 ENVIRONMENT

# =head1 FILES     

# =head1 SEE ALSO  

# =head1 NOTES     

# =head1 CAVEATS   

# =head1 DIAGNOSTICS

# =head1 BUGS

# =head1 RESTRICTIONS

# =head1 AUTHOR 

# =head1 HISTORY 

# =cut
