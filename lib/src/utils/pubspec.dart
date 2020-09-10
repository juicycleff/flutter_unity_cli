import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;
import 'package:yaml/yaml.dart';


class PubSpec {
  final String name;
  final String version;
  final Map dependencies;
  final Map devDependencies;

  PubSpec({this.version, this.devDependencies, this.dependencies, this.name});

  static Future<PubSpec> load(Directory dir) async {
    try {
      final file = dir
          .listSync()
          .firstWhere((i) => i.path.contains('pubspec.yaml')) as File;

      YamlMap doc = loadYaml(file.readAsStringSync());

      return PubSpec(
          name: doc['name'],
          version: doc['version'],
          dependencies: Map.from(doc['dependencies']),
          devDependencies: Map.from(doc['dev_dependencies']));
    } catch (e) {
      output.error('No valid project found in this folder.');
      output.title("If you haven't created your project yet create with:");

      print('');
      print('fuw create flutter_unity_widget');
      print('');

      output.title('Or enter your project folder with to use fuw: ');

      print('');
      print('cd flutter_unity_widget && fuw start');
      print('');

      exit(1);
      return null;
    }
  }

  PubSpec copy({Map devDependencies, Map dependencies, String name, String version}) {
    return PubSpec(
      devDependencies: devDependencies ?? this.devDependencies,
      dependencies: dependencies ?? this.dependencies,
      name: name ?? this.name,
      version: version ?? this.version,
    );
  }

  void replacePubSpecYaml(String path) {
    final pubSpecYaml =
    File("${path}pubspec.yaml").readAsStringSync().toPubspecYaml();

    var buffer = StringBuffer();
    //Name
    buffer.write("name: '${pubSpecYaml.name}'\n");
    //Description
    buffer.write(
        "description: '${pubSpecYaml.description.hasValue ? pubSpecYaml.description.unsafe : ""}'\n\n");
    //Version and documentation
    buffer.write(''
        '# The following line prevents the package from being accidentally published to\n '
        '# pub.dev using `pub publish`. This is preferred for private packages.\n\n');
    buffer.write(''
        '# A version number is three numbers separated by dots, like 1.2.43\n'
        '# followed by an optional build number separated by a +.\n'
        '# In Android, build-name is used as versionName while build-number used as versionCode.\n'
        '# Read more about Android versioning at https://developer.android.com/studio/publish/versioning\n'
        '# In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.\n'
        '# Read more about iOS versioning at\n'
        '# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html\n\n'
        '# We inserted the following format, for versioning control:\n\n'
        '# <<YEAR>>.<<MILESTONE>>.<<FIXES>>.\n\n'
        '# YEAR: represents the year of product launch, receiving the AAAA format.\n'
        '# MILESTONE: represents the project milestone, being non-negative integers.\n'
        '# FIXES: represents the bug fixes, being non-negative integers.\n\n'
        "# All products will be launched with this version format, following the example: ${DateTime.now().year}.1.1\n"
        '# To more info please visit our Handbook at https://handbook.fuwmanlabs.com/desenvolvimento/qa/controle-de-versao.html\n');
    buffer.write("version: ${DateTime.now().year}.1.0+1\n\n");
    //Environment
    buffer.write('environment:\n');
    pubSpecYaml.environment.forEach((key, value) {
      buffer.write("  $key: '$value'\n");
    });
    buffer.write('\n\n');
    //Dependencies
    buffer.write('dependencies:\n');
    pubSpecYaml.dependencies.toList().forEach(
            (element) => buffer.write(_mapPubSpecDependencySpecToString(element)));
    buffer.write('\n\n');
    //Dev dependencies
    buffer.write('dev_dependencies:\n');
    pubSpecYaml.devDependencies.toList().forEach(
            (element) => buffer.write(_mapPubSpecDependencySpecToString(element)));
    buffer.write('\n\n');
    buffer.write(''
        '# For information on the generic Dart part of this file, see the\n'
        '# following page: https://dart.dev/tools/pub/pubspec\n');
    buffer.write('\n\n');
    //Flutter
    pubSpecYaml.customFields.forEach((key, value) {
      buffer.write('# The following section is specific to Flutter.\n');
      buffer.write("$key:\n\n");
      buffer.write(
          '# The following line ensures that the Material Icons font is\n'
              '# included with your application, so that you can use the icons in\n'
              '# the material Icons class.\n');
      Map<String, dynamic>.from(value).forEach((key, value) {
        buffer.write("  $key: $value\n");
      });
    });
    buffer.write('\n');
    buffer.write(
        '  # To add assets to your application, add an assets section, like this:\n');
    buffer.write('  # assets:\n');
    buffer.write('  #   - images/a_dot_burr.jpeg\n');
    buffer.write('  #   - images/a_dot_ham.jpeg\n\n');
    buffer.write(
        '  # An image asset can refer to one or more resolution-specific \"variants\", see\n');
    buffer.write(
        '  # https://flutter.dev/assets-and-images/#resolution-aware.\n\n');
    buffer.write(
        '  # For details regarding adding assets from package dependencies, see\n');
    buffer
        .write('  # https://flutter.dev/assets-and-images/#from-packages\n\n');
    buffer.write(
        '  # To add custom fonts to your application, add a fonts section here,\n');
    buffer.write(
        '  # in this \"flutter\" section. Each entry in this list should have a\n');
    buffer.write(
        '  # \"family\" key with the font family name, and a \"fonts\" key with a\n');
    buffer.write(
        '  # list giving the asset and other descriptors for the font. For\n');
    buffer.write('  # example:\n');
    buffer.write('  # fonts:\n');
    buffer.write('  #   - family: Schyler\n');
    buffer.write('  #     fonts:\n');
    buffer.write('  #       - asset: fonts/Schyler-Regular.ttf\n');
    buffer.write('  #       - asset: fonts/Schyler-Italic.ttf\n');
    buffer.write('  #         style: italic\n');
    buffer.write('  #   - family: Trajan Pro\n');
    buffer.write('  #     fonts:\n');
    buffer.write('  #       - asset: fonts/TrajanPro.ttf\n');
    buffer.write('  #       - asset: fonts/TrajanPro_Bold.ttf\n');
    buffer.write('  #         weight: 700\n');
    buffer.write('  #\n');
    buffer
        .write('  # For details regarding fonts from package dependencies,\n');
    buffer.write('  # see https://flutter.dev/custom-fonts/#from-packages\n');

    File('${path}pubspec.yaml').writeAsStringSync(buffer.toString(),
        mode: FileMode.write, encoding: utf8);
  }

  String _mapPubSpecDependencySpecToString(
      PackageDependencySpec dependencySpec) {
    //https://dart.dev/tools/pub/dependencies

    var buffer = StringBuffer();

    return dependencySpec.iswitch<String>(sdk: (sdk) {
      /*dependencies
        *   flutter_driver:
        *     sdk: flutter
        *     version: ^0.0.1
        * */
      buffer.write("  ${sdk.package}:\n");
      if (sdk.sdk != null) {
        buffer.write("    sdk: ${sdk.sdk}\n");
      }
      if (sdk.version.hasValue) {
        buffer.write("    version: ${sdk.version}\n");
      }
      return buffer.toString();
    }, git: (git) {
      /*dependencies
        *   kittens:
        *     git:
        *       url: git@github.com:munificent/cats.git
        *       ref: some-branch
        *       path: path/to/kittens
        */
      buffer.write("  ${git.package}:\n");
      buffer.write('    git:\n');
      if (git.url != null) {
        buffer.write("      url: ${git.url}\n");
      }
      if (git.ref.hasValue) {
        buffer.write("      ref: ${git.ref}\n");
      }
      if (git.path.hasValue) {
        buffer.write("      path: ${git.path}\n");
      }
      return buffer.toString();
    }, path: (path) {
      /*dependencies
         *  transmogrify:
         *    path: /Users/me/transmogrify
        */
      buffer.write("  ${path.package}:\n");
      buffer.write("    ${"path: ${path.path}"}\n");
      return buffer.toString();
    }, hosted: (hosted) {
      /*dependencies
        *   transmogrify: ^1.4.0
        */
      return "  ${hosted.package}: ${hosted.version.hasValue ? hosted.version.unsafe : ""}\n";
    });
  }
}
