import 'dart:convert';

import 'package:get/get.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/models/city_detailed/city_detailed_model.dart';
import 'package:untitled/models/city_detailed/city_forecast_model.dart';
import 'package:untitled/models/city_detailed/city_places.dart';
import 'package:untitled/models/city_detailed/city_weather_model.dart';

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

  void fetchCityWeather(String cityId) async {
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

  void fetchCityDetail(String cityId) async {
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

  void fetchCityForecast(String cityId) async {
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

  void fetchCityPlaces(String cityId) async {
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
}
