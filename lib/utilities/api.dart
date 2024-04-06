import 'dart:convert';

import 'package:http/http.dart' as http;

class API {
  static Future<http.Response> makeRequest({
    required String endpoint,
    required Map body,
  }) async {
    var url = Uri.parse(endpoint);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    return response;
  }
}
