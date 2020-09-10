import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';

Future<String> _getVersion() async {
  //PubSpec yaml = await getPubSpec(path: File.fromUri(Platform.script).parent.parent.path);
  File file =
  File(File.fromUri(Platform.script).parent.parent.path + "/pubspec.yaml");
  final pubspec = PubspecYaml.loadFromYamlString(file.readAsStringSync());
  return pubspec.version.valueOr(() => '0.1.0');
}

void version() async {
  printFlutterUnity();
  print('CLI package manager and boostrap for Flutter Unity Widget project for large teams');
  print('');
  print("Flutter Unity Widget CLI version: ${await _getVersion()}");
}

void printFlutterUnity() {
  print('''
 ####### #       #     # ####### ####### ####### ######     #     # #     # ### ####### #     # 
 #       #       #     #    #       #    #       #     #    #     # ##    #  #     #     #   #  
 #       #       #     #    #       #    #       #     #    #     # # #   #  #     #      # #   
 #####   #       #     #    #       #    #####   ######     #     # #  #  #  #     #       #    
 #       #       #     #    #       #    #       #   #      #     # #   # #  #     #       #    
 #       #       #     #    #       #    #       #    #     #     # #    ##  #     #       #    
 #       #######  #####     #       #    ####### #     #     #####  #     # ###    #       #                                  
''');
}
