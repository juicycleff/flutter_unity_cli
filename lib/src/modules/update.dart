
import 'dart:io';

import 'package:flutter_unity_cli/src/services/pub_service.dart';
import 'package:flutter_unity_cli/src/utils/utils.dart';

import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

Future<void> update(List<String> packs, isDev) async {
  var spec = await getPubSpec();
  var dependencies = isDev ? spec.devDependencies : spec.dependencies;
  var yaml = File('pubspec.yaml');
  var node = yaml.readAsLinesSync();
  var isAlter = false;

  var indexDependency = isDev
      ? node.indexWhere((t) => t.contains('dev_dependencies:')) + 1
      : node.indexWhere((t) => t.contains('dependencies:')) + 1;

  for (var pack in packs) {
    if (pack.isEmpty) continue;
    if (!dependencies.containsKey(pack)) {
      output.error('Package is not installed');
      continue;
    }

    isAlter = true;

    var version = await PubService().getPackage(pack, '');
    var index = node.indexWhere((t) => t.contains("  $pack:"));
    if (index < indexDependency) {
      index = node.lastIndexWhere((t) => t.contains("  $pack:"));
    }
    node[index] = "  $pack: ^$version";

    output.success("Updated $pack in pubspec");
  }

  if (isAlter) {
    yaml.writeAsStringSync(node.join('\n'));
  }
}
