import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/views/unauthenticated_screen.dart';

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
          child: SkeletonizerConfig(
            data: SkeletonizerConfigData(
              effectResolver: (_) => ShimmerEffect(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                duration: const Duration(seconds: 1),
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                vertical: 30,
                horizontal: 16,
              ),
              child: controller.isSessionExpired.value
                  ? const UnauthenticatedScreen()
                  : controller.screens[controller.screenIndex.value],
            ),
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
