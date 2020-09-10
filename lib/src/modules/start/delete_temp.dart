import 'dart:io';

import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;

import 'select_confirm_delete_lib.dart';

Future<void> deleteTemp(Directory dir, [bool autoConfirm]) async {
  if (await dir.exists() && dir.listSync().isNotEmpty) {
    if (selectConfirmDeleteLib(autoConfirm)) {
      output.msg('Removing temp folder');
      await dir.delete(recursive: true);
    } else {
      output.error('The temp folder must be empty');
      exit(1);
    }
  }
}
