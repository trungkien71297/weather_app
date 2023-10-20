import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:weather_app/di.dart';
import 'package:weather_app/ui/pages/home_page.dart';

void main() {
  setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: HomePage.route,
      getPages: [GetPage(name: HomePage.route, page: () => HomePage())],
    );
  }
}
