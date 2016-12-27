#!/usr/bin/perl

use FileTool;

my ($user, $dir, $remove_ww) = @ARGV;

if (!$dir) {
    print "Usage: $0 user /path/to/search/files [remove-world-write-permission-bool]\n";
    print "Example: $0 nobody /var/www 1\n";
    exit(1);
}

my $uid = getpwnam($user);
die("Can't find user: $user") if(!$uid);
$> = $uid;

my $ft = FileTool->new(path => $dir, remove_ww => $remove_ww?1:0);

my @files = $ft->process();

print "$_\n" foreach(@files);
