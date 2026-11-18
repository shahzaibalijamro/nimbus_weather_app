import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/models/favorites_model.dart';
import 'package:untitled/models/city_model.dart' as city_model;

class FavoritesController extends GetxController {
  ApiController apiController = Get.find<ApiController>();
  RxList<Favorite> favorites = <Favorite>[].obs;
  RxList<city_model.City> availableCities = <city_model.City>[].obs;
  RxBool isOffline = false.obs;
  RxnString errorMsg = RxnString();
  RxnString availableCitiesError = RxnString();
  RxBool isUpdatingFavorites = false.obs;
  RxBool isSessionExpired = false.obs;
  RxBool isFavoritesLoading = false.obs;
  RxBool isLoadingAvailableCities = false.obs;
  int _availableCitiesPage = 1;
  bool _hasMoreAvailableCities = true;
  int _availableCitiesRequestId = 0;
  bool get hasMoreAvailableCities => _hasMoreAvailableCities;

  Future<void> fetchAvailableCities({
    bool refresh = false,
    String? query,
  }) async {
    if (refresh) {
      _availableCitiesRequestId++;
      _availableCitiesPage = 1;
      _hasMoreAvailableCities = true;
      availableCities.clear();
      availableCitiesError.value = null;
    } else if (isLoadingAvailableCities.value || !_hasMoreAvailableCities) {
      return;
    }

    final requestId = _availableCitiesRequestId;
    isLoadingAvailableCities.value = true;
    final response = await apiController.get(
      url: ApiEndpoints.cities,
      params: {
        'limit': '8',
        'page': _availableCitiesPage.toString(),
        if (query != null && query.isNotEmpty) 'search': query,
      },
    );

    if (requestId != _availableCitiesRequestId) return;

    final statusCode = response.statusCode;
    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      final cities = city_model.Cities.fromJson(jsonDecode(response.body!));
      availableCities.addAll(cities.data);
      _availableCitiesPage++;
      _hasMoreAvailableCities = cities.meta.hasNext;
      availableCitiesError.value = null;
    } else {
      availableCitiesError.value =
          response.message ?? 'Unable to load cities. Please try again.';
    }
    isLoadingAvailableCities.value = false;
  }

  Future<void> fetchFavorites() async {
    if (isFavoritesLoading.value) return;
    isFavoritesLoading.value = true;
    isOffline.value = false;
    errorMsg.value = null;

    final response = await apiController.get(
      url: ApiEndpoints.favorites,
      requiresToken: true,
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? responseBody = response.body;
    if (statusCode != null && statusCode == 200) {
      favorites.value = Favorites.fromJson(jsonDecode(responseBody!)).data;
      isOffline.value = false;
      errorMsg.value = null;
    } else if (statusCode != null && statusCode == 401) {
      isSessionExpired.value = true;
      Get.find<MainController>().updateSessionExpiration(isExpired: true);
    } else if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
      errorMsg.value = 'No Internet!';
    } else {
      errorMsg.value = message ?? 'Server Error';
    }
    isFavoritesLoading.value = false;
  }

  Future<bool> addToFavorite(String cityId, String note) async {
    if (isUpdatingFavorites.value) return false;
    isUpdatingFavorites.value = true;
    final response = await apiController.post(
      url: ApiEndpoints.favorites,
      body: {'cityId': cityId, 'note': note},
      isSecured: true,
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? body = response.body;
    if (statusCode != null && statusCode == 201) {
      favorites.add(Favorite.fromJson(jsonDecode(body!)['data']));
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 401) {
      isSessionExpired.value = true;
      Get.find<MainController>().updateSessionExpiration(isExpired: true);
    }
    if (statusCode != null && statusCode == 409) {
      Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.errorBg,
        borderRadius: 12,
        messageText: Text(
          'Already added To Favorites!',
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
    if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    isUpdatingFavorites.value = false;
    return statusCode == 201;
  }

  Future<bool> updateFavoriteNote(String favoriteId, String note) async {
    if (isUpdatingFavorites.value) return false;
    isUpdatingFavorites.value = true;
    final response = await apiController.patch(
      url: '${ApiEndpoints.favorites}/$favoriteId',
      body: {'note': note},
      isSecured: true,
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? body = response.body;
    if (statusCode != null && statusCode == 200) {
      final index = favorites.indexWhere(
        (favorite) => favorite.id.toString() == favoriteId,
      );

      if (index != -1) {
        favorites[index] = Favorite.fromJson(jsonDecode(body!)['data']);
      }
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 401) {
      isSessionExpired.value = true;
      Get.find<MainController>().updateSessionExpiration(isExpired: true);
    }
    if (statusCode != null && statusCode == 404) {
      Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.errorBg,
        borderRadius: 12,
        messageText: Text(
          'Favorite not found!',
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
    if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    isUpdatingFavorites.value = false;
    return statusCode == 200;
  }

  Future<void> removeFromFavorite(String favoriteId) async {
    if (isUpdatingFavorites.value) return;
    isUpdatingFavorites.value = true;
    final response = await apiController.delete(
      url: '${ApiEndpoints.favorites}/$favoriteId',
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    if (statusCode != null && statusCode == 204) {
      favorites.removeWhere((e) => e.id.toString() == favoriteId);
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 401) {
      isSessionExpired.value = true;
      Get.find<MainController>().updateSessionExpiration(isExpired: true);
    }
    if (statusCode != null && statusCode == 404) {
      Get.rawSnackbar(
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.errorBg,
        borderRadius: 12,
        messageText: Text(
          'Already removed from Favorites!',
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
    if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    isUpdatingFavorites.value = false;
  }
}
