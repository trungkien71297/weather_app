import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/location.dart';

class CurrentLocation {
  Location? location;
  CurrentWeather? current;
  CurrentLocation({this.location, this.current});
  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      current: json['current'] != null
          ? CurrentWeather.fromJson(json['current'])
          : null,
    );
  }
}
