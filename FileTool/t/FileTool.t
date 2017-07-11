use strict;
use warnings;
use Fcntl ':mode';
use Test::More tests => 4;

BEGIN { use_ok('FileTool') };

my $DIR = '/tmp/test_filetool/';
my $SUBDIR = $DIR.'test1/';
my $FILE1 = $DIR.'1.test';
my $FILE2 = $SUBDIR.'2.test';

END { system("rm -rf $DIR"); };

mkdir $DIR;
mkdir $SUBDIR;
system('touch '.$FILE2);
system('touch '.$FILE1);
chmod 0777, $FILE2;

my $ft = new_ok( 'FileTool' => [path => $DIR, remove_ww => 1] );

ok( eq_array([ $ft->process() ], [ $FILE2 ]), 'FileTool->process()' );

ok( !( (stat($FILE2))[2] & S_IWOTH ), 'Removed file permission' );

done_testing();
