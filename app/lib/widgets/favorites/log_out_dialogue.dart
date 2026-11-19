import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/auth_controller.dart';

Future<bool?> showLogOutDialog() {
  final AuthController controller = Get.find<AuthController>();
  return Get.dialog<bool>(
    Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Material(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Log out',
                style: GoogleFonts.sora(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.primaryText,
                ),
              ),
              Text(
                'Are you sure you want to log out of your Nimbus account?',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(result: false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: BoxBorder.all(color: AppColors.mutedText),
                        ),
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await controller.logout();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorText,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Obx(() {
                          bool isLoading = controller.isLoading.value;
                          return Text(
                            isLoading ? 'Logging out' : 'Log out',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
    useSafeArea: true,
  );
}
