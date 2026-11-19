import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/settings_controller.dart';
import 'package:untitled/models/favorites_model.dart';
import 'package:untitled/widgets/favorites/bottom_sheet.dart';
import 'package:untitled/widgets/favorites/favorite_dialog.dart';

class FavoriteTile extends StatelessWidget {
  const FavoriteTile({super.key, required this.isLoading, this.favorite});

  final bool isLoading;
  final Favorite? favorite;

  Color iconBg(String iconLabel) {
    if (iconLabel.contains('sun')) {
      return AppColors.sunBg;
    } else {
      return AppColors.rainBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              offset: Offset(0, 6),
              spreadRadius: 0,
              blurRadius: 18,
            ),
          ],
        ),
        child: Row(
          spacing: 12,
          children: [
            isLoading && favorite == null
                ? Bone.square(size: 52, borderRadius: BorderRadius.circular(16))
                : Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: iconBg(favorite!.city.weather.condition.icon),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/${favorite!.city.weather.condition.icon}.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  isLoading
                      ? const Bone.text(words: 2)
                      : Row(
                          children: [
                            Flexible(
                              child: Text(
                                favorite!.city.name,
                                style: GoogleFonts.sora(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Obx(() {
                              final settings = Get.find<SettingsController>();
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  settings.formatTempOnly(
                                    favorite!.city.weather.temperatureC,
                                  ),
                                  style: GoogleFonts.sora(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blue,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                  isLoading
                      ? const Bone.text(words: 2)
                      : Row(
                          spacing: 5,
                          children: [
                            const Icon(
                              PhosphorIconsBold.pencilSimpleLine,
                              size: 12,
                              color: AppColors.secondaryText,
                            ),
                            Expanded(
                              child: Text(
                                favorite!.note.trim() == ''
                                    ? '"No note"'
                                    : '"${favorite!.note}"',
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
            isLoading
                ? const Bone.square(size: 36)
                : InkWell(
                    onTap: () => const FavoritesBottomSheet().showBottomSheet(
                      favoriteCity: favorite!,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.rainBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        PhosphorIconsBold.pencilSimple,
                        color: AppColors.blue,
                        size: 16,
                      ),
                    ),
                  ),
            isLoading
                ? const Bone.square(size: 36)
                : InkWell(
                    onTap: () => showFavoriteDialog(favorite!),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.errorBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        PhosphorIconsBold.trashSimple,
                        color: AppColors.errorText,
                        size: 16,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
