import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/models/user_model.dart';

import '../constants/colors.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainController controller = Get.put(MainController());
  ApiController apiController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 30),
            child: controller.screens[controller.screenIndex.value],
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
