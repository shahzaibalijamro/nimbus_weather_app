import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/controllers/city_controller.dart';
import 'package:untitled/models/city_model.dart';

class DetailedCity extends StatefulWidget {
  const DetailedCity({super.key, required this.city});
  final City city;
  @override
  State<DetailedCity> createState() => _DetailedCityState();
}

class _DetailedCityState extends State<DetailedCity> {
  CityController controller = Get.put(CityController());

  @override
  void initState() {
    super.initState();
    fetchCityData();
  }

  Future<void> fetchCityData() async {
    await Future.wait([
      controller.fetchCityDetail(widget.city.id),
      controller.fetchCityForecast(widget.city.id),
      controller.fetchCityPlaces(widget.city.id),
      controller.fetchCityWeather(widget.city.id),
      controller.fetchFavorites(widget.city.id),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effectResolver: (_) => ShimmerEffect(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          duration: const Duration(seconds: 1),
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.blue,
            backgroundColor: AppColors.backgroundColor,
            onRefresh: fetchCityData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  vertical: 30,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          hoverColor: Colors.transparent,
                          onTap: Get.back,
                          child: Container(
                            padding: const EdgeInsets.all(11),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              PhosphorIconsBold.arrowLeft,
                              color: AppColors.primaryText,
                              size: 22,
                            ),
                          ),
                        ),
                        Obx(() {
                          bool isLoading = controller.isFavoritesLoading.value;
                          bool isFavorited = controller.isFavorite.value.value;
                          return Skeletonizer(
                            enabled: isLoading,
                            child: InkWell(
                              onTap: () {
                                if (isLoading) return;
                                controller.toggleFavorite(widget.city.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: !isFavorited
                                    ? const Icon(
                                        PhosphorIconsBold.heart,
                                        color: AppColors.errorText,
                                        size: 22,
                                      )
                                    : const Icon(
                                        PhosphorIconsFill.heart,
                                        color: AppColors.errorText,
                                        size: 22,
                                      ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Obx(() {
                      bool isOffline = controller.isOffline.value;
                      if (!isOffline) {
                        return const SizedBox.shrink();
                      } else {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.errorBg,
                            border: BoxBorder.all(
                              color: AppColors.errorText.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            spacing: 12,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.errorText.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  AppIcons.wifiOff,
                                  color: AppColors.errorText,
                                  height: 22,
                                  width: 22,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "You're offline",
                                      style: GoogleFonts.sora(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryText,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Showing partial data',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.secondaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: fetchCityData,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF5B8DFF),
                                        Color(0xFF1D4FD8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    spacing: 4,
                                    children: [
                                      Text(
                                        'Retry',
                                        style: GoogleFonts.sora(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Icon(
                                        PhosphorIconsBold.arrowsClockwise,
                                        color: AppColors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                    Obx(() {
                      bool isLoading = controller.cityWeatherLoading.value;
                      final weather = controller.cityWeather.value;
                      bool isOffline = controller.isOffline.value;

                      return Skeletonizer(
                        enabled: isLoading,

                        child: Column(
                          spacing: 14,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF5B8DFF),
                                    Color(0xFF1D4FD8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 6,
                                    children: [
                                      const Icon(
                                        PhosphorIconsBold.mapPin,
                                        color: Color(0xFFCFE0FF),
                                        size: 13,
                                      ),
                                      Text(
                                        '${widget.city.country} · ${widget.city.region}',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFCFE0FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.city.name,
                                    style: GoogleFonts.sora(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${widget.city.weather.temperatureC.toInt()}°',
                                        style: GoogleFonts.sora(
                                          fontSize: 64,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.white,
                                          height: 1.2,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/icons/${widget.city.weather.condition.icon}.png',
                                        height: 64,
                                        width: 64,
                                        color: AppColors.white,
                                      ),
                                    ],
                                  ),
                                  isLoading
                                      ? const Bone.text(words: 6)
                                      : Text(
                                          !isOffline
                                              ? '${weather!.data.condition.label} · Feels like ${weather.data.feelsLikeC.toInt()}°'
                                              : '--',
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.rainBg,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 18,
                                          spreadRadius: 0,
                                          offset: Offset(0, 6),
                                          color: AppColors.shadowColor,
                                        ),
                                      ],
                                    ),

                                    child: Column(
                                      spacing: 5,

                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppIcons.drop,
                                              width: 14,
                                              height: 14,
                                            ),
                                            Text(
                                              'Humidity',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        isLoading
                                            ? const Bone.text(words: 1)
                                            : Text(
                                                !isOffline
                                                    ? '${weather!.data.humidity.toInt()}%'
                                                    : '--%',
                                                style: GoogleFonts.sora(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: AppColors.primaryText,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 18,
                                          spreadRadius: 0,
                                          offset: Offset(0, 6),
                                          color: AppColors.shadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 5,

                                      children: [
                                        Row(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppIcons.wind,
                                              width: 14,
                                              height: 14,
                                            ),
                                            Text(
                                              'Wind',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        isLoading
                                            ? const Bone.text(words: 2)
                                            : Text(
                                                !isOffline
                                                    ? '${weather!.data.windKph.toInt()} km/h'
                                                    : '-- km/h',
                                                style: GoogleFonts.sora(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: AppColors.primaryText,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 18,
                                          spreadRadius: 0,
                                          offset: Offset(0, 6),
                                          color: AppColors.shadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 5,
                                      children: [
                                        Row(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppIcons.sunBlue,
                                              width: 14,
                                              height: 14,
                                            ),
                                            Text(
                                              'UV index',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        isLoading
                                            ? const Bone.text(words: 1)
                                            : Text(
                                                !isOffline
                                                    ? weather!.data.uvIndex
                                                          .toString()
                                                    : '--',
                                                style: GoogleFonts.sora(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: AppColors.primaryText,
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
                      );
                    }),
                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 18,
                            spreadRadius: 0,
                            offset: Offset(0, 6),
                            color: AppColors.shadowColor,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            '5-day forecast',
                            style: GoogleFonts.sora(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.primaryText,
                            ),
                          ),
                          Obx(() {
                            bool isLoading =
                                controller.cityforecastLoading.value;
                            final cityForecast = controller.cityforecast.value;
                            bool isOffline = controller.isOffline.value;
                            return Skeletonizer(
                              enabled: isLoading,
                              child: Row(
                                spacing: isLoading ? 10 : 0,
                                children: [
                                  for (int i = 0; i < 5; i++)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: 6,
                                        children: [
                                          isLoading
                                              ? const Bone.text(words: 1)
                                              : Text(
                                                  !isOffline
                                                      ? cityForecast!
                                                            .data[i]
                                                            .weekday
                                                      : '--',
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.secondaryText,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                          isLoading || isOffline
                                              ? Bone.square(
                                                  size: 24,

                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                )
                                              : Image.asset(
                                                  'assets/icons/${cityForecast!.data[i].condition.icon}.png',
                                                  height: 24,
                                                  width: 24,
                                                ),
                                          isLoading
                                              ? const Bone.text(words: 1)
                                              : Text(
                                                  !isOffline
                                                      ? '${cityForecast!.data[i].highC.toInt()}°'
                                                      : '--°',
                                                  style: GoogleFonts.sora(
                                                    fontSize: 14,
                                                    color:
                                                        AppColors.primaryText,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Things to do',
                      style: GoogleFonts.sora(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Obx(() {
                      bool isLoading = controller.cityPlacesLoading.value;
                      final cityPlaces = controller.cityPlaces.value;
                      bool isOffline = controller.isOffline.value;
                      final itemCount = isLoading || isOffline
                          ? 3
                          : cityPlaces!.data.length;
                      return Column(
                        children: [
                          for (var i = 0; i < itemCount; i++)
                            Skeletonizer(
                              enabled: isLoading,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  spacing: 12,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: AppColors.rainBg,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: isLoading || isOffline
                                          ? Bone.square(
                                              size: 18,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            )
                                          : Image.asset(
                                              cityPlaces!.data[i].type ==
                                                      'beach'
                                                  ? AppIcons.sunBlue
                                                  : AppIcons.landmark,
                                              height: 18,
                                              width: 18,
                                            ),
                                    ),
                                    Expanded(
                                      child: isLoading
                                          ? const Bone.text(words: 2)
                                          : Text(
                                              !isOffline
                                                  ? cityPlaces!.data[i].name
                                                  : '-- --',
                                              style: GoogleFonts.dmSans(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                    ),
                                    isLoading
                                        ? const Bone.text(words: 1)
                                        : Text(
                                            !isOffline
                                                ? cityPlaces!.data[i].type[0]
                                                          .toUpperCase() +
                                                      cityPlaces.data[i].type
                                                          .substring(1)
                                                : '-- --',
                                            style: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
