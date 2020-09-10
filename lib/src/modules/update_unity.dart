import 'dart:io';

import 'package:flutter_unity_cli/flutter_unity_cli.dart';
import 'package:flutter_unity_cli/src/modules/start/start.dart';
import 'package:flutter_unity_cli/src/modules/start/start_update.dart';
import 'package:flutter_unity_cli/src/utils/utils.dart' show mainDirectory;

import '../constants.dart';


Future<void> updateUnity() {
  return startPluginUpdate();
}

Future<void> startPluginUpdate() {
  return startUpdate(
    force: true,
  );
}
