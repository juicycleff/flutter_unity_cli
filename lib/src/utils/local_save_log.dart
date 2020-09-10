import 'dart:io';

import 'package:flutter_unity_cli/src/utils/output_utils.dart' as output;
import 'package:path/path.dart';

class LocalSaveLog {
  String _path;
  int _key;

  static final LocalSaveLog _instance = LocalSaveLog._internal();

  factory LocalSaveLog() {
    return _instance;
  }

  LocalSaveLog._internal() {
    _path = '.fuw';
    _key = DateTime.now().millisecondsSinceEpoch;
  }

  void add(String value, [bool modified = false]) {
    final file = File('$_path/$_key');
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    var body = file.readAsStringSync();

    if (modified) {
      body = '$body\nMODIFIED:$value'.trim();
    } else {
      body = '$body\n$value'.trim();
    }

    file.writeAsStringSync(body);
  }

  void removeLastLog() {
    _removeFiles(lastCreatedFiles());
  }

  File _getLastLogFile() {
    try {
      var dir = Directory(_path);
      if (dir.existsSync()) {
        var listInt =
        dir.listSync().map((e) => basename(e.path)).map(int.parse).toList();
        listInt.sort((a, b) => b.compareTo(a));
        final first = listInt.first;
        final file = File('$_path/$first');
        if (file.existsSync()) {
          return file;
        } else {
          throw Exception('No logs registered by flutter unity');
        }
      }
    } catch (e) {
      print('No logs registered by flutter unity');
    }
    return null;
  }

  List<File> lastCreatedFiles([bool returnModifiedFiles = false]) {
    final lastLog = _getLastLogFile();
    final files = <File>[];
    for (var item in lastLog.readAsStringSync().split('\n')) {
      if (returnModifiedFiles) {
        item = item.replaceFirst('MODIFIED:', '');
      } else {
        if (item.contains('MODIFIED:')) {
          item = null;
        }
      }
      if (item != null) {
        var arch = File(item);
        if (arch.existsSync()) {
          files.add(arch);
        }
      }
    }
    return files;
  }

  void _removeFiles(List<File> files) {
    for (var item in files) {
      if (item.existsSync()) {
        item.deleteSync(recursive: true);
        _removeEmptyFolder(item.parent);
        output.warn('REMOVED: $item');
      }
    }
    _deleteLastLog();
  }

  void _deleteLastLog() {
    _getLastLogFile().deleteSync();
  }

  void _removeEmptyFolder(Directory dir) {
    if (dir.listSync().isEmpty) {
      dir.deleteSync();
      _removeEmptyFolder(dir.parent);
    }
  }
}
