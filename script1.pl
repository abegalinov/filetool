#!/usr/bin/perl

use FileTool;

my ($dir, $remove_ww) = @ARGV;

if (!$dir) {
    print "Usage: $0 /path/to/search/files [remove-world-write-permission-bool]\n";
    print "Example: $0 /var/www 1\n";
    exit(1);
}

print "Create FileTool package instance..\n";
print "Options: (path=$dir, remove ww permission=".($remove_ww?1:0).")\n";

my $ft = FileTool->new(path => $dir, remove_ww => $remove_ww?1:0);

print "Start searching..\n";

my @files = $ft->process();

if(@files > 0) {
    print "Search completed, results(".@files."):\n\n";
    print "$_\n" foreach (@files);
    print "\nWorld write permission has been removed\n" if ($remove_ww);
} else {
    print "Search completed, no results found\n";
}
