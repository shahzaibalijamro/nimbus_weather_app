import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/controllers/auth_controller.dart';
import 'package:untitled/utils/app_utils.dart';
import 'package:untitled/views/detailed_city.dart';
import 'package:untitled/views/main_screen.dart';
import 'package:untitled/views/login.dart';
import 'package:untitled/views/register.dart';
import 'package:untitled/views/splash_screen.dart';

void main() async {
  final utils = Get.put(AppUtils(), permanent: true);
  await utils.initPrefs();
  Get.put(ApiController(), permanent: true);
  Get.put(AuthController(), permanent: true);
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
        GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
        GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
        GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
        GetPage(name: AppRoutes.main, page: () => const MainScreen()),
        GetPage(
          name: AppRoutes.detailedCity,
          page: () {
            final arguments = Get.arguments;

            return DetailedCity(cityName: arguments['name']);
          },
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
