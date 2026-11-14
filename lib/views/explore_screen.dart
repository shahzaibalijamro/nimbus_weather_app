import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/controllers/explore_controller.dart';
import 'package:untitled/widgets/app_bar.dart';
import 'package:untitled/widgets/explore/error_section.dart';
import 'package:untitled/widgets/explore/weather_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ExploreController controller = Get.put(ExploreController());
  final TextEditingController searchInputController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  final scrollThreshold = 50;
  Timer? searchQueryDebounce;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    searchQueryDebounce?.cancel();
    searchInputController.dispose();
    focusNode.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        color: AppColors.blue,
        backgroundColor: AppColors.backgroundColor,
        onRefresh: () async {
          await Future.wait([
            controller.fetchRegions(),
            controller.fetchCities(refresh: true),
          ]);
          if (controller.isOffline.value || controller.errorMsg.value != null) {
            Get.rawSnackbar(
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
              backgroundColor: AppColors.errorBg,
              borderRadius: 12,
              messageText: Text(
                'Something went wrong!',
                style: GoogleFonts.dmSans(
                  color: AppColors.errorText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              barBlur: 50,
              margin: const EdgeInsets.all(12),
            );
          }
          Get.rawSnackbar(
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.blue,
            borderRadius: 12,
            messageText: Text(
              'Explore data refreshed successfully!',
              style: GoogleFonts.dmSans(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            barBlur: 50,
            margin: const EdgeInsets.all(12),
          );
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
              MyAppBar(),
              TextField(
                focusNode: focusNode,
                controller: searchInputController,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryText,
                ),
                onTapOutside: (event) {
                  focusNode.unfocus();
                },
                onChanged: (value) {
                  searchQueryDebounce?.cancel();
                  searchQueryDebounce = Timer(
                    const Duration(seconds: 2),
                    () => controller.fetchCities(refresh: true, query: value),
                  );
                },
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
                      color: AppColors.blue,
                      width: 1.5,
                    ),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(PhosphorIconsBold.magnifyingGlass, size: 20),
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
                    padding: EdgeInsets.zero,
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
                    ErrorSection();
                  }
                  final cities = controller.cities;

                  final isLastBatch = controller.isLast.value;
                  int itemCount = isLoading
                      ? 5
                      : cities.length + (!isLastBatch ? 1 : 0);
                  if (isLoading || cities.isNotEmpty) {
                    return ListView.separated(
                      padding: EdgeInsets.zero,
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
                  }
                  bool isSearchViaQuery =
                      searchInputController.text.trim() != '';
                  bool isSearchViaRegion =
                      controller.selectedRegion.value.name != 'All';
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
                            color: AppColors.rainBg,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Image.asset(
                            AppIcons.search,
                            height: 44,
                            width: 44,
                          ),
                        ),
                        Text(
                          'No cities found',
                          style: GoogleFonts.sora(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          isSearchViaQuery
                              ? 'Nothing matches “${searchInputController.text}”. Try another name or clear your search.'
                              : isSearchViaRegion
                              ? 'There are no cities available in ${controller.selectedRegion.value.name} right now. Try selecting another region.'
                              : 'No cities are available right now. Please try again later.',
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
                            if (isSearchViaQuery) {
                              searchInputController.text = '';
                              controller.fetchCities(refresh: true);
                              return;
                            }
                            if (isSearchViaRegion) {
                              controller.switchRegion('All');
                              return;
                            }
                            controller.fetchCities(refresh: true);
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
                                Icon(
                                  isSearchViaQuery
                                      ? PhosphorIconsBold.x
                                      : isSearchViaRegion
                                      ? PhosphorIconsBold.arrowArcLeft
                                      : PhosphorIconsBold.arrowClockwise,
                                  color: AppColors.white,
                                  size: 18,
                                ),
                                Text(
                                  isSearchViaQuery
                                      ? 'Clear search'
                                      : isSearchViaRegion
                                      ? 'Switch Region'
                                      : 'Try again',
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
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
