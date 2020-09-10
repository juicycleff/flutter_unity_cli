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
    var projectName = 'flutter_unity_widget';
    if(argResults.rest.isNotEmpty) {
      projectName = argResults.rest.first;
    }

    await create(
      projectName: projectName,
      withPlaceholder: argResults['placeholder'],
      useEnvironment: argResults['use_enviroment'],
    );
    super.run();
  }
}
