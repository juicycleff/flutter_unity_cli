import 'dart:async';
import 'dart:io';

import 'package:flutter_unity_cli/flutter_unity_cli.dart';
import 'package:flutter_unity_cli/src/modules/update_unity.dart';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

class UpdateCommand extends CommandBase {
  @override
  final name = 'update';
  @override
  final description = 'Update flutter unity package to latest';
  @override
  final invocationSuffix = '<project name>';

  UpdateCommand();

  @override
  FutureOr<void> run() async {
    if (argResults.rest.isNotEmpty) {
      var projectName = argResults.rest.first;
      await updateUnity(
        projectName: projectName,
      );
    } else {
      output.error('Missing flutter project path');
      exit(1);
    }
    super.run();
  }
}
