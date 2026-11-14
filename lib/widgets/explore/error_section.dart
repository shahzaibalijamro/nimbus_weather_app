import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/controllers/explore_controller.dart';

class ErrorSection extends StatelessWidget {
  ErrorSection({super.key});
  final ExploreController controller = Get.find<ExploreController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.only(top: 36, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          Container(
            height: 96,
            width: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Image.asset(AppIcons.wifiOff, height: 44, width: 44),
          ),
          Text(
            'Can’t reach Nimbus',
            style: GoogleFonts.sora(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
              fontSize: 20,
            ),
          ),
          Text(
            'Check your connection or the server, then try again.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w400,
              color: AppColors.secondaryText,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'error.code: SERVER_ERROR  ·  500',
              style: GoogleFonts.dmMono(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.errorText,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              controller.fetchCities(refresh: true);
              controller.fetchRegions();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                    PhosphorIconsBold.arrowClockwise,
                    color: AppColors.white,
                    size: 18,
                  ),
                  Text(
                    'Try again',
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
        ],
      ),
    );
  }
}
