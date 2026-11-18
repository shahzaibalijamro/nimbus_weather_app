import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/controllers/favorites_controller.dart';
import 'package:untitled/models/favorites_model.dart';

Future<bool?> showFavoriteDialog(Favorite favoriteCity) {
  final FavoritesController controller = Get.find<FavoritesController>();
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
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Image.asset(AppIcons.trash, height: 30, width: 30),
              ),
              Text(
                'Remove ${favoriteCity.city.name}?',
                style: GoogleFonts.sora(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.primaryText,
                ),
              ),
              if (favoriteCity.note.trim().isNotEmpty) ...[
                Text(
                  'This deletes “${favoriteCity.note}” from your favorites.',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              InkWell(
                onTap: () async {
                  await controller.removeFromFavorite(
                    favoriteCity.id.toString(),
                  );
                  Get.back();
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
                    bool isLoading = controller.isUpdatingFavorites.value;
                    return Text(
                      isLoading ? 'Deleting' : 'Delete',
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
              InkWell(
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
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
    useSafeArea: true,
  );
}
