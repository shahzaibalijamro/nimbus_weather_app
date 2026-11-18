import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/controllers/favorites_controller.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/widgets/favorites/bottom_sheet.dart';
import 'package:untitled/widgets/favorites/favorites_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesController controller = Get.put(FavoritesController());

  @override
  void initState() {
    super.initState();
    controller.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.blue,
      backgroundColor: AppColors.backgroundColor,
      onRefresh: () async {
        await controller.fetchFavorites();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
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
                InkWell(
                  onTap: () => const FavoritesBottomSheet().showBottomSheet(),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
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
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Main Content Area
            Obx(() {
              final isLoading = controller.isFavoritesLoading.value;
              final isError = controller.errorMsg.value != null;
              final isOffline = controller.isOffline.value;
              final favorites = controller.favorites;

              // 1. Error / Offline State (mirrors Explore screen)
              if ((isError || isOffline) && favorites.isEmpty && !isLoading) {
                return Padding(
                  padding: const EdgeInsets.only(top: 48, left: 8, right: 8),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        const SizedBox(height: 16),
                        Text(
                          isOffline ? "You're offline" : 'Can’t load favorites',
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isOffline
                              ? 'Check your internet connection and tap retry.'
                              : 'Unable to reach the server. Please try again.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.errorBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOffline ? 'error.code: OFFLINE  ·  700' : 'error.code: SERVER_ERROR  ·  500',
                            style: GoogleFonts.dmMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.errorText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () => controller.fetchFavorites(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  PhosphorIconsBold.arrowClockwise,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
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
                  ),
                );
              }

              // 2. Empty State (when user has no favorites yet)
              if (!isLoading && favorites.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 48, left: 8, right: 8),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 96,
                          width: 96,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.rainBg,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            PhosphorIconsBold.heartStraight,
                            color: AppColors.blue,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You haven’t added any favorite cities yet. Discover new destinations in Explore and tap the heart icon to save them here.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.rainBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FAVORITES_EMPTY  ·  0 saved',
                            style: GoogleFonts.dmMono(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (Get.isRegistered<MainController>()) {
                                  Get.find<MainController>().switchScreens(0); // switch to Explore
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      PhosphorIconsBold.compass,
                                      color: AppColors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Explore cities',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 15,
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
                      ],
                    ),
                  ),
                );
              }

              // 3. Favorites List
              int itemCount = isLoading ? 3 : favorites.length;
              return Column(
                children: [
                  for (int i = 0; i < itemCount; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: FavoriteTile(
                        isLoading: isLoading,
                        favorite: isLoading ? null : favorites[i],
                      ),
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
