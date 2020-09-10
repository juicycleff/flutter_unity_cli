import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter_unity_cli/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class PubService {
  Future<String> getPackage(String pack, String version) async {
    var url = _getUrlPackages() + "/$pack";

    if (version.isNotEmpty) {
      url += "/versions/$version";
    }

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var map = version.isEmpty ? json['latest']['pubspec'] : json['pubspec'];
      return map['version'];
    } else {
      throw Exception('error');
    }
  }

  String _getUrlPackages() {
    var baseUrl = 'https://pub.dev';

    var envVars = Platform.environment;
    final baseUrlEnv = envVars['PUB_HOSTED_URL'];

    if (baseUrlEnv != null && validateUrl(baseUrlEnv)) {
      baseUrl = baseUrlEnv;
    }

    return "$baseUrl/api/packages";
  }
}
