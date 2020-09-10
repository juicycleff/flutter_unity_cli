import 'dart:convert';
import 'dart:io';

void upgrade() {
  var isFlutterDart = true;

  if (Platform.isWindows) {
    var process = Process.runSync('where', ['fuw'], runInShell: true);

    isFlutterDart =
        process.stdout.toString().contains('flutter\\.pub-cache\\bin\\fuw');
  } else {
    var process = Process.runSync('which', ['fuw'], runInShell: true);
    isFlutterDart =
        process.stdout.toString().contains('flutter/.pub-cache/bin/fuw');
  }

  if (isFlutterDart) {
    print('Upgrade in Flutter Dart VM');
    Process.runSync('flutter', ['pub', 'global', 'activate', 'flutter_unity_cli'],
        runInShell: true);
  } else {
    print('Upgrade in Dart VM');
    Process.runSync('pub', ['global', 'activate', 'flutter_unity_cli'], runInShell: true);
  }

  var process =
  Process.runSync('fuw', ['-v'], runInShell: true, stdoutEncoding: utf8);
  print(process.stdout);
}
