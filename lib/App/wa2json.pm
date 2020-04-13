package App::wa2json;

use strict;
use warnings;
use 5.010;
use Wasm::Wasmtime 0.04;
use JSON::MaybeXS ();

# ABSTRACT: Print WebAssembly imports and exports as JSON
# VERSION

sub _functype
{
  my(undef, $port, $functype) = @_;
  $port->{params} = [map {$_->kind} $functype->params];
  $port->{results} = [map {$_->kind} $functype->results];
}

sub _globaltype
{
  my(undef, $port, $globaltype) = @_;
  $port->{content} = $globaltype->content->kind;
  $port->{mutability} = $globaltype->mutability;
}

sub _tabletype
{
  my(undef, $port, $tabletype) = @_;
  $port->{element} = $tabletype->element->kind;
  $port->{limits}  = $tabletype->limits;
}

sub _memorytype
{
  my(undef, $port, $memorytype) = @_;
  $port->{limits} = $memorytype->limits;
}

sub main
{
  my $class = shift;
  my $file = shift;

  unless(defined $file && -r $file)
  {
    print STDERR "usage: $0 wasm_or_watfile\n";
    return 2;
  }

  my %module;

  my $module = Wasm::Wasmtime::Module->new( file => $file );

  foreach my $importtype ($module->imports)
  {
    my $kind   = $importtype->type->kind;

    my %import = (
      module => $importtype->module,
      name   => $importtype->name,
      kind   => $kind,
    );
    push @{ $module{imports} }, \%import;

    my $method1 = "as_${kind}type";
    my $method2 = "_${kind}type";

    __PACKAGE__->$method2(\%import, $importtype->type->$method1);
  }

  foreach my $exporttype ($module->exports)
  {
    my $kind = $exporttype->type->kind;

    my %export = (
      name => $exporttype->name,
      kind => $kind,
    );

    push @{ $module{exports} }, \%export;

    my $method1 = "as_${kind}type";
    my $method2 = "_${kind}type";

    __PACKAGE__->$method2(\%export, $exporttype->type->$method1);
  }

  print JSON::MaybeXS
    ->new
    ->pretty(1)
    ->canonical(1)
    ->encode(\%module);

  return 0;
}

1;
