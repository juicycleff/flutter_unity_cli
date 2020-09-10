import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_unity_cli/flutter_unity_cli.dart';
import 'package:flutter_unity_cli/src/modules/start/patch_platforms.dart';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

import 'delete_lib.dart';

Future<void> start({
  bool completeStart,
  bool force = false,
  Directory dir,
  String projName,
  bool useEnvironment = true,
  Future<Process> Function() cloneProject,
}) async {
  dir ??= Directory('lib');
  var workingDirectory = dir.path.replaceAll('lib', '');
  var parentDir = Directory(workingDirectory);

  // first create project
  var folderArgs = [projName];
  final rootProcess = await Process.start('mkdir', folderArgs, runInShell: true);
  await stdout.addStream(rootProcess.stdout);
  await stderr.addStream(rootProcess.stderr);
  final exitCode = await rootProcess.exitCode;
  if (exitCode != 0) {
    output.error('Folder exist');
    exit(1);
  }

  if (cloneProject != null) {
    final process = await cloneProject();
    await stdout.addStream(process.stdout);
    await stderr.addStream(process.stderr);
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      output.error('flutter unity project');
      exit(1);
    }
  }

  // first create project
  var moveArgs = [
    "${projName}/temp/android",
    "${projName}/temp/ios",
    "${projName}/temp/lib",
    "${projName}/temp/pubspec.yaml",
    "${projName}/temp/README.md",
    "${projName}"
  ];
  final mvProcess = await Process.start('mv', moveArgs, runInShell: true);
  await stdout.addStream(mvProcess.stdout);
  await stderr.addStream(mvProcess.stderr);
  final exitCodeMv = await mvProcess.exitCode;
  if (exitCodeMv != 0) {
    output.error('move failed');
    exit(1);
  }


  var tempDir = Directory('$projName/temp');
  await deleteLib(tempDir, force);

  var dirTest = Directory(dir.parent.path + '/test');
  if (await dirTest.exists()) {
    if (dirTest.listSync().isNotEmpty) {
      output.msg('Removing test folder');
      await dirTest.delete(recursive: true);
    }
  }

  // first create project
  var unityFolderArgs = ['${projName}/unity'];
  final unityFolderProcess = await Process.start('mkdir', unityFolderArgs, runInShell: true);
  await stdout.addStream(unityFolderProcess.stdout);
  await stderr.addStream(unityFolderProcess.stderr);
  final unityFolderCode = await unityFolderProcess.exitCode;
  if (unityFolderCode != 0) {
    output.error('Folder exist');
    exit(1);
  }

  await patchIOSPlatform(parentDir, projName);
  // await patchAndroidPlatform(projName);
  await _getPackages(workingDirectory);

  printFlutterUnity();
  output.msg('\n\n            Plugin setup completed! enjoy!');
}

Future<void> _getPackages(String workingDirectory) async {
  final finished = Completer<bool>();
  final process = await Process.start(
    'flutter',
    ['packages', 'get'],
    runInShell: true,
    workingDirectory: workingDirectory.isEmpty ? null : workingDirectory,
  );
  process.stdout.transform(utf8.decoder).listen(
    print,
    cancelOnError: true,
    onDone: () => finished.complete(true),
    onError: (e) => finished.complete(true),
  );
  return finished.future;
}
