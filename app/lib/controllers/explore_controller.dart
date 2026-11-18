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
  RxInt page = 1.obs;
  RxBool isLast = false.obs;

  @override
  void onInit() {
    super.onInit(); // Always call super.onInit() first
    fetchRegions();
    fetchCities();
  }

  Future<void> fetchRegions() async {
    isLoadingRegions.value = true;
    isOffline.value = false;

    final response = await apiController.get(url: ApiEndpoints.regions);
    int? statusCode = response.statusCode;
    String? body = response.body;
    String? message = response.message;
    if (statusCode != null && statusCode == 200) {
      regions.value = [
        Region(name: 'All', count: 0),
        ...Regions.fromJson(jsonDecode(body!)).data,
      ];
      errorMsg.value = null;
    } else {
      errorMsg.value = message;
      isOffline.value = statusCode != null && statusCode == 700;
    }
    isLoadingRegions.value = false;
  }

  void switchRegion(String name) {
    selectedRegion.value = regions.firstWhere(
      (element) => element.name == name,
    );
    fetchCities(refresh: true);
  }

  Future<void> fetchCities({bool refresh = false, String? query}) async {
    isOffline.value = false;
    if (refresh) {
      page.value = 1;
      cities.clear();
      isLast.value = false;
    }
    if (isLoadingCities.value || isLast.value) return;
    isLoadingCities.value = true;
    final response = await apiController.get(
      url: ApiEndpoints.cities,
      params: getParams(query),
    );
    int? statusCode = response.statusCode;
    String? body = response.body;
    String? message = response.message;
    if (statusCode != null && (statusCode == 200 || statusCode == 201)) {
      final data = Cities.fromJson(jsonDecode(body!));
      cities.value = [...cities, ...data.data];
      numberOfResults.value = data.meta.total;
      page++;
      isLast.value = !data.meta.hasNext;
      errorMsg.value = null;
    } else {
      errorMsg.value = message;
      isOffline.value = statusCode != null && statusCode == 700;
    }
    isLoadingCities.value = false;
  }

  Map<String, String> getParams(String? query) {
    Map<String, String> params = {'limit': '8', 'page': page.value.toString()};
    if (query != null) params.addAll({'search': query});
    if (selectedRegion.value.name != 'All') {
      params.addAll({'region': selectedRegion.value.name});
    }

    return params;
  }
}
