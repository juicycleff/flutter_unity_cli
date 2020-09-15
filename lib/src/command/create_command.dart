import 'dart:async';
import 'dart:io';

import 'package:flutter_unity_cli/flutter_unity_cli.dart';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

class CreateCommand extends CommandBase {
  @override
  final name = 'create';
  @override
  final description =
      'Bootstrap a flutter unity package for improved release pipeline';
  @override
  final invocationSuffix = '<project name>';

  CreateCommand() {
    argParser.addFlag(
      'placeholder',
      abbr: 'p',
      negatable: false,
      help:
          'Create a flutter project with 3 enviroment/flavors files(dev, qa and prod).',
      defaultsTo: true,
    );

    argParser.addFlag(
      'use_enviroment',
      abbr: 'e',
      negatable: false,
      help:
          'Create a flutter project with 3 enviroment/flavors files(dev, qa and prod).',
      defaultsTo: true,
    );
  }

  @override
  FutureOr<void> run() async {
    var folderName = 'flutter_unity_widget';

    if (argResults.rest.isNotEmpty) {
      var projectName = argResults.rest.first;
      await create(
        projectName: projectName,
        folderName: folderName,
        withPlaceholder: argResults['placeholder'],
        useEnvironment: argResults['use_enviroment'],
      );
    } else {
      output.error('Missing flutter project path');
      exit(1);
    }
    super.run();
  }
}
