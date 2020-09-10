import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:flutter_unity_cli/src/utils/file_utils.dart';
import 'package:flutter_unity_cli/src/utils/local_save_log.dart';

class CommandBase extends Command {
  String invocationSuffix;

  @override
  String get invocation {
    return invocationSuffix != null && invocationSuffix.isNotEmpty
        ? "${super.invocation} $invocationSuffix"
        : "${super.invocation}";
  }

  @override
  String get description => null;

  @override
  String get name => null;

  @override
  FutureOr<void> run() {
    // formatFiles(LocalSaveLog().lastCreatedFiles(true));
  }
}
