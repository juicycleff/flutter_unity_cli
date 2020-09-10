
import 'dart:async';

import 'package:flutter_unity_cli/flutter_unity_cli.dart';


class UpgradeCommand extends CommandBase {
  @override
  final name = 'upgrade';
  @override
  final description = 'Upgrade the Flutter Unity CLI version';

  @override
  FutureOr<void> run() {
    upgrade();
  }
}
