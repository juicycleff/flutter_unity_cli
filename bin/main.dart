import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:flutter_unity_cli/flutter_unity_cli.dart';
import 'package:flutter_unity_cli/src/modules/version.dart';

void main(List<String> arguments) {
  final runner = configureCommand(arguments);

  var hasCommand = runner.commands.keys.any((x) => arguments.contains(x));

  if (hasCommand) {
    executeCommand(runner, arguments);
  } else {
    var parser = ArgParser();
    parser = runner.argParser;
    var results = parser.parse(arguments);
    executeOptions(results, arguments, runner);
  }
}

void executeOptions(
    ArgResults results, List<String> arguments, CommandRunner runner) {
  if (results.wasParsed('help') || arguments.isEmpty) {
    printFlutterUnity();
    print(runner.usage);
  }

  if (results.wasParsed('version')) {
    version();
  }
}

void executeCommand(CommandRunner runner, List<String> arguments) {
  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
  });
}



CommandRunner configureCommand(List<String> arguments)  {
  var runner =
  CommandRunner('fuw', 'CLI package manager and boostrap for Flutter Unity Widget project for large teams')
    ..addCommand(UpdateCommand())
    ..addCommand(UpgradeCommand())
    ..addCommand(CreateCommand());

  runner.argParser.addFlag('version', abbr: 'v', negatable: false);
  return runner;
}

