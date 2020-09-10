import 'dart:convert';
import 'dart:io';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

void patchIOSPlatform(Directory dir, String projectName) {
  var pubSecPatch = '''
   spec.xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '"\${PODS_ROOT}/../.symlinks/plugins/$projectName/ios" "\${PODS_ROOT}/../.symlinks/flutter/ios-release" "\${PODS_CONFIGURATION_BUILD_DIR}"',
    'OTHER_LDFLAGS' => '\$(inherited) -framework UnityFramework \${PODS_LIBRARIES}'
  }

   # Extract precompiled framework from tarball before compiling
   spec.prepare_command     = "tar -xvjf UnityFramework.tar.bz2"
   spec.vendored_frameworks = "UnityFramework.framework"
  ''';

  try {
    var iosDir = Directory('${dir.path}ios');
    final file = iosDir
        .listSync()
        .firstWhere((i) => i.path.contains('${projectName}.podspec')) as File;

    var regex = RegExp(r'\w\.xcconfig(?:[^}]*})+', multiLine: true);
    var podspec = file.readAsStringSync();
    podspec = podspec.replaceAll(regex, pubSecPatch);
    File('${projectName}/ios/${projectName}.podspec').writeAsStringSync(podspec,
        mode: FileMode.write, encoding: utf8);
  } catch(e) {
    output.error(e);
    exit(1);
  }

}

void patchAndroidPlatform(Directory dir, String projectName) {

}
