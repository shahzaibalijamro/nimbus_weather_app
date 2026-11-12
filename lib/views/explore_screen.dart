import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/explore_controller.dart';
import 'package:untitled/widgets/explore/weather_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ExploreController controller = Get.put(ExploreController());
  final ScrollController scrollController = ScrollController();
  final scrollThreshold = 50;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;
      if (scrollController.position.extentAfter > scrollThreshold) return;
      controller.fetchCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.blue,
      backgroundColor: AppColors.backgroundColor,
      onRefresh: () async {
        controller.fetchRegions();
        controller.fetchCities(refresh: true);
      },
      child: SkeletonizerConfig(
        data: SkeletonizerConfigData(
          effectResolver: (_) => ShimmerEffect(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            duration: const Duration(seconds: 1),
          ),
        ),
        child: Column(
          spacing: 14,
          children: [
            Row(
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
                        'Demo Student',
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
                    'DS',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryText,
              ),
              cursorHeight: 15,
              cursorColor: AppColors.secondaryText,
              decoration: InputDecoration(
                hoverColor: Colors.transparent,
                filled: true,
                fillColor: AppColors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.borderGrey,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.borderGrey,
                    width: 1.5,
                  ),
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: const Icon(
                    PhosphorIconsBold.magnifyingGlass,
                    size: 20,
                  ),
                ),
                hint: Text(
                  'Search cities or countries…',
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 37,
              child: Obx(() {
                final isOffline = controller.isOffline.value;
                final isLoading = controller.isLoadingRegions.value;
                final regions = controller.regions;
                final selectedRegion = controller.selectedRegion.value.name;
                final regionNames = isOffline
                    ? List.filled(7, '————')
                    : isLoading
                    ? List.filled(7, 'Loading')
                    : regions.map((region) => region.name).toList();
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: regionNames.length,
                  itemBuilder: (context, index) {
                    bool isSelected =
                        !isLoading && regions[index].name == selectedRegion;
                    return InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () {
                        if (isOffline || isLoading) return;
                        controller.switchRegion(regions[index].name);
                      },
                      child: Skeletonizer(
                        enabled: isLoading,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.blue
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: !isSelected
                                ? BoxBorder.all(
                                    color: AppColors.borderGrey,
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              isLoading ? 'Loading' : regionNames[index],
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: !isSelected
                                    ? AppColors.secondaryText
                                    : AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cities',
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                Obx(() {
                  final cities = controller.cities;
                  bool isLoading =
                      controller.isLoadingCities.value && cities.isEmpty;
                  bool isOffline = controller.isOffline.value;

                  return Skeletonizer(
                    enabled: isLoading,
                    child: Text(
                      isOffline
                          ? '—'
                          : !isLoading
                          ? '${controller.numberOfResults.value} results'
                          : 'loading',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  );
                }),
              ],
            ),
            Expanded(
              child: Obx(() {
                bool isLoading =
                    controller.isLoadingCities.value &&
                    controller.cities.isEmpty;
                bool isError = controller.errorMsg.value != null;
                bool isOffline = controller.isOffline.value;
                if (isError || isOffline) {
                  return Padding(
                    padding: const EdgeInsetsGeometry.only(
                      top: 36,
                      left: 8,
                      right: 8,
                    ),
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
                          child: Image.asset(
                            'assets/icons/wifi-off.png',
                            height: 44,
                            width: 44,
                          ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
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
                final cities = controller.cities;
                final isLastBatch = controller.isLast.value;
                int itemCount = isLoading
                    ? 5
                    : cities.length + (!isLastBatch ? 1 : 0);
                return ListView.separated(
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    bool showLastShimmer =
                        !isLastBatch && index == itemCount - 1;
                    if (showLastShimmer) {
                      return const WeatherTile(isLoading: true, city: null);
                    }
                    return WeatherTile(
                      isLoading: isLoading,
                      city: isLoading ? null : cities[index],
                    );
                  },
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: itemCount,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
