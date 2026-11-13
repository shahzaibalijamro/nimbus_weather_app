import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/auth_controller.dart';

class MyAppBar extends StatelessWidget {
  MyAppBar({super.key});
  final AuthController controller = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.user.value == null) return const SizedBox.shrink();
      final name = controller.user.value!.name;
      String getInitials() {
        if (name.contains(' ')) {
          final splitted = name.toUpperCase().split(' ');
          return splitted[0][0] + splitted[1][0];
        }
        return name[0].toUpperCase();
      }

      return Row(
        children: [
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Evening',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
                Text(
                  name,
                  style: GoogleFonts.sora(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              getInitials(),
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      );
    });
  }
}
