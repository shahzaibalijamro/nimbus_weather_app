import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils extends GetxController {
  SharedPreferences? prefs;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print('PREFS INITIALIZED!');
  }

  @override
  void onInit() {
    super.onInit();
  }

  String? getStringFromPrefs({required String key}) {
    return prefs!.getString(key);
  }

  int? getIntFromPrefs({required String key}) {
    return prefs!.getInt(key);
  }

  bool? getBoolFromPrefs({required String key}) {
    return prefs!.getBool(key);
  }

  Future<bool> storeBoolInPrefs({
    required String key,
    required bool value,
  }) async {
    return (await prefs!.setBool(key, value));
  }

  Future<bool> storeStringInPrefs({
    required String key,
    required String value,
  }) async {
    return await prefs!.setString(key, value);
  }

  Future<bool> storeStringListInPrefs({
    required String key,
    required List<String> value,
  }) async {
    return await prefs!.setStringList(key, value);
  }

  Future<bool> storeIntInPrefs({
    required String key,
    required int value,
  }) async {
    return (await prefs!.setInt(key, value));
  }
}
