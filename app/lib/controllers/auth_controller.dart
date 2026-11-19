import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/keys.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/utils/app_utils.dart';

import '../constants/routes.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  ApiController apiController = Get.find<ApiController>();
  AppUtils utils = Get.find<AppUtils>();
  RxBool isObscured = true.obs;
  RxBool isLoading = false.obs;
  RxBool isUpdatingProfile = false.obs;
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
      final expiresIn = (apiResponse['expiresInSeconds'] ?? 2592000).toString();
      utils.storeStringInPrefs(
        key: AppKeys.authenticatedAt,
        value: jsonEncode({
          'savedAt': '${DateTime.now()}',
          'expiresInSeconds': expiresIn,
        }),
      );
      Get.offAllNamed(AppRoutes.main);
    } else {
      errorMsg.value = response.message;
      if (statusCode != null && statusCode == 700) {
        Get.rawSnackbar(
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.errorBg,
          borderRadius: 12,
          messageText: Text(
            'No internet!',
            style: GoogleFonts.dmSans(
              color: AppColors.errorText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          barBlur: 50,
          margin: const EdgeInsets.all(12),
        );
      }
      if (statusCode != null && statusCode == 401) {
        Get.rawSnackbar(
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.errorBg,
          borderRadius: 12,
          messageText: Text(
            'Invalid credentials!',
            style: GoogleFonts.dmSans(
              color: AppColors.errorText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          barBlur: 50,
          margin: const EdgeInsets.all(12),
        );
      }
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
      if (statusCode != null && statusCode == 409) {
        Get.toNamed(AppRoutes.login);
      }
      if (statusCode != null && statusCode == 700) {
        Get.rawSnackbar(
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.errorBg,
          borderRadius: 12,
          messageText: Text(
            'No internet!',
            style: GoogleFonts.dmSans(
              color: AppColors.errorText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          barBlur: 50,
          margin: const EdgeInsets.all(12),
        );
      }
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
      final expiresIn = (apiResponse['expiresInSeconds'] ?? 2592000).toString();
      utils.storeStringInPrefs(
        key: AppKeys.authenticatedAt,
        value: jsonEncode({
          'savedAt': '${DateTime.now()}',
          'expiresInSeconds': expiresIn,
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

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? currentPassword,
    String? newPassword,
  }) async {
    isUpdatingProfile.value = true;
    errorMsg.value = null;

    Map<String, dynamic> body = {'name': name.trim(), 'email': email.trim()};

    if (newPassword != null && newPassword.trim().isNotEmpty) {
      body['currentPassword'] = currentPassword ?? '';
      body['newPassword'] = newPassword.trim();
    }

    final response = await apiController.patch(
      url: ApiEndpoints.updateProfile,
      body: body,
      isSecured: true,
    );

    int? statusCode = response.statusCode;
    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      final apiResponse = jsonDecode(response.body!);
      user.value = userFromJson(apiResponse['user']);
      isUpdatingProfile.value = false;
      return true;
    } else {
      String msg = 'Failed to update profile';
      if (response.body != null) {
        try {
          final decoded = jsonDecode(response.body!);
          if (decoded['message'] != null) {
            msg = decoded['message'];
          }
        } catch (_) {}
      }
      Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.errorBg,
        borderRadius: 12,
        messageText: Text(
          msg,
          style: GoogleFonts.dmSans(
            color: AppColors.errorText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        barBlur: 50,
        margin: const EdgeInsets.all(12),
      );
      isUpdatingProfile.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    await utils.removeKeyFromPrefs(key: AppKeys.tokenKey);
    await utils.removeKeyFromPrefs(key: AppKeys.authenticatedAt);
    user.value = null;
    if (Get.isRegistered<MainController>()) {
      Get.find<MainController>().screenIndex.value = 0;
      Get.find<MainController>().updateSessionExpiration(isExpired: false);
    }
    Get.offAllNamed(AppRoutes.login);
    isLoading.value = false;
  }
}
