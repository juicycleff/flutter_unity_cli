import 'dart:io';

import 'package:flutter_unity_cli/src/modules/start/start.dart';
import 'package:flutter_unity_cli/src/utils/utils.dart' show mainDirectory;

import '../constants.dart';


Future<void> create({
  String projectName,
  bool withPlaceholder,
  bool useEnvironment,
}) {
  return startFlutterCreate(
    projectName: projectName,
    withPlaceholder: withPlaceholder,
    useEnvironment: useEnvironment,
  );
}

Future<void> startFlutterCreate({
  String projectName,
  bool withPlaceholder,
  bool useEnvironment,
}) {
  mainDirectory = projectName + '/';

  var gitArgs = createGitArgs(
    projectName,
    withPlaceholder,
  );

  return startPluginCreate(
    projectName,
    useEnvironment,
        () => Process.start('git', gitArgs, runInShell: true),
  );
}

Future<void> startPluginCreate(
    String projectName,
    bool useEnvironment,
    Future<Process> Function() cloneProject,
    ) {
  return start(
    completeStart: true,
    force: true,
    projName: projectName,
    dir: Directory('$projectName/lib'),
    useEnvironment: useEnvironment,
    cloneProject: cloneProject,
  );
}

List<String> createGitArgs(
    String projectName,
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

  gitArgs.add("${projectName}/temp");
  return gitArgs;
}
