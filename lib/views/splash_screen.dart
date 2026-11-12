import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/auth_controller.dart';

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
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B3A),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Text(
              'Nimbus',
              style: GoogleFonts.sora(
                fontSize: 44,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Weather & city guide',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: const Color(0xFF9FB4DD),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              bool isLoading = controller.isLoading.value;
              bool isOffline =
                  controller.errorMsg.value != null &&
                  controller.errorMsg.value == 'No Internet!';
              return Column(
                children: [
                  Text(
                    isLoading || !isOffline
                        ? 'Checking your session…'
                        : isOffline
                        ? 'No Internet!'
                        : 'Welcome!',
                    style: GoogleFonts.dmMono(
                      fontSize: 13,
                      color: const Color(0xFF9FB4DD),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  isLoading
                      ? const SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const SizedBox.shrink(),
                  isOffline
                      ? InkWell(
                          onTap: controller.checkForUser,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'RETRY',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
