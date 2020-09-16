import 'dart:convert';
import 'dart:io';

import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_modify/yaml_modify.dart';

void patchIOSPlatform(Directory dir, String foldertName) {
  var pubSecPatch = '''
   spec.xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '"\${PODS_ROOT}/../.symlinks/plugins/$foldertName/ios" "\${PODS_ROOT}/../.symlinks/flutter/ios-release" "\${PODS_CONFIGURATION_BUILD_DIR}"',
    'OTHER_LDFLAGS' => '\$(inherited) -framework UnityFramework \${PODS_LIBRARIES}'
  }

   # Extract precompiled framework from tarball before compiling
   spec.vendored_frameworks = "UnityFramework.framework"
  ''';

  try {
    var iosDir = Directory('${dir.path}/ios');
    final file = iosDir
        .listSync()
        .firstWhere((i) => i.path.contains('${foldertName}.podspec')) as File;

    var regex = RegExp(r'\w\.xcconfig(?:[^}]*})+', multiLine: true);
    var podspec = file.readAsStringSync();
    podspec = podspec.replaceAll(regex, pubSecPatch);
    File('${foldertName}/ios/${foldertName}.podspec')
        .writeAsStringSync(podspec, mode: FileMode.write, encoding: utf8);
  } catch (e) {
    output.error(e);
    exit(1);
  }
}

void patchAndroidPlatform(Directory dir, String projectName,
    {bool update = false}) {
  var settingsGradlePatch = '''

def plugins = new Properties()
def pluginsFile = new File(flutterProjectRoot.toFile(), '.flutter-plugins')
if (pluginsFile.exists()) {
    pluginsFile.withReader('UTF-8') { reader -> plugins.load(reader) }
}

plugins.each { name, path ->
    def pluginDirectory = flutterProjectRoot.resolve(path).resolve('android').toFile()
    include ":\$name"
    project(":\$name").projectDir = pluginDirectory

    if (name == 'flutter_unity_widget') {
        include ":unityLibrary"
        project(":unityLibrary").projectDir=flutterProjectRoot.resolve(path).resolve('android/unityLibrary').toFile()
    }
}
  ''';

  var settingsPlugGradlePatch = '''

include ":unityLibrary"
  ''';

  try {
    if (!update) {
      var androidDir = Directory('${projectName}/android');
      final file = androidDir
          .listSync()
          .firstWhere((i) => i.path.contains('settings.gradle')) as File;
      var settingsGradleText = file.readAsStringSync();

      var pluginAndroidDir = Directory('flutter_unity_widget/android');
      final file2 = pluginAndroidDir
          .listSync()
          .firstWhere((i) => i.path.contains('settings.gradle')) as File;
      var settingsGradle = file2.readAsStringSync();

      if (!settingsGradle.contains('include ":unityLibrary"')) {
        settingsGradle += settingsPlugGradlePatch;

        File('flutter_unity_widget/android/settings.gradle').writeAsStringSync(
          settingsGradle,
          mode: FileMode.write,
          encoding: utf8,
        );
      }

      if (!settingsGradleText.contains('include ":unityLibrary"')) {
        settingsGradleText += settingsGradlePatch;

        File('${projectName}/android/settings.gradle').writeAsStringSync(
          settingsGradleText,
          mode: FileMode.write,
          encoding: utf8,
        );
      }
    } else {
      var androidDir = Directory('../${projectName}/android');
      final file = androidDir
          .listSync()
          .firstWhere((i) => i.path.contains('settings.gradle')) as File;
      var settingsGradleText = file.readAsStringSync();

      var pluginAndroidDir = Directory('android');
      final file2 = pluginAndroidDir
          .listSync()
          .firstWhere((i) => i.path.contains('settings.gradle')) as File;
      var settingsGradle = file2.readAsStringSync();

      if (!settingsGradle.contains('include ":unityLibrary"')) {
        settingsGradle += settingsPlugGradlePatch;
      }

      if (!settingsGradleText.contains('include ":unityLibrary"')) {
        settingsGradleText += settingsGradlePatch;

        File('../${projectName}/android/settings.gradle').writeAsStringSync(
            settingsGradleText,
            mode: FileMode.write,
            encoding: utf8);
      }
    }
  } catch (e) {
    output.error(e);
    exit(1);
  }
}

void patchFlutterPlatform(Directory dir, String projectName) {
  try {
    final pubSpecYaml =
        File("${projectName}/pubspec.yaml").readAsStringSync().toPubspecYaml();

    File file = File("${projectName}/pubspec.yaml");
    final yaml = loadYaml(file.readAsStringSync());

    final modifiable = getModifiableNode(yaml);
    modifiable['dependencies'] = {
      'assets': ['img1.png', 'img2.png']
    };

    var path = PathPackageDependencySpec(
        package: 'flutter_unity_widget', path: '../flutter_unity_widget');
    var dep = PackageDependencySpec.path(path);
    var depList = pubSpecYaml.dependencies.toList();
    depList.add(dep);

    print(dep);
    var yamlStr = pubSpecYaml.toYamlString();
    print(yamlStr);
    File('${projectName}/pubspec.yaml')
        .writeAsStringSync(yamlStr, mode: FileMode.write, encoding: utf8);
  } catch (e) {
    output.error(e);
    exit(1);
  }
}
