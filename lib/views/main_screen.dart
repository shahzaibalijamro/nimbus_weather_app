import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/controllers/main_controller.dart';

import '../constants/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainController controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsetsGeometry.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 16,
            ),
            child: controller.isSessionExpired.value
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        const Spacer(),
                        Container(
                          height: 96,
                          width: 96,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.sunBg,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(
                            AppIcons.lock,
                            height: 44,
                            width: 44,
                          ),
                        ),
                        Text(
                          'Session expired',
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Your token is older than 2 hours. Log in again to keep your favorites.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.sunBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '401  ·  TOKEN_EXPIRED',
                            style: GoogleFonts.dmMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB54708),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.login);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                const Icon(
                                  PhosphorIconsBold.lock,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                                Text(
                                  'Log in again',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                : controller.screens[controller.screenIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.screenIndex.value,
          backgroundColor: AppColors.white,
          onTap: (value) {
            controller.switchScreens(value);
          },
          selectedLabelStyle: GoogleFonts.dmSans(
            color: AppColors.blue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
          selectedItemColor: AppColors.blue,
          unselectedLabelStyle: GoogleFonts.dmSans(
            color: AppColors.mutedText,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedItemColor: AppColors.mutedText,
          items: controller.navItems.map((e) {
            final icon = e['icon'];
            final label = e['label'];
            return BottomNavigationBarItem(icon: icon, label: label);
          }).toList(),
        ),
      ),
    );
  }
}
