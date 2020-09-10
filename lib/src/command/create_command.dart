import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutter_unity_cli/flutter_unity_cli.dart';

class CreateCommand extends CommandBase {
  @override
  final name = 'create';
  @override
  final description = 'Bootstrap a flutter unity package for improved release pipeline';
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
    if (argResults.rest.isEmpty) {
      throw UsageException(
          'project name not passed for a create command', usage);
    } else {
      await create(
        projectName: argResults.rest.first,
        withPlaceholder: argResults['placeholder'],
        useEnvironment: argResults['use_enviroment'],
      );
    }
    super.run();
  }
}
