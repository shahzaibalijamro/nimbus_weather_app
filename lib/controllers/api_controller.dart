import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/constants/keys.dart';

class ApiController {
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppKeys.tokenKey, token);
  }

  Future<String> _retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppKeys.tokenKey) ?? "";
  }

  Future<bool> checkIfOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print(result);
      return true;
    } catch (e) {
      print("INTERNET ERROR, $e");
      return false;
    }
  }

  Future<(int, String)> post({
    required String url,
    required Map<String, dynamic> body,
    bool isSecured = false,
    bool isLogin = false,
  }) async {
    // bool isOnline = await checkIfOnline();
    // if(!isOnline) {
    //   return (707, "No internet!");
    // }
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (isSecured) {
      String token = await _retrieveToken();
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Uri apiURL = Uri.parse(url);
      final request = await http.post(
        apiURL,
        headers: headers,
        body: jsonEncode(body),
      );
      int statusCode = request.statusCode;
      String response = request.body;
      print(statusCode);
      print(response);

      // save token if login
      if (isLogin && (statusCode == 200 || statusCode == 201)) {
        print("TOKEN CHALRAHA");
        String token = jsonDecode(response)["token"];
        await _saveToken(token);
      }
      return (statusCode, response);
    } catch (e) {
      print(e);
      // if(status)
      return (600, "Something went wrong!");
    }
  }

  Future<(int, String)> get({
    required String url,
    bool isSecured = false,
  }) async {
    // bool isOnline = await checkIfOnline();
    // if(!isOnline) {
    //   return (707, "No internet!");
    // }
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (isSecured) {
      String token = await _retrieveToken();
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Uri apiURL = Uri.parse(url);
      final request = await http.get(apiURL, headers: headers);
      int statusCode = request.statusCode;
      String response = request.body;
      return (statusCode, response);
    } catch (e) {
      print(e);
      return (600, "Something went wrong!");
    }
  }
}
