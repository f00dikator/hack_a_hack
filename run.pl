#!/usr/bin/perl

$target_dir = "./";

opendir(DIR, $target_dir);
@files = grep /cnf/, readdir(DIR);
closedir(DIR);

foreach $var (@files) {
    print "including $var\n";
    #$command = "./perl_server.pl $var \&";
    $command = "./pserver.pl $var \&";
    system ($command);
}

