use Test2::V0 -no_srand => 1;
use App::wacc;
use Alien::WASI::libc;
use Test::Script;
use File::Temp qw( tempdir );
use Path::Tiny qw( path );

my @clang = App::wacc->_clang;
ok( scalar @clang, 'found an appropriate clang' );

diag '';
diag '';
diag '';
diag "clang = @clang";
diag '';
diag '';

my $dir = path( tempdir( CLEANUP => 1 ) );

script_compiles 'bin/wacc';

my $stdout = '';
my $stderr = '';
$ENV{APP_WACC_VERBOSE} = 1;
my $ok = script_runs
  ['bin/wacc', 'corpus/test.c', -o => "$dir/foo.wasm"],
  { stdout => \$stdout, stderr => \$stderr },
  'compiles a program okay',
;

if($ok)
{
  note "[stdout]\n$stdout" if $stdout ne '';
  note "[stderr]\n$stderr" if $stderr ne '';
  ok -f "$dir/foo.wasm", "generated foo.wasm";
}
else
{
  diag "[stdout]\n$stdout" if $stdout ne '';
}

if($stderr =~ /cannot open (\S+\/libclang_rt.builtins-wasm32.a)/ && Alien::WASI::libc->can('_builtins'))
{
  my $clang_path = $1;
  my $clang_dir  = path($clang_path)->parent;
  my $alien_path = Alien::WASI::libc->_builtins;
  diag '';
  diag '';
  diag "clang is probably missing libclang_rt.builtins-wasm32.a: try:";
  diag "sudo mkdir -p $clang_dir && sudo cp $alien_path $clang_path";
}

diag '';
diag '';

done_testing;


