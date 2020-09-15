import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_unity_cli/src/constants.dart';
import 'package:flutter_unity_cli/src/modules/start/patch_platforms.dart';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;
import 'package:flutter_unity_cli/src/utils/utils.dart';
import 'package:pub_semver/pub_semver.dart';

import 'delete_lib.dart';

Future<void> startUpdate({String projectName, bool force = false}) async {
  // var workingDirectory = dir.path.replaceAll('lib', '');

  // await deleteLib(dir, !dir.parent.existsSync());

  // first create project
  var cloneArgs = [
    'clone',
    '--filter=blob:limit=1m',
    '--depth',
    '1',
    "${repo_url}",
    'temp'
  ];
  final process = await Process.start('git', cloneArgs, runInShell: true);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    output.error('flutter unity project');
    exit(1);
  }

  var dir = Directory('temp');

  var tempPackage = await getNamePackage(dir);
  var tempVersion = await getVersionPackage(dir);

  var package = await getNamePackage(dir.parent);
  var version = await getVersionPackage(dir.parent);

  var currentVersion = Version.parse(version);
  var latestVersion = Version.parse(tempVersion);

  if (latestVersion <= currentVersion) {
    var tempDir = Directory('temp');
    await deleteLib(tempDir, force);
    output.msg('\n\n You are using the latest version');
    exit(1);
  }

  // delete the current folders

  var tempUnDir = Directory('android');
  await deleteLib(tempUnDir, force);
  tempUnDir = Directory('ios');
  await deleteLib(tempUnDir, force);
  tempUnDir = Directory('lib');
  await deleteLib(tempUnDir, force);
  tempUnDir = Directory('pubspec.yaml');
  await deleteLib(tempUnDir, force);
  tempUnDir = Directory('README.md');
  await deleteLib(tempUnDir, force);

  var moveArgs = [
    'temp/android',
    'temp/ios',
    'temp/lib',
    'temp/pubspec.yaml',
    'temp/README.md',
    '${dir.parent}'
  ];
  final mvProcess = await Process.start('mv', moveArgs, runInShell: true);
  await stdout.addStream(mvProcess.stdout);
  await stderr.addStream(mvProcess.stderr);
  final exitCodeMv = await mvProcess.exitCode;
  if (exitCodeMv != 0) {
    output.error('move failed');
    exit(1);
  }

  var parent = Directory('.');
  await patchIOSPlatform(parent, package);
  await patchAndroidPlatform(parent, projectName, update: true);
  await _getPackages(dir.parent.path);

  var tempDir = Directory('temp');
  await deleteLib(tempDir, force);

  output.msg('\n\n Plugin update completed! enjoy!');
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
