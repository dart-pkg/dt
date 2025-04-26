#! /usr/bin/env my-dart

import 'dart:core';
import 'package:sys/sys.dart' as sys;
import 'package:args/args.dart' as args;
import 'package:std/command_runner.dart' as std__;
import 'package:std/misc.dart' as std__;

main(List<String> $args) async {
  if (sys.isInDebugMode) {
    $args = [
      'script',
      r'D:\home11\dart\hello\lib\my.api-call.dart',
      'a',
      'b',
      'cハロー©',
    ];
  }
  // try {
  var $parser = args.ArgParser();
  /*var $command = */
  $parser.addCommand('run');
  $parser.addCommand('fix');
  $parser.addCommand('dep');
  $parser.addCommand('deps');
  $parser.addCommand('projDir');
  var $results = $parser.parse($args);
  var $commandResults = $results.command;
  if ($commandResults == null) {
    throw 'Valid command not specified';
  }
  switch ($commandResults.name) {
    case 'run':
      {
        await run($commandResults);
      }
    case 'fix':
      {
        await fix($commandResults);
      }
    case 'dep':
      {
        await deps($commandResults);
      }
    case 'deps':
      {
        await deps($commandResults);
      }
    case 'projDir':
      {
        await projDir($commandResults);
      }
  }
}

Future<void> run(args.ArgResults $commandResults) async {
  if ($commandResults.rest.isEmpty) {
    throw 'File name count is ${$commandResults.rest.length}: ${$commandResults.rest}';
  }
  String $filePath = $commandResults.rest[0];
  //$filePath = $filePath.replaceAll('/', '\\');
  $filePath = sys.pathFullName($filePath);
  String $libDir = sys.pathDirectoryName($filePath);
  String $cwd = sys.getCwd();
  sys.setCwd($libDir);
  final run = std__.CommandRunner(useUnixShell: false);
  await run.run('specgen');
  sys.setCwd($cwd);
  await run.run$(
    ['dart', $filePath, ...$commandResults.rest.toList().sublist(1)],
    //autoQuote: false,
  );
}

Future<void> fix(args.ArgResults $commandResults) async {
  final run = std__.CommandRunner();
  await run.run('dart fix --apply');
  await run.run('dart format .');
}

Future<void> deps(args.ArgResults $commandResults) async {
  // final run = run__.CommandRunner(useUnixShell: true);
  // await run.run('dart pub deps --no-dev --style list | sed "/^ .*/d"');
  final run = std__.CommandRunner();
  String result = await run.run(
    'dart pub deps --no-dev --style list',
    silent: true,
  );
  List<String> lines = std__.textToLines(result);
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    if (line.startsWith(' ')) continue;
    //print('> $line');
    print(line);
  }
}

Future<void> projDir(args.ArgResults $commandResults) async {
  if ($commandResults.rest.isEmpty) {
    throw 'File name count is ${$commandResults.rest.length}: ${$commandResults.rest}';
  }
  String $filePath = $commandResults.rest[0];
  String $fileDir = sys.pathDirectoryName($filePath);
  String $fn = sys.pathFileName($fileDir);
  if ($fn == 'bin' || $fn == 'lib' || $fn == 'test') {
    print(sys.pathDirectoryName($fileDir));
  } else {
    print($fileDir);
  }
}
