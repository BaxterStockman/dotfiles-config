#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

system("which tmux &>/dev/null") and die "$0: tmux executable not found: $!\n";

my $session_base_name = defined $ENV{'SSH_CONNECTION'} ? "ssh-$ENV{'USER'}" : "$ENV{'USER'}";

if(! defined $ENV{'TMUX'} ) {
    defined(my $pid = fork) or die "$0: cannot fork: $!\n";
    unless ($pid) {
        exec("tmux new-session -s $session_base_name ; tmux detach");
    }
    waitpid($pid, 0);
#    system("tmux new-session -s $session_base_name ") and die "$0: failed to initiate new tmux session: $!\n";
}

#my @sessions = sort map {
#    /\A$session_base_name(\d+)\Z/ if defined;
#    $1 if defined;
#} `tmux ls -F '#{session_name}'`;
#
#my $session_index;
#foreach ( 0..$#sessions+1 ) {
#    if( ! defined $sessions[$_] ) {
#            $session_index = $_;
#            last;
#        }
#}
#
#exec_new_session($session_base_name . $session_index, "-t", $session_base_name);
#
sub exec_new_session {
    exec( "tmux", "new-session", "-s", @_ ) and die "$0: failed to initiate new session: $!\n";
}
