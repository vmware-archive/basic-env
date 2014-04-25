#!/usr/bin/perl
# Author: Tony Hansmann
#

##############################
##########
# Fri Nov 21 15:36:39 2008

# A util I've always wanted! when you have a perms problem in unix you
# need to know the perms on each level above the file. AFAIK there's
# no way to get them other than typing ls for each element of the
# path. This cuts that process down.

while ( $_ = shift @ARGV) {
    my @broken_down_path;
    my @path_list;
    my %ls_line;
    
    chomp;
    # get the path elemets so we can see the perms at each level.
    @broken_down_path = split q{/},  "$_" ;

    # the first element from the split is nul, pulling it out and
    # putting a 'slash' in so I get the entire tree
    shift @path_list;  unshift @path_list, qq{/};

    for (0..$#broken_down_path) {
        my  $rebuild_path_element;
        # as we go thru the array we building up an list that makes up the path
        $rebuild_path_element =  join q{/}, @broken_down_path[0..$_];
        push @path_list, $rebuild_path_element;
    }
    
    # 
    for my $path (@path_list) {
        # get the output of ls -ld on every level of the path, story in a hash of arrays
        push @{$ls_line{$path}}, split q{ }, qx{/bin/ls -ld $path} ;
    }
    
    # rev sort the keys so we get the file at the top the dirs underneith.
    for my $path (sort keys %ls_line) {
        # make sure $path is not null. 
        $path or next ;
        # just the perms owner and group
        print join qq{\t}, @{$ls_line{$path}}[0,2,3];
        # put in the path
        print "\t$path\n" ;
    }

    # if there are more to go, print a space.
    @ARGV ?  print "\n" : '';

} # end for (@ARGV)


=pod


sample usage and output. Look at permissions at all tree levels to
figure out while a user can't read a file or dir.

tony-ws:bin>   tree_perms.pl /home/tony/work/getactive/kickstart_configs/post_install_scripts/_base/service_control.bash /home/tony/bin/At.pm 
-rw-------      tony    None    /home/tony/work/getactive/kickstart_configs/post_install_scripts/_base/service_control.bash
drwx------+     tony    None    /home/tony/work/getactive/kickstart_configs/post_install_scripts/_base
drwx------+     tony    None    /home/tony/work/getactive/kickstart_configs/post_install_scripts
drwx------+     tony    None    /home/tony/work/getactive/kickstart_configs
drwx------+     tony    None    /home/tony/work/getactive
drwx------+     tony    None    /home/tony/work
drwxrwxrwx+     tony    None    /home/tony
drwxrwxrwx+     tony    None    /home
drwxrwx---+     tony    Users   /

-rw-------      tony    None    /home/tony/bin/At.pm
drwxr-xr-x+     tony    None    /home/tony/bin
drwxrwxrwx+     tony    None    /home/tony
drwxrwxrwx+     tony    None    /home
drwxrwx---+     tony    Users   /

=cut
