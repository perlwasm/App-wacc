package App::wacc;

use strict;
use warnings;
use 5.010;
use Alien::WASI::libc;
use Path::Tiny qw( path );
use File::Which qw( which );
use Text::ParseWords qw( shellwords );

# ABSTRACT: WebAssembly C compiler wrapper for clang
# VERSION

sub _clang
{
  my $clang = $ENV{APP_WACC_CLANG} // $ENV{CLANG};

  return shellwords($clang) if defined $clang;

  if($^O eq 'darwin')
  {
    my $opt = path('/usr/local/opt');
    if(-d $opt)
    {
      my($dir) = # llvm dirs with version 8 or better
                 grep { $_->basename =~ /^llvm\@([0-9]+)$/ && $1 >= 8 }
                 # all dirs
                 $opt->children;
      my $file = $dir->child('bin/clang');
      $clang = $file->stringify if -x $file;
    }
  }
  else
  {
    $clang = which 'clang';
  }

  unless(defined $clang)
  {
    warn "hint: for macOS install llvm via homebrew" if $^O eq 'darwin';
    die "unable to find an appropriate clang";
  }

  ($clang)
}

sub main
{
  my $class = shift;
  my @cmd = @_;

  my @clang = _clang();

  unshift @cmd, '--target=wasm32-unknown-wasi', '--sysroot' => Alien::WASI::libc->sysroot;
  unshift @cmd, @clang;

  say "+ @cmd" if $ENV{APP_WACC_VERBOSE};
  exec @cmd;

  die "exec failed";
}

1;


