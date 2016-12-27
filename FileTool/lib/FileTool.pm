package FileTool;

use 5.018002;
use strict;
use warnings;

use Moose;
use File::Find;
use Fcntl ':mode';

our $VERSION = '0.01';

has 'path', is => 'rw', required => 1;
has 'remove_ww', is => 'rw';

sub BUILD {
  shift->_init();
}

sub _init {
  my $this = shift;
  die("Path doesn't exist") unless -d $this->path;
}

sub _getMode {
    my ($this, $file) = @_;
    return (stat($file))[2];
}

sub _isWW {
    my ($this, $mode) = @_;
    return ($mode & S_IWOTH) ? 1 : 0;
}

sub _removeWW {
    my ($this, $mode) = @_;
    return $mode ^ S_IWOTH;
}

sub process {
    my $this = shift;
    my @files;
    find(sub {
      my $mode = $this->_getMode($_);
      if(-f $_ && $this->_isWW($mode)) {
        push @files, $File::Find::name;
        chmod $this->_removeWW($mode), $_ if $this->remove_ww;
      }
    }, $this->path);
    return @files;
}

1;
__END__

=head1 NAME

FileTool - Perl extension for find and remove world writable files

=head1 SYNOPSIS

  use FileTool;
  my $ft = FileTool->new(path => '/path/', remove_ww => 1);
  my @files = $ft->process();

=head1 DESCRIPTION

Perl extension for find and remove world writable files

params:

`path` - path to directory
`remove_ww` - boolean, remove the permission if set

=head2 EXPORT

none

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Amir, E<lt>amir@apple.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Amir

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
