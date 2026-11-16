import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/constants/icons.dart';
import 'package:untitled/controllers/favorites_controller.dart';
import 'package:untitled/models/favorites_model.dart';

class FavoritesBottomSheet extends StatefulWidget {
  const FavoritesBottomSheet({super.key, this.favoriteCity});
  final Favorite? favoriteCity;

  void showBottomSheet(Favorite favoriteCity) {
    Get.bottomSheet(
      FavoritesBottomSheet(favoriteCity: favoriteCity),
      backgroundColor: AppColors.white,
      isScrollControlled: true,
    );
  }

  @override
  State<FavoritesBottomSheet> createState() => _FavoritesBottomSheetState();
}

class _FavoritesBottomSheetState extends State<FavoritesBottomSheet> {
  final FocusNode focusNode = FocusNode();
  String note = '';
  String? errorMsg;
  final FavoritesController controller = Get.find<FavoritesController>();

  Color iconBg(String iconLabel) {
    print(iconLabel);
    if (iconLabel.contains('sun')) {
      return AppColors.sunBg;
    } else {
      return AppColors.rainBg;
    }
  }

  @override
  void initState() {
    super.initState();
    note = widget.favoriteCity!.note;
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dragHandleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Update Note',
            style: GoogleFonts.sora(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.backgroundColor,
            ),
            child: Row(
              spacing: 12,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBg(
                      widget.favoriteCity!.city.weather.condition.icon,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset(
                    'assets/icons/${widget.favoriteCity!.city.weather.condition.icon}.png',
                    height: 24,
                    width: 24,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        widget.favoriteCity!.city.name,
                        style: GoogleFonts.sora(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Text(
                        widget.favoriteCity!.city.country,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Note (optional)',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Text(
                    '${note.length}/120',
                    style: GoogleFonts.dmMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              TextFormField(
                maxLength: 120,
                initialValue: note,
                onChanged: (value) {
                  if (value.length > 120) {
                    setState(() {
                      errorMsg = 'Exceeded the character limit';
                    });
                    return;
                  } else {
                    if (errorMsg != null &&
                        errorMsg == 'Exceeded the character limit') {
                      setState(() {
                        errorMsg = null;
                      });
                    }
                  }
                  setState(() {
                    note = value;
                  });
                },
                focusNode: focusNode,
                onTapOutside: (event) => focusNode.unfocus(),
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: AppColors.primaryText,
                ),
                cursorHeight: 15,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.secondaryText,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.blue, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppColors.errorText,
                      width: 1,
                    ),
                  ),
                  hint: Text(
                    'Add note',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ),

              if (errorMsg != null) ...[
                Text(
                  errorMsg!,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.errorText,
                  ),
                ),
              ],
            ],
          ),
          InkWell(
            onTap: () async {
              await controller.updateFavoriteNote(
                widget.favoriteCity!.id.toString(),
                note,
              );
              Get.back();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Icon(
                    PhosphorIconsBold.pencilSimple,
                    size: 18,
                    color: AppColors.white,
                  ),
                  Obx(() {
                    bool isUpdating = controller.isUpdatingFavorites.value;
                    return !isUpdating
                        ? Text(
                            'Update Note',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            'Updating',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.white,
                            ),
                          );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
