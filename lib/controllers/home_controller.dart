import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/api/api.dart';
import 'package:weather_app/di.dart';
import 'package:weather_app/models/condition.dart' as wt_cond;
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/location.dart';

class HomeContronller extends GetxController {
  TextEditingController searchController = TextEditingController();
  Rx<Location> location = Location().obs;
  Rx<CurrentWeather> weather = CurrentWeather().obs;
  Location? lastLocation;
  List<wt_cond.Condition> conditions = [];
  RxBool isFahrenheit = true.obs;
  @override
  onInit() {
    super.onInit();
    _preLoad();
  }

  _preLoad() async {
    final res = await rootBundle.loadString('assets/weather_conditions.json');
    final data = await json.decode(res);
    conditions =
        (data as List).map((e) => wt_cond.Condition.fromJson(e)).toList();
    final prefs = await SharedPreferences.getInstance();
    isFahrenheit.value = prefs.getBool("isFahrenheit") == true;
  }

  Future<List<Location>> search(String query) async {
    var res = await getIt<Api>().search(searchController.text);
    return res.fold((l) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar("Error", l.toString(), backgroundColor: Colors.red);
      }
      return [];
    }, (r) => r);
  }

  getWeather(Location lct) async {
    lastLocation = lct;
    var res = await getIt<Api>().getCurrentWeather(lct);
    return res.fold((l) {
      if (!Get.isSnackbarOpen) {
        Get.snackbar("Error", l.toString(), backgroundColor: Colors.red);
      }
    }, (r) {
      if (r.location != null && r.current != null) {
        location.value = r.location!;
        weather.value = r.current!;
      }
    });
  }

  Future<void> refreshData() async {
    if (lastLocation != null) {
      await getWeather(lastLocation!);
    }
  }

  changeTemp(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    isFahrenheit.value = value;
    prefs.setBool("isFahrenheit", value);
  }
}
