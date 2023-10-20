import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:weather_app/models/current_location.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/exception.dart';

class BaseApi {
  Dio dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5)));
}

class Api extends BaseApi {
  Future<Either<Exception, List<Location>>> search(String q) async {
    const url = "search.json";
    try {
      Response response =
          await dio.get(url, queryParameters: {"key": API_KEY, "q": q});
      if (response.statusCode == 200) {
        return Right(
            (response.data as List).map((e) => Location.fromJson(e)).toList());
      } else {
        return Left(
            CustomException(response.statusMessage ?? "Can not retrive data"));
      }
    } catch (e) {
      return Left(CustomException("Unknown error, please try again"));
    }
  }

  Future<Either<Exception, CurrentLocation>> getCurrentWeather(
      Location location) async {
    const url = "current.json";
    try {
      Response response = await dio.get(url, queryParameters: {
        "key": API_KEY,
        "q": "${location.lat},${location.lon}"
      });
      if (response.statusCode == 200) {
        return Right(CurrentLocation.fromJson(response.data));
      } else {
        return Left(
            CustomException(response.statusMessage ?? "Can not retrive data"));
      }
    } catch (e) {
      return Left(CustomException("Unknown error, please try again"));
    }
  }
}
