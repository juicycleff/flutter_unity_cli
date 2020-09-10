import 'dart:io';
import 'package:flutter_unity_cli/src/utils/pubspec.dart';
import 'package:yaml/yaml.dart';

String mainDirectory = '';
String _libPath;

String formatName(String name) {
  name = name
      .replaceAll('_', ' ')
      .split(' ')
      .map((t) => t[0].toUpperCase() + t.substring(1))
      .join()
      .replaceFirst('.dart', '');
  return name;
}

Future<String> getNamePackage([Directory dir]) async {
  var yaml = await getPubSpec(directory: dir ?? Directory(mainDirectory));
  return yaml.name;
}

Future<String> getVersionPackage([Directory dir]) async {
  var yaml = await getPubSpec(directory: dir ?? Directory(mainDirectory));
  return yaml.version;
}


bool existsFile(String path, [bool reset = false]) {
  if (path.contains('.')) {
    return File(libPath(path, reset: reset)).existsSync();
  }
  return Directory(libPath(path, reset: reset)).existsSync();
}

Future<bool> checkDependency(String dep) async {
  try {
    var yaml = await getPubSpec();
    return yaml.dependencies.containsKey(dep);
  } catch (e) {
    print(e);
    return false;
  }
}

Future<String> getVersion() async {
  var file =
  File(File.fromUri(Platform.script).parent.parent.path + '/pubspec.lock');
  var doc = loadYaml(file.readAsStringSync());
  return doc['packages']['fuw']['version'].toString();
}

Future<PubSpec> getPubSpec({Directory directory}) async {
  var pubSpec = await PubSpec.load(directory ?? Directory("$mainDirectory"));
  return pubSpec;
}

Future removeAllPackages([String directory]) async {
  var pubSpec = await getPubSpec(
      directory: directory == null ? null : Directory(directory));
  var dep = pubSpec.dependencies.keys
      .map((f) => f.toString())
      .where((t) => t != 'flutter')
      .toList();

  var devDep = pubSpec.devDependencies.keys
      .map((f) => f.toString())
      .where((t) => t != 'flutter_test')
      .toList();

  // await uninstall(dep, false, false, directory);
  // await uninstall(devDep, true, false, directory);
}

bool checkParam(List<String> args, String param) {
  return args.contains(param);
}

String libPath(String path, {bool reset = false}) {
  if (reset || _libPath == null) {
    if (Directory("${mainDirectory}lib/src").existsSync()) {
      _libPath = "${mainDirectory}lib/src";
    } else if (Directory("${mainDirectory}lib/app").existsSync()) {
      _libPath = "${mainDirectory}lib/app";
    } else {
      _libPath = "${mainDirectory}lib/src";
    }
  }
  return _libPath + "/$path";
}

bool validateUrl(String url) {
  var urlPattern =
      r'(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?';
  var match = RegExp(urlPattern, caseSensitive: false).firstMatch(url);
  return match != null ? true : false;
}
