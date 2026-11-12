import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/models/city_model.dart';

class WeatherTile extends StatelessWidget {
  const WeatherTile({super.key, required this.isLoading, this.city});

  final bool isLoading;
  final City? city;

  Color iconBg(String iconLabel) {
    print(iconLabel);
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
        ),
        child: Row(
          spacing: 14,
          children: [
            isLoading && city == null
                ? Bone.square(size: 52, borderRadius: BorderRadius.circular(16))
                : Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: iconBg(city!.weather.condition.icon),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/${city!.weather.condition.icon}.png',
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
                      : Text(
                          city!.name,
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryText,
                          ),
                        ),
                  isLoading
                      ? const Bone.text(words: 2)
                      : Text(
                          city!.country,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.secondaryText,
                          ),
                        ),
                ],
              ),
            ),
            isLoading
                ? const Bone.text(words: 1)
                : Text(
                    '${city!.weather.temperatureC.toInt()}°',
                    style: GoogleFonts.sora(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
