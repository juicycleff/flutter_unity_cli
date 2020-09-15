import 'dart:io';

import 'package:flutter_unity_cli/src/modules/start/start.dart';
import 'package:flutter_unity_cli/src/utils/utils.dart' show mainDirectory;

import '../constants.dart';

Future<void> create({
  String projectName,
  String folderName,
  bool withPlaceholder,
  bool useEnvironment,
}) {
  return startFlutterCreate(
    projectName: projectName,
    folderName: folderName,
    withPlaceholder: withPlaceholder,
    useEnvironment: useEnvironment,
  );
}

Future<void> startFlutterCreate({
  String projectName,
  String folderName,
  bool withPlaceholder,
  bool useEnvironment,
}) {
  mainDirectory = folderName + '/';

  var gitArgs = createGitArgs(
    folderName,
    withPlaceholder,
  );

  return startPluginCreate(
    projectName,
    folderName,
    useEnvironment,
    () => Process.start('git', gitArgs, runInShell: true),
  );
}

Future<void> startPluginCreate(
  String projectName,
  String folderName,
  bool useEnvironment,
  Future<Process> Function() cloneProject,
) {
  return start(
    completeStart: true,
    force: true,
    projName: projectName,
    folderName: folderName,
    dir: Directory('$projectName/lib'),
    useEnvironment: useEnvironment,
    cloneProject: cloneProject,
  );
}

List<String> createGitArgs(
  String folderName,
  bool withPlaceholder,
) {
  var gitArgs = ['clone'];
  gitArgs.add('--filter=blob:limit=1m');
  gitArgs.add('--depth');
  gitArgs.add('1');

  if (withPlaceholder) {
    // gitArgs.add('-p');
    // gitArgs.add('placeholder');
  }
  gitArgs.add(repo_url);

  gitArgs.add("${folderName}/temp");
  return gitArgs;
}
