import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/controllers/auth_controller.dart';
import 'package:untitled/views/home_screen.dart';
import 'package:untitled/views/login.dart';
import 'package:untitled/views/register.dart';
import 'package:untitled/views/splash_screen.dart';

import 'models/user_model.dart';

void main() {
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => const SplashScreen(),),
        GetPage(name: AppRoutes.login, page: () => const LoginScreen(),),
        GetPage(name: AppRoutes.register, page: () => const RegisterScreen(),),
        GetPage(name: AppRoutes.main, page: () {
          final arguments = Get.arguments;
          if (arguments == null || arguments['user'] == null) {
            return const SplashScreen();
          }
          return MainScreen(user: arguments['user'] as User);
        },),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}