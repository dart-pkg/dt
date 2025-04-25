#! /usr/bin/env my-dart

import 'dart:core';
import 'package:sys/sys.dart' as sys;
import 'package:args/args.dart' as args;
import 'package:run/run.dart' as run__;

// 【Dart】コマンドライン引数解析ライブラリargsを試す https://zenn.dev/slowhand/articles/7ca7a2250b65a3
main(List<String> $args) async {
  //dump(misc.isInDebugMode, 'isInDebugMode');
  if (sys.isInDebugMode) {
    $args = [
      'script',
      r'D:\home11\dart\hello\lib\my.api-call.dart',
      'a',
      'b',
      'cハロー©',
    ];
    //$args = ['run', r'D:\home11\dart\hello\bin\my.api-call.dart'];
    //$args = ['run', r'D:\home11\dart\hello\bin\my.api-call.dart', 'abc'];
    //$args = ['run'];
  }
  // try {
  var $parser = args.ArgParser();
  /*var $command = */
  $parser.addCommand('run');
  //$command.addFlag('all', abbr: 'a');
  // $parser.addCommand('scr');
  // $parser.addCommand('script');
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
    // case 'scr':
    // case 'script':
    //   {
    //     await script($commandResults);
    //   }
  }
  // } catch ($e, $stacktrace) {
  //   dump($e, 'Exception');
  //   dump($stacktrace, 'Stacktrace');
  // }
}

Future<void> run(args.ArgResults $commandResults) async {
  if ($commandResults.rest.isEmpty) {
    throw 'File name count is ${$commandResults.rest.length}: ${$commandResults.rest}';
  }
  String $filePath = $commandResults.rest[0];
  $filePath = $filePath.replaceAll('/', '\\');
  $filePath = sys.pathFullName($filePath);
  String $libDir = sys.pathDirectoryName($filePath);
  String $cwd = sys.getCwd();
  //String $fn = sys.pathFileName($libDir);
  //echo($fn, r'$fn');
  // if ($fn == 'bin' || $fn == 'lib' || $fn == 'test') {
  //   sys.setCwd(sys.pathDirectoryName($libDir));
  // } else {
  //   sys.setCwd($libDir);
  // }
  sys.setCwd($libDir);
  final run = run__.Run(useUnixShell: false);
  await run.$('specgen');
  sys.setCwd($cwd);
  await run.$$(
    'dart',
    arguments: [$filePath, ...$commandResults.rest.toList().sublist(1)],
    //autoQuote: false,
  );
}

Future<void> fix(args.ArgResults $commandResults) async {
  // await sys.runAsync$(['dart', 'fix', '--apply'], useBash: true);
  // await sys.runAsync$(['dart', 'format', '.'], useBash: true);
  final run = run__.Run(useUnixShell: true);
  await run.$('dart fix --apply');
  await run.$('dart format .');
}

Future<void> deps(args.ArgResults $commandResults) async {
  // await sys.runAsync(
  //   'dart pub deps --no-dev --style list | sed "/^ .*/d"',
  //   useBash: true,
  // );
  final run = run__.Run(useUnixShell: true);
  await run.$('dart pub deps --no-dev --style list | sed "/^ .*/d"');
}

// Future<void> script(args.ArgResults $commandResults) async {
//   if ($commandResults.rest.isEmpty) {
//     throw 'File name count is ${$commandResults.rest.length}: ${$commandResults.rest}';
//   }
//   String $filePath = $commandResults.rest[0];
//   $filePath = sys.pathFullName($filePath);
//   String $libDir = sys.pathDirectoryName($filePath);
//   String $cwd = sys.getCwd();
//   String $fn = sys.pathFileName($cwd);
//   echo($fn, r'$fn');
//   if ($fn == 'bin' || $fn == 'lib' || $fn == 'test') {
//     sys.setCwd(sys.pathDirectoryName($libDir));
//   } else {
//     sys.setCwd($libDir);
//   }
//   await sys.runAsync('specgen');
//   sys.setCwd($cwd);
//   var spawner = DartSpawner(
//     directory: io.Directory(sys.pathDirectoryName($libDir)),
//   );
//   String $script = sys.readFileString($filePath);
//   var $spawned = await spawner.spawnDart(
//     $script,
//     $commandResults.rest.toList().sublist(1),
//   );
//   var $exitCode = await $spawned.exitCode;
//   io.exit($exitCode);
// }

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
