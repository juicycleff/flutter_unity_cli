import 'dart:io';

import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

import 'select_confirm_delete_lib.dart';

Future<void> deleteLib(Directory dir, [bool autoConfirm]) async {
  if (await dir.exists() && dir.listSync().isNotEmpty) {
    if (selectConfirmDeleteLib(autoConfirm)) {
      output.msg('Removing ${dir.path} folder');
      await dir.delete(recursive: true);
    } else {
      output.error('The ${dir.path} folder must be empty');
      // exit(1);
    }
  }
}
