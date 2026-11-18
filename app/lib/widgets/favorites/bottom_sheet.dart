import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/favorites_controller.dart';
import 'package:untitled/models/city_model.dart' as city_model;
import 'package:untitled/models/favorites_model.dart';

class FavoritesBottomSheet extends StatefulWidget {
  const FavoritesBottomSheet({super.key, this.favoriteCity});
  final Favorite? favoriteCity;

  void showBottomSheet({Favorite? favoriteCity}) {
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
  final TextEditingController searchController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final ScrollController citiesScrollController = ScrollController();
  final FavoritesController controller = Get.find<FavoritesController>();
  Timer? searchDebounce;
  city_model.City? selectedCity;
  String note = '';

  @override
  void initState() {
    super.initState();
    note = widget.favoriteCity?.note ?? '';
    noteController.text = note;
    if (widget.favoriteCity == null) {
      controller.fetchAvailableCities(refresh: true);
      citiesScrollController.addListener(_loadMoreCities);
    }
  }

  void _loadMoreCities() {
    if (!citiesScrollController.hasClients ||
        citiesScrollController.position.extentAfter > 100 ||
        controller.isLoadingAvailableCities.value ||
        controller.availableCitiesError.value != null) {
      return;
    }
    controller.fetchAvailableCities(query: searchController.text.trim());
  }

  @override
  void dispose() {
    searchDebounce?.cancel();
    focusNode.dispose();
    searchController.dispose();
    noteController.dispose();
    citiesScrollController.dispose();
    super.dispose();
  }

  Color _iconBackground(String icon) {
    return icon.contains('sun') ? AppColors.sunBg : AppColors.rainBg;
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.favoriteCity != null || selectedCity != null;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
      child: Container(
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 16),
            Row(
              children: [
                if (widget.favoriteCity == null && selectedCity != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedCity = null;
                        note = '';
                        noteController.clear();
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    icon: const Icon(
                      PhosphorIconsBold.arrowLeft,
                      color: AppColors.primaryText,
                      size: 20,
                    ),
                  ),
                Text(
                  widget.favoriteCity != null
                      ? 'Update Note'
                      : selected
                      ? 'Add to Favorites'
                      : 'Add a Favorite',
                  style: GoogleFonts.sora(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selected)
              Flexible(fit: FlexFit.loose, child: _buildSelectedCity())
            else
              Expanded(child: _buildCityPicker()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCityPicker() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onChanged: (value) {
            searchDebounce?.cancel();
            searchDebounce = Timer(const Duration(milliseconds: 400), () {
              controller.fetchAvailableCities(
                refresh: true,
                query: value.trim(),
              );
            });
          },
          style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.primaryText),
          decoration: InputDecoration(
            prefixIcon: const Icon(PhosphorIconsBold.magnifyingGlass, size: 20),
            hintText: 'Search cities or countries',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.mutedText,
            ),
            filled: true,
            fillColor: AppColors.backgroundColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() {
            final favoritesIds = controller.favorites
                .map((favorite) => favorite.city.id)
                .toSet();
            final cities = controller.availableCities
                .where((city) => !favoritesIds.contains(city.id))
                .toList();
            final isLoading = controller.isLoadingAvailableCities.value;
            final error = controller.availableCitiesError.value;

            if (!isLoading &&
                error == null &&
                controller.hasMoreAvailableCities) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted &&
                    (!citiesScrollController.hasClients ||
                        citiesScrollController.position.maxScrollExtent <=
                            100)) {
                  controller.fetchAvailableCities(
                    query: searchController.text.trim(),
                  );
                }
              });
            }

            if (cities.isEmpty && isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              );
            }
            if (cities.isEmpty && error != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.fetchAvailableCities(
                        refresh: true,
                        query: searchController.text.trim(),
                      ),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            if (cities.isEmpty) {
              return Center(
                child: Text(
                  'No available cities found.',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.secondaryText,
                  ),
                ),
              );
            }

            return ListView.separated(
              controller: citiesScrollController,
              itemCount: cities.length + (isLoading || error != null ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index >= cities.length) {
                  if (error != null && !isLoading) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            error,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          TextButton(
                            onPressed: () => controller.fetchAvailableCities(
                              query: searchController.text.trim(),
                            ),
                            child: const Text('Try again'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.blue),
                    ),
                  );
                }
                final city = cities[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      selectedCity = city;
                      note = '';
                      noteController.clear();
                    });
                  },
                  child: _cityCard(
                    name: city.name,
                    country: city.country,
                    icon: city.weather.condition.icon,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSelectedCity() {
    final favorite = widget.favoriteCity;
    final city = selectedCity;
    final name = favorite?.city.name ?? city!.name;
    final country = favorite?.city.country ?? city!.country;
    final icon =
        favorite?.city.weather.condition.icon ?? city!.weather.condition.icon;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cityCard(name: name, country: country, icon: icon),
          const SizedBox(height: 18),
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
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            key: ValueKey(favorite?.id ?? city?.id),
            controller: noteController,
            maxLength: 120,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 2,
            focusNode: focusNode,
            onChanged: (value) => setState(() => note = value),
            onTapOutside: (_) => focusNode.unfocus(),
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: AppColors.primaryText,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Add note',
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.secondaryText),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.blue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: _saveFavorite,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Obx(() {
                final isSaving = controller.isUpdatingFavorites.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      favorite == null
                          ? PhosphorIconsBold.plus
                          : PhosphorIconsBold.pencilSimple,
                      size: 18,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isSaving
                          ? 'Saving'
                          : favorite == null
                          ? 'Add to Favorites'
                          : 'Update Note',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cityCard({
    required String name,
    required String country,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.backgroundColor,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _iconBackground(icon),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset('assets/icons/$icon.png', height: 24, width: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  country,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (widget.favoriteCity == null && selectedCity == null)
            const Icon(
              PhosphorIconsBold.caretRight,
              color: AppColors.secondaryText,
              size: 16,
            ),
        ],
      ),
    );
  }

  Future<void> _saveFavorite() async {
    final favorite = widget.favoriteCity;
    final success = favorite != null
        ? await controller.updateFavoriteNote(favorite.id.toString(), note)
        : await controller.addToFavorite(selectedCity!.id, note);
    if (success && mounted) Get.back();
  }
}
