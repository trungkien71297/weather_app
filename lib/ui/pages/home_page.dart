import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/models/current_weather.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/utils/constants.dart';

class HomePage extends StatelessWidget {
  static const route = "/home_page";
  HomePage({super.key});
  final controller = Get.put(HomeContronller());
  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0), child: _buildSearchField()),
          Expanded(
              child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLocation(controller.location.value),
                Text(
                  controller.weather.value.condition?.text ?? "",
                  style: subTitle,
                ),
                _buildImage(controller.weather.value),
                _buildTemp(controller.weather.value),
                _buildInfoExtra(controller.weather.value)
              ],
            ),
          ))
        ],
      ),
      persistentFooterButtons: [
        Row(
          children: [
            IconButton(
                onPressed: () => controller.refreshData(),
                icon: const Icon(Icons.replay_outlined)),
            Expanded(
                child: Center(
                    child: Obx(() =>
                        Text(controller.location.value.localTime ?? "")))),
            const Text("ºC"),
            Obx(() => Switch(
                value: controller.isFahrenheit.value,
                onChanged: (bool value) {
                  controller.isFahrenheit.value = value;
                })),
            const Text("ºF")
          ],
        )
      ],
    );
  }

  Widget _buildSearchField() {
    return RawAutocomplete<Location>(
      focusNode: _focusNode,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              TextField(
        controller: controller.searchController,
        textInputAction: TextInputAction.done,
        focusNode: focusNode,
        decoration: const InputDecoration(
            labelText: "Enter City name or Zip code",
            border: OutlineInputBorder()),
      ),
      displayStringForOption: (option) => option.name ?? "",
      textEditingController: controller.searchController,
      optionsViewBuilder: (context, onSelected, options) => ListView(children: [
        ...options
            .map((e) => GestureDetector(
                  onTap: () => onSelected(e),
                  child: Material(
                    elevation: 2.0,
                    child: ListTile(
                      title: Text("${e.name ?? ""}, ${e.country}"),
                    ),
                  ),
                ))
            .toList()
      ]),
      optionsBuilder: (textEditingValue) async {
        if (textEditingValue.text.trim().isNotEmpty) {
          return await controller.search(textEditingValue.text.trim());
        } else {
          return [];
        }
      },
      onSelected: (Location location) {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.searchController.text = location.name ?? "";
        controller.getWeather(location);
      },
    );
  }

  Widget _buildLocation(Location location) {
    final city = location.name ?? "";
    final country = location.country != null ? ", ${location.country}" : "";
    return Text(
      city + country,
      style: header,
    );
  }

  Widget _buildImage(CurrentWeather weather) {
    var isDay = weather.isDay == 1 ? "day" : "night";
    var icon = controller.conditions
        .where((element) => element.code == weather.condition?.code);
    var asset =
        "assets/images/$isDay/${icon.firstOrNull?.icon ?? 'default'}.png";
    return Image.asset(
      asset,
      fit: BoxFit.contain,
      width: 100,
      height: 100,
    );
  }

  Widget _buildTemp(CurrentWeather weather) {
    var c = weather.tempC != null ? weather.tempC!.round().toString() : "0";
    var f = weather.tempF != null ? weather.tempF!.round().toString() : "0";
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              controller.isFahrenheit.value ? "ºF" : "ºC",
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              controller.isFahrenheit.value ? f : c,
              style: const TextStyle(fontSize: 70),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoExtra(CurrentWeather weather) {
    return Expanded(
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Feels like",
                                style: titleinfo,
                              ),
                              Text(
                                  "${controller.isFahrenheit.value ? (weather.feelslikeF?.toString() ?? "0") : (weather.feelslikeC?.toString()) ?? "0"}º",
                                  style: infoStyle),
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Humidity",
                                style: titleinfo,
                              ),
                              Text(
                                  "${controller.weather.value.humidity?.toString() ?? "0"}%",
                                  style: infoStyle),
                            ],
                          ),
                        ),
                      ))
                ],
              )),
          Flexible(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "UV",
                                style: titleinfo,
                              ),
                              Text(
                                  controller.weather.value.uv?.toString() ??
                                      "0",
                                  style: infoStyle),
                            ],
                          ),
                        ),
                      )),
                  Flexible(
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Wind",
                                style: titleinfo,
                              ),
                              Text(
                                "${controller.weather.value.windKph?.toString() ?? "0"} Km/h",
                                style: infoStyle,
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
