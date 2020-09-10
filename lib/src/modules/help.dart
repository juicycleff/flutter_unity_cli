import 'package:flutter_unity_cli/src/modules/version.dart';

void help() {
  printFlutterUnity();
  print('''
Usage: fuw [options]
Options:
	
- Create: This sets up unity widget plugin for large scale projects
e.g.: fuw create 

 - Update: This allows you update your unity large scale projects on a much grander scale
e.g.: fuw update

 - Add: unity scripts in your project
e.g.: fuw add

''');
}
