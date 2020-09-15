import 'package:flutter_unity_cli/src/modules/start/start_update.dart';

Future<void> updateUnity({String projectName}) {
  return startPluginUpdate(projectName: projectName);
}

Future<void> startPluginUpdate({String projectName}) {
  return startUpdate(
    force: true,
    projectName: projectName,
  );
}
