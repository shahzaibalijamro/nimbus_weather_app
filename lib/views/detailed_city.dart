import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/icons.dart';

class DetailedCity extends StatefulWidget {
  const DetailedCity({super.key, required this.cityName});
  final String cityName;
  @override
  State<DetailedCity> createState() => _DetailedCityState();
}

class _DetailedCityState extends State<DetailedCity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 30,
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 14,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
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
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        PhosphorIconsBold.heart,
                        color: AppColors.primaryText,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [Color(0xFF5B8DFF), Color(0xFF1D4FD8)],
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
                          'Pakistan · Asia',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFCFE0FF),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Karachi',
                      style: GoogleFonts.sora(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '28°',
                          style: GoogleFonts.sora(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                            height: 1.2,
                          ),
                        ),
                        Image.asset(
                          AppIcons.cloudSunWhite,
                          height: 64,
                          width: 64,
                        ),
                      ],
                    ),
                    Text(
                      'Partly cloudy · Feels like 29°',
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

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AppIcons.drop, width: 14, height: 14),
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
                          Text(
                            '64%',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,

                        children: [
                          Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(AppIcons.wind, width: 14, height: 14),
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
                          Text(
                            '14 km/h',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                          Text(
                            '6',
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 6,
                            children: [
                              Text(
                                'Tue',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Image.asset(AppIcons.sun, height: 24, width: 24),
                              Text(
                                '30°',
                                style: GoogleFonts.sora(
                                  fontSize: 14,
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 6,
                            children: [
                              Text(
                                'Tue',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Image.asset(AppIcons.sun, height: 24, width: 24),
                              Text(
                                '30°',
                                style: GoogleFonts.sora(
                                  fontSize: 14,
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 6,
                            children: [
                              Text(
                                'Tue',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Image.asset(AppIcons.sun, height: 24, width: 24),
                              Text(
                                '30°',
                                style: GoogleFonts.sora(
                                  fontSize: 14,
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 6,
                            children: [
                              Text(
                                'Tue',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Image.asset(AppIcons.sun, height: 24, width: 24),
                              Text(
                                '30°',
                                style: GoogleFonts.sora(
                                  fontSize: 14,
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 6,
                            children: [
                              Text(
                                'Tue',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Image.asset(AppIcons.sun, height: 24, width: 24),
                              Text(
                                '30°',
                                style: GoogleFonts.sora(
                                  fontSize: 14,
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                'Things to do',
                style: GoogleFonts.sora(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: AppColors.primaryText,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
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
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppColors.rainBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              AppIcons.sunBlue,
                              height: 18,
                              width: 18,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Clifton Beach',
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                          Text(
                            'Beach',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
