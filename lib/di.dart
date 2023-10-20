import 'package:get_it/get_it.dart';
import 'package:weather_app/api/api.dart';

final getIt = GetIt.instance;
void setUp() {
  getIt.registerSingleton(Api());
}
