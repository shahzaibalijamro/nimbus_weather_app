import 'package:get/get.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/constants/api.dart';

import '../constants/routes.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  ApiController apiController = ApiController();
  RxBool isObscured = true.obs;
  RxBool isLoading = false.obs;
  final RxnString errorMsg = RxnString();

  void toggleObscurity() {
    isObscured.value = !isObscured.value;
    // update();
  }

  void login({required String email, required String password}) async {
    isLoading.value = true;
    if (email.trim().isEmpty) {
      errorMsg.value = "Email is required";
      return;
    }
    if (password.trim().isEmpty) {
      errorMsg.value = "Password is required";
      return;
    }
    errorMsg.value = null;
    Map<String, dynamic> body = {"email": email, "password": password};
    final response = await apiController.post(
      url: ApiEndpoints.login,
      body: body,
      isLogin: true,
    );
    int statusCode = response.$1;
    if (statusCode == 201 || statusCode == 200) {
      final apiResponse = response.$2;
      User user = userFromJson(apiResponse);
      Get.offAllNamed(AppRoutes.main, arguments: {'user': user});
    } else {
      print("this is running");
      print(response.$2);
      LoginError loginError = loginErrorFromJson(response.$2);
      errorMsg.value = loginError.message;
      print(loginError.message);
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
      errorMsg.value = "Name is required";
      return;
    }
    if (email.trim().isEmpty) {
      errorMsg.value = "Email is required";
      return;
    }
    if (password.trim().isEmpty) {
      errorMsg.value = "Password is required";
      return;
    }
    errorMsg.value = null;

    Map<String, dynamic> body = {
      "name": fullName,
      "email": email,
      "password": password,
    };

    final response = await apiController.post(
      url: ApiEndpoints.signUp,
      body: body,
    );

    int statusCode = response.$1;

    if (statusCode == 201) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      errorMsg.value = response.$2;
    }
    isLoading.value = false;
  }
}
