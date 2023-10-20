import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/api/api.dart';
import 'package:weather_app/di.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/location.dart';

class HomeContronller extends GetxController {
  TextEditingController searchController = TextEditingController();
  Rx<Location> location = Location().obs;
  Rx<CurrentWeather> weather = CurrentWeather().obs;

  Future<List<Location>> search(String query) async {
    var res = await getIt<Api>().search(searchController.text);
    return res.fold((l) {
      Get.snackbar("Error", l.toString(), backgroundColor: Colors.red);
      return [];
    }, (r) => r);
  }

  getWeather(Location lct) async {
    var res = await getIt<Api>().getCurrentWeather(lct);
    return res.fold(
        (l) => Get.snackbar("Error", l.toString(), backgroundColor: Colors.red),
        (r) {
      if (r.location != null && r.current != null) {
        location.value = r.location!;
        weather.value = r.current!;
      }
    });
  }
}
