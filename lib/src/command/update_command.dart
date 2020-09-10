import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutter_unity_cli/flutter_unity_cli.dart';
import 'package:flutter_unity_cli/src/modules/update_unity.dart';

class UpdateCommand extends CommandBase {
  @override
  final name = 'update';
  @override
  final description = 'Update flutter unity package to latest';

  UpdateCommand();

  @override
  FutureOr<void> run() async {
    await updateUnity();
    super.run();
  }
}
