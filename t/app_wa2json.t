use Test2::V0 -no_srand => 1;
use Test2::Tools::JSON::Pointer;
use Test::Script;
use App::wa2json;

script_compiles 'bin/wa2json';
my($stdout, $stderr);
script_runs
  ['bin/wa2json', 'corpus/foo.wat'],
  { stdout => \$stdout, stderr => \$stderr },
  'runs okay'
;

is(
  $stdout,
  json('' => hash {
    field exports => array { etc; };
    field imports => array { etc; };
  }),
  'json is okay then',
);

done_testing;
