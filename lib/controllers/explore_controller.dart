import 'dart:convert';

import 'package:get/get.dart';
import 'package:untitled/constants/api.dart';
import 'package:untitled/controllers/api_controller.dart';
import 'package:untitled/models/city_model.dart';
import 'package:untitled/models/region_model.dart';

class ExploreController extends GetxController {
  ApiController apiController = Get.find<ApiController>();
  RxList<Region> regions = <Region>[].obs;
  RxList<City> cities = <City>[].obs;
  Rx<Region> selectedRegion = Region(name: 'All', count: 0).obs;
  RxBool isLoadingRegions = false.obs;
  RxBool isLoadingCities = false.obs;
  RxBool isOffline = false.obs;
  RxnString errorMsg = RxnString();
  RxnInt numberOfResults = RxnInt();

  @override
  void onInit() {
    super.onInit(); // Always call super.onInit() first
    fetchRegions();
    fetchCities();
  }

  Future<void> fetchRegions() async {
    isLoadingRegions.value = true;
    final response = await apiController.get(url: ApiEndpoints.regions);
    int? statusCode = response.statusCode;
    String? body = response.body;
    String? message = response.message;
    if (statusCode != null && statusCode == 200) {
      regions.value = [
        Region(name: 'All', count: 0),
        ...Regions.fromJson(jsonDecode(body!)).data,
      ];
    } else {
      errorMsg.value = message;
    }
    isLoadingRegions.value = false;
  }

  Future<void> fetchCities() async {
    isLoadingCities.value = true;
    final response = await apiController.get(url: ApiEndpoints.cities);
    int? statusCode = response.statusCode;
    String? body = response.body;
    String? message = response.message;
    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      final data = Cities.fromJson(jsonDecode(body!));
      cities.value = data.data;
      numberOfResults.value = data.meta.total;
    } else {
      errorMsg.value = message;
    }
    isLoadingCities.value = false;
  }
}
