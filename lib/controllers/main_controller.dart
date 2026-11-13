import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../views/explore_screen.dart';
import '../views/favorites_screen.dart';
import '../views/profile_screen.dart';

class MainController extends GetxController {
  RxInt screenIndex = 0.obs;
  List<Widget> screens = [
    const ExploreScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];
  RxBool isSessionExpired = false.obs;

  List<Map<String, dynamic>> navItems = [
    {'icon': const Icon(PhosphorIconsBold.compass), 'label': 'Explore'},
    {'icon': const Icon(PhosphorIconsBold.heart), 'label': 'Favorites'},
    {'icon': const Icon(PhosphorIconsBold.user), 'label': 'Profile'},
  ];

  void switchScreens(int index) {
    screenIndex.value = index;
  }

  void updateSessionExpiration({required bool isExpired}) {
    isSessionExpired.value = isExpired;
  }
}
