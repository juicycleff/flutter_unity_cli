import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

int selectOption(String title, List<String> options) {
  stdin.echoMode = false;
  stdin.lineMode = false;
  var console = Console();
  var isRunning = true;
  var selected = 0;

  while (isRunning) {
    print('\x1B[2J\x1B[0;0H');
    output.title('Flutter Unity CLI Interactive\n');
    output.warn(title);
    for (var i = 0; i < options.length; i++) {
      if (selected == i) {
        print(output.green(options[i]));
      } else {
        print(output.white(options[i]));
      }
    }

    print('\nUse ↑↓ (keyboard arrows)');
    print('Press \'q\' to quit.');

    var key = console.readKey();

    if (key.controlChar == ControlCharacter.arrowDown) {
      if (selected < options.length - 1) {
        selected++;
      }
    } else if (key.controlChar == ControlCharacter.arrowUp) {
      if (selected > 0) {
        selected--;
      }
    } else if (key.controlChar == ControlCharacter.enter) {
      isRunning = false;
      return selected;
    } else if (key.char == 'q') {
      return -1;
    } else {}
  }
  return -1;
}
