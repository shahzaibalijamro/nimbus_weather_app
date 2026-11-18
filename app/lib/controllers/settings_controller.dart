import 'package:get/get.dart';
import 'package:untitled/utils/app_utils.dart';

class SettingsController extends GetxController {
  final AppUtils _utils = Get.find<AppUtils>();
  final RxBool isFahrenheit = false.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _utils.getBoolFromPrefs(key: 'isFahrenheit');
    if (saved != null) {
      isFahrenheit.value = saved;
    }
  }

  void setFahrenheit(bool value) {
    isFahrenheit.value = value;
    _utils.storeBoolInPrefs(key: 'isFahrenheit', value: value);
  }

  void toggleUnit() {
    setFahrenheit(!isFahrenheit.value);
  }

  String get unitLabel => isFahrenheit.value ? '°F' : '°C';
  String get unitName => isFahrenheit.value ? 'Fahrenheit (°F)' : 'Celsius (°C)';

  String formatTempOnly(num? tempC) {
    if (tempC == null) return '--';
    if (isFahrenheit.value) {
      final f = (tempC * 9 / 5) + 32;
      return '${f.round()}°';
    }
    return '${tempC.round()}°';
  }

  String formatTemp(num? tempC) {
    if (tempC == null) return '--';
    if (isFahrenheit.value) {
      final f = (tempC * 9 / 5) + 32;
      return '${f.round()}°F';
    }
    return '${tempC.round()}°C';
  }
}
