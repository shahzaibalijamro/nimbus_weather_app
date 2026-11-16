import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:untitled/constants/keys.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/models/response_model.dart';
import 'package:untitled/utils/app_utils.dart';

class ApiController {
  AppUtils utils = Get.find<AppUtils>();
  Future<void> _saveToken(String token) async {
    await utils.storeStringInPrefs(key: AppKeys.tokenKey, value: token);
  }

  Future<String> _retrieveToken() async {
    return utils.getStringFromPrefs(key: AppKeys.tokenKey) ?? '';
  }

  Future<bool> checkIfOnline() async {
    try {
      await InternetAddress.lookup('google.com');
      return true;
    } catch (e) {
      print('INTERNET ERROR, $e');
      return false;
    }
  }

  Future<Response> post({
    required String url,
    required Map<String, dynamic> body,
    bool isSecured = false,
    bool isLogin = false,
  }) async {
    if (!await checkIfOnline()) {
      return Response(statusCode: 700, message: 'No Internet!');
    }
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
        print('TOKEN CHALRAHA');
        String token = jsonDecode(response)['token'];
        await _saveToken(token);
      }
      return Response(statusCode: statusCode, body: response);
    } catch (e) {
      print(e);
      // if(status)
      return Response(message: 'Something went wrong!');
    }
  }

  Future<Response> patch({
    required String url,
    required Map<String, dynamic> body,
    bool isSecured = false,
    bool isLogin = false,
  }) async {
    if (!await checkIfOnline()) {
      return Response(statusCode: 700, message: 'No Internet!');
    }
    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (isSecured) {
      String token = await _retrieveToken();
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    try {
      Uri apiURL = Uri.parse(url);
      final request = await http.patch(
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
        print('TOKEN CHALRAHA');
        String token = jsonDecode(response)['token'];
        await _saveToken(token);
      }
      return Response(statusCode: statusCode, body: response);
    } catch (e) {
      print(e);
      // if(status)
      return Response(message: 'Something went wrong!');
    }
  }

  Future<Response> get({
    required String url,
    bool requiresToken = false,
    Map<String, String>? params,
  }) async {
    if (!await checkIfOnline()) {
      return Response(statusCode: 700, message: 'No Internet!');
    }

    Map<String, String> headers = {'Content-Type': 'application/json'};

    if (requiresToken) {
      String token = await _retrieveToken();
      headers.addAll({'Authorization': 'Bearer $token'});
    } else {
      if (isSessionExpired()) {
        if (Get.isRegistered<MainController>()) {
          print('I AM HERE');

          Get.find<MainController>().updateSessionExpiration(isExpired: true);
        }
        return Response(statusCode: 403);
      }
    }

    try {
      Uri apiURL = Uri.parse(url);

      if (params != null) {
        print(params);
        apiURL = apiURL.replace(queryParameters: params);
      }
      print('URL === $apiURL');
      final request = await http.get(apiURL, headers: headers);
      int statusCode = request.statusCode;
      String response = request.body;
      return Response(statusCode: statusCode, body: response);
    } catch (e) {
      print(e);
      return Response(message: 'Something went wrong!');
    }
  }

  Future<Response> delete({required String url}) async {
    if (!await checkIfOnline()) {
      return Response(statusCode: 700, message: 'No Internet!');
    }
    String token = await _retrieveToken();
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      Uri apiURL = Uri.parse(url);
      print('URL === $apiURL');
      final request = await http.delete(apiURL, headers: headers);
      int statusCode = request.statusCode;
      String response = request.body;
      return Response(statusCode: statusCode, body: response);
    } catch (e) {
      print(e);
      return Response(message: 'Something went wrong!');
    }
  }

  bool isSessionExpired() {
    String? lastAuthenticatedAt = utils.getStringFromPrefs(
      key: AppKeys.authenticatedAt,
    );
    if (lastAuthenticatedAt != null) {
      DateTime currentTime = DateTime.now();
      final decoded = jsonDecode(lastAuthenticatedAt);
      final expiresInSeconds = int.parse(decoded['expiresInSeconds']);
      final savedAt = DateTime.parse(decoded['savedAt']);
      if (currentTime.difference(savedAt).inSeconds > expiresInSeconds) {
        return true;
      }
    }
    return false;
  }
}
