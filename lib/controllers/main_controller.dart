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

  List<Map<String, dynamic>> navItems = [
    {'icon': Icon(PhosphorIconsBold.compass), 'label': 'Explore'},
    {'icon': Icon(PhosphorIconsBold.heart), 'label': 'Favorites'},
    {'icon': Icon(PhosphorIconsBold.user), 'label': 'Profile'},
  ];

  void switchScreens(int index) {
    screenIndex.value = index;
  }
}
