
import 'package:flutter_unity_cli/src/modules/start/select_option.dart';

bool selectConfirmDeleteLib([bool autoConfirm = false]) {
  if (autoConfirm) return true;
  var selected = selectOption(
      'This command will delete everything inside the \"lib /\" and \"test\" folders.',
      [
        'No',
        'Yes',
      ]);

  return selected == 1;
}
