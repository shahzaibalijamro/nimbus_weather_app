import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/favorites_controller.dart';
import 'package:untitled/widgets/favorites/favorites_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoritesController controller = Get.put(FavoritesController());

  @override
  void initState() {
    super.initState();
    controller.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          spacing: 14,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorites',
                        style: GoogleFonts.sora(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          color: AppColors.primaryText,
                          height: 1.3,
                        ),
                      ),
                      Obx(() {
                        bool isLoading = controller.isFavoritesLoading.value;
                        int favorites = controller.favorites.length;
                        return Skeletonizer(
                          enabled: isLoading,
                          child: isLoading
                              ? const Bone.text(words: 2)
                              : Text(
                                  '$favorites saved cities',
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    spacing: 6,
                    children: [
                      const Icon(
                        PhosphorIconsBold.plus,
                        size: 16,
                        color: AppColors.white,
                      ),
                      Text(
                        'Add',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // list
            Obx(() {
              bool isLoading = controller.isFavoritesLoading.value;
              final favorites = controller.favorites;
              int itemCount = isLoading ? 3 : favorites.length;
              return Column(
                spacing: 14,
                children: [
                  for (int i = 0; i < itemCount; i++)
                    FavoriteTile(
                      isLoading: isLoading,
                      favorite: isLoading ? null : favorites[i],
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
