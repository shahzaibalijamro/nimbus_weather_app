import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/constants/colors.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/controllers/main_controller.dart';
import 'package:untitled/models/city_detailed/city_detailed_model.dart';
import 'package:untitled/models/city_detailed/city_forecast_model.dart';
import 'package:untitled/models/city_detailed/city_places.dart';
import 'package:untitled/models/city_detailed/city_weather_model.dart';
import 'package:untitled/models/favorites_model.dart';

class CityController extends GetxController {
  ApiController apiController = Get.find<ApiController>();
  Rxn<CityWeather> cityWeather = Rxn();
  RxBool cityWeatherLoading = false.obs;
  Rxn<CityDetail> cityDetail = Rxn();
  RxBool cityDetailLoading = false.obs;
  Rxn<CityForecast> cityforecast = Rxn();
  RxBool cityforecastLoading = false.obs;
  Rxn<CityPlaces> cityPlaces = Rxn();
  RxBool cityPlacesLoading = false.obs;
  RxBool notFound = false.obs;
  RxBool isOffline = false.obs;
  RxnString errorMsg = RxnString();
  RxBool isUpdatingFavorites = false.obs;
  RxBool isSessionExpired = false.obs;
  RxBool isFavoritesLoading = false.obs;
  Rx<IsFavorite> isFavorite = IsFavorite(value: false).obs;

  Future<void> fetchCityWeather(String cityId) async {
    if (cityWeatherLoading.value) return;
    cityWeatherLoading.value = true;
    final response = await apiController.get(
      url: '${ApiEndpoints.cities}/$cityId/weather',
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? responseBody = response.body;
    if (statusCode != null && statusCode == 200) {
      cityWeather.value = CityWeather.fromJson(jsonDecode(responseBody!));
      notFound.value = false;
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 404) {
      notFound.value = true;
    }
    if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    cityWeatherLoading.value = false;
  }

  Future<void> fetchFavorites(String cityId) async {
    if (isFavoritesLoading.value) return;
    isFavoritesLoading.value = true;
    final response = await apiController.get(
      url: ApiEndpoints.favorites,
      requiresToken: true,
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? responseBody = response.body;
    if (statusCode != null && statusCode == 200) {
      final favorites = Favorites.fromJson(jsonDecode(responseBody!));
      for (var favorite in favorites.data) {
        if (favorite.city.id == cityId) {
          isFavorite.value = IsFavorite(value: true, id: favorite.id);
          break;
        } else {
          isFavorite.value = IsFavorite(value: false);
        }
      }
      notFound.value = false;
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 401) {
      isSessionExpired.value = true;
      Get.find<MainController>().updateSessionExpiration(isExpired: true);
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    isFavoritesLoading.value = false;
  }

  Future<void> fetchCityDetail(String cityId) async {
    if (cityDetailLoading.value) return;
    cityDetailLoading.value = true;
    final response = await apiController.get(
      url: '${ApiEndpoints.cities}/$cityId',
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? responseBody = response.body;
    if (statusCode != null && statusCode == 200) {
      cityDetail.value = CityDetail.fromJson(jsonDecode(responseBody!));
      notFound.value = false;
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 404) {
      notFound.value = true;
    }
    if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    cityDetailLoading.value = false;
  }

  Future<void> fetchCityForecast(String cityId) async {
    if (cityforecastLoading.value) return;
    cityforecastLoading.value = true;
    final response = await apiController.get(
      url: '${ApiEndpoints.cities}/$cityId/forecast',
      params: {'days': '5'},
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? responseBody = response.body;
    if (statusCode != null && statusCode == 200) {
      cityforecast.value = CityForecast.fromJson(jsonDecode(responseBody!));
      notFound.value = false;
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 404) {
      notFound.value = true;
    }
    if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    cityforecastLoading.value = false;
  }

  Future<void> fetchCityPlaces(String cityId) async {
    if (cityPlacesLoading.value) return;
    cityPlacesLoading.value = true;
    final response = await apiController.get(
      url: '${ApiEndpoints.cities}/$cityId/places',
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? responseBody = response.body;
    if (statusCode != null && statusCode == 200) {
      cityPlaces.value = CityPlaces.fromJson(jsonDecode(responseBody!));
      notFound.value = false;
      isOffline.value = false;
      errorMsg.value = null;
    }
    if (statusCode != null && statusCode == 404) {
      notFound.value = true;
    }
    if (statusCode != null && statusCode == 700) {
      isOffline.value = true;
    }
    if (statusCode == null) {
      errorMsg.value = message;
    }
    cityPlacesLoading.value = false;
  }

  Future<void> toggleFavorite(String cityId) async {
    if (isUpdatingFavorites.value) return;
    isUpdatingFavorites.value = true;
    if (isFavorite.value.value) {
      await removeFromFavorite('${isFavorite.value.id!}');
    } else {
      await addToFavorite(cityId);
    }
    isUpdatingFavorites.value = false;
  }

  Future<void> addToFavorite(String cityId) async {
    final response = await apiController.post(
      url: ApiEndpoints.favorites,
      body: {'cityId': cityId},
      isSecured: true,
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    final String? body = response.body;
    if (statusCode != null && statusCode == 201) {
      isFavorite.value = IsFavorite(
        value: true,
        id: jsonDecode(body!)['data']['id'],
      );
      notFound.value = false;
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
  }

  Future<void> removeFromFavorite(String favoriteId) async {
    final response = await apiController.delete(
      url: '${ApiEndpoints.favorites}/$favoriteId',
    );
    final int? statusCode = response.statusCode;
    final String? message = response.message;
    if (statusCode != null && statusCode == 204) {
      isFavorite.value = IsFavorite(value: false);
      notFound.value = false;
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
  }
}
