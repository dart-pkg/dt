#! /usr/bin/env my-dart

import 'dart:core';
import 'package:std/std.dart' as std_std;
import 'package:args/args.dart' as args_args;
import 'package:std/command_runner.dart' as std_command_runner;
import 'package:std/misc.dart' as std_misc;

Future<void> main(List<String> $args) async {
  if (std_std.isInDebugMode) {
    $args = [
      'script',
      r'D:\home11\dart\hello\lib\my.api-call.dart',
      'a',
      'b',
      'cハロー©',
    ];
  }
  // try {
  var $parser = args_args.ArgParser();
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

Future<void> run(args_args.ArgResults $commandResults) async {
  if ($commandResults.rest.isEmpty) {
    throw 'File name count is ${$commandResults.rest.length}: ${$commandResults.rest}';
  }
  String $filePath = $commandResults.rest[0];
  //$filePath = $filePath.replaceAll('/', '\\');
  $filePath = std_std.pathFullName($filePath);
  String $libDir = std_std.pathDirectoryName($filePath);
  String $cwd = std_std.getCwd();
  std_std.setCwd($libDir);
  final run = std_command_runner.CommandRunner(useUnixShell: false);
  await run.run('specgen');
  std_std.setCwd($cwd);
  await run.run$(
    ['dart', $filePath, ...$commandResults.rest.toList().sublist(1)],
    //autoQuote: false,
  );
}

Future<void> fix(args_args.ArgResults $commandResults) async {
  final run = std_command_runner.CommandRunner();
  await run.run('dart fix --apply');
  await run.run('dart format .');
}

Future<void> deps(args_args.ArgResults $commandResults) async {
  // final run = run__.CommandRunner(useUnixShell: true);
  // await run.run('dart pub deps --no-dev --style list | sed "/^ .*/d"');
  final run = std_command_runner.CommandRunner();
  String result = await run.run(
    'dart pub deps --no-dev --style list',
    silent: true,
  );
  List<String> lines = std_misc.textToLines(result);
  for (int i = 0; i < lines.length; i++) {
    String line = lines[i];
    if (line.startsWith(' ')) continue;
    //print('> $line');
    print(line);
  }
}

Future<void> projDir(args_args.ArgResults $commandResults) async {
  if ($commandResults.rest.isEmpty) {
    throw 'File name count is ${$commandResults.rest.length}: ${$commandResults.rest}';
  }
  String $filePath = $commandResults.rest[0];
  String $fileDir = std_std.pathDirectoryName($filePath);
  String $fn = std_std.pathFileName($fileDir);
  if ($fn == 'bin' || $fn == 'lib' || $fn == 'test') {
    print(std_std.pathDirectoryName($fileDir));
  } else {
    print($fileDir);
  }
}
