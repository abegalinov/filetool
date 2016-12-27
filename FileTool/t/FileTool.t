use strict;
use warnings;
use Fcntl ':mode';
use Test::More tests => 6;
BEGIN { use_ok('FileTool') };

my $DIR = '/tmp/test_filetool/';
my $SUBDIR = $DIR.'test1/';
my $FILE1 = $DIR.'1.test';
my $FILE2 = $SUBDIR.'2.test';

mkdir $DIR;
mkdir $SUBDIR;
system('touch '.$FILE2);
system('touch '.$FILE1);
chmod 0777, $FILE2;

ok( my $ft = FileTool->new(path => $DIR, remove_ww => 1), 'FileTool->new()' );
ok( my @files = $ft->process(), 'FileTool->process()' );
ok( scalar(@files) == 1, 'Count files' );
like( $files[0], "/$FILE2\$/",  'Which file' );
ok( !( (stat($FILE2))[2] & S_IWOTH ), 'Remove file permission' );

system("rm -rf $DIR");

done_testing();
