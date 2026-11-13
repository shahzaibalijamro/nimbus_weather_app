import 'dart:convert';

import 'package:get/get.dart';
import 'package:untitled/constants/keys.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/utils/app_utils.dart';

import '../constants/routes.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  ApiController apiController = Get.find<ApiController>();
  AppUtils utils = Get.find<AppUtils>();
  RxBool isObscured = true.obs;
  RxBool isLoading = false.obs;
  final RxnString errorMsg = RxnString();
  final Rxn<User> user = Rxn<User>();

  void toggleObscurity() {
    isObscured.value = !isObscured.value;
    // update();
  }

  void login({required String email, required String password}) async {
    isLoading.value = true;
    if (email.trim().isEmpty) {
      errorMsg.value = 'Email is required';
      return;
    }
    if (password.trim().isEmpty) {
      errorMsg.value = 'Password is required';
      return;
    }
    errorMsg.value = null;
    Map<String, dynamic> body = {'email': email, 'password': password};
    final response = await apiController.post(
      url: ApiEndpoints.login,
      body: body,
      isLogin: true,
    );
    int? statusCode = response.statusCode;
    if (statusCode != null && (statusCode == 201 || statusCode == 200)) {
      final apiResponse = jsonDecode(response.body!);
      user.value = userFromJson(apiResponse['user']);
      // since we don't send token on every upcoming request, we can note the current time in this api where token is recieved and check the upcoming requests against this saved time to simulate an expiration
      utils.storeStringInPrefs(
        key: AppKeys.authenticatedAt,
        value: jsonEncode({
          'savedAt': '${DateTime.now()}',
          'expiresInSeconds': apiResponse['expiresInSeconds'].toString(),
        }),
      );
      Get.offAllNamed(AppRoutes.main);
    } else {
      errorMsg.value = response.message;
    }
    isLoading.value = false;
  }

  void signUp({
    required String fullName,
    required email,
    required password,
  }) async {
    isLoading.value = true;
    if (fullName.trim().isEmpty) {
      errorMsg.value = 'Name is required';
      return;
    }
    if (email.trim().isEmpty) {
      errorMsg.value = 'Email is required';
      return;
    }
    if (password.trim().isEmpty) {
      errorMsg.value = 'Password is required';
      return;
    }
    errorMsg.value = null;

    Map<String, dynamic> body = {
      'name': fullName,
      'email': email,
      'password': password,
    };

    final response = await apiController.post(
      url: ApiEndpoints.signUp,
      body: body,
    );

    int? statusCode = response.statusCode;

    if (statusCode != null && statusCode == 201) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      errorMsg.value = response.message;
    }
    isLoading.value = false;
  }

  Future<void> checkForUser() async {
    isLoading.value = true;
    errorMsg.value = null;
    final response = await apiController.get(
      url: ApiEndpoints.me,
      requiresToken: true,
    );
    int? statusCode = response.statusCode;
    if (statusCode == 201 || statusCode == 200) {
      final apiResponse = jsonDecode(response.body!);
      user.value = userFromJson(apiResponse['user']);
      // since we don't send token on every upcoming request, we can note the current time in this api where token is recieved and check the upcoming requests against this saved time to simulate an expiration
      utils.storeStringInPrefs(
        key: AppKeys.authenticatedAt,
        value: jsonEncode({
          'savedAt': '${DateTime.now()}',
          'expiresInSeconds': '7200',
        }),
      );
      Get.offAllNamed(AppRoutes.main);
    } else {
      if (statusCode == 700) {
        errorMsg.value = 'No Internet!';
        isLoading.value = false;
        return;
      }
      Get.offAllNamed(AppRoutes.login);
    }
    isLoading.value = false;
  }
}
