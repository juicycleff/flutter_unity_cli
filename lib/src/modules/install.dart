import 'dart:io';

import 'package:flutter_unity_cli/src/modules/update.dart';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;
import 'package:flutter_unity_cli/src/services/pub_service.dart';
import 'package:flutter_unity_cli/src/utils/utils.dart';

Future<void> install(List<String> packs, bool isDev,
    {bool haveTwoLines, String directory}) async {
  var spec = await getPubSpec(
      directory: directory == null ? null : Directory(directory));
  var yaml =
  File(directory == null ? 'pubspec.yaml' : '$directory/pubspec.yaml');
  var node = yaml.readAsLinesSync();
  var indexDependency = node.indexWhere((t) => t.contains('dependencies:')) + 1;
  var indexDependencyDev =
      node.indexWhere((t) => t.contains('dev_dependencies:')) + 1;
  var isAlter = false;
  haveTwoLines = haveTwoLines ?? false;
  var dependencies = isDev ? spec.devDependencies : spec.dependencies;

  for (var pack in packs) {
    var packName = '';
    var version = '';

    if (pack.contains(':')) {
      packName = pack.split(':')[0];
      version = pack.split(':').length > 1
          ? pack.split(':')[1] +
          ':' +
          pack.split(':').sublist(2).reduce((a, b) => a + ':' + b)
          : pack.split(':')[1];
    } else {
      packName = pack;
    }

    if (dependencies.containsKey(packName) && !haveTwoLines) {
      await update([packName], isDev);
      continue;
    }

    try {
      if (!haveTwoLines) {
        version = await PubService().getPackage(packName, version);
        node.insert(isDev ? indexDependencyDev : indexDependency,
            "  $packName: ^$version");
      } else if (!dependencies.containsKey(packName)) {
        node.insert(isDev ? indexDependencyDev : indexDependency,
            "  $packName: \n    $version");
      }
      output.success("$packName:$version Added in pubspec");
      isAlter = true;
    } catch (e) {
      output.error('Version or package not found');
    }
    if (isAlter) {
      yaml.writeAsStringSync(node.join('\n'));
    }
  }
}
