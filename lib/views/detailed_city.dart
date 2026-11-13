import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/constants/colors.dart';

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
          padding: EdgeInsetsGeometry.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            spacing: 14,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        PhosphorIconsBold.arrowLeft,
                        color: AppColors.primaryText,
                        size: 22,
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5B8DFF), Color(0xFF1D4FD8)],
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
                          'assets/icons/cloud-sun-white.png',
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
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        spacing: 5,

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/drop.png',
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
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
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
                                'assets/icons/wind.png',
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
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
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
                                'assets/icons/sun-blue.png',
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
            ],
          ),
        ),
      ),
    );
  }
}
