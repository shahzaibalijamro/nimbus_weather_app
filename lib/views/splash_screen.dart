import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/controllers/auth_controller.dart';
import 'package:untitled/views/main_screen.dart';
import 'package:untitled/views/login.dart';

import '../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController controller = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => controller.checkForUser());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B1B3A),
      body: Center(
        child: Column(
          children: [
            Spacer(),
            Text(
              'Nimbus',
              style: GoogleFonts.sora(
                fontSize: 44,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Weather & city guide',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Color(0xFF9FB4DD),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Checking your session…',
              style: GoogleFonts.dmMono(
                fontSize: 13,
                color: Color(0xFF9FB4DD),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24),
            Obx(() {
              if (controller.isLoading.value)
                return SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(color: Colors.white),
                );
              return SizedBox.shrink();
            }),
            Obx(() {
              if (controller.errorMsg.value != null) {
                return InkWell(
                  onTap: controller.checkForUser,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      'RETRY',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        color: Color(0xFF9FB4DD),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
