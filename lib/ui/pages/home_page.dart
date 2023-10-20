import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controllers/home_controller.dart';
import 'package:weather_app/models/location.dart';

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
              padding: const EdgeInsets.all(10.0), child: _buildSearchField())
        ],
      ),
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
            labelText: "City name or zip code", border: OutlineInputBorder()),
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
                      title: Text(e.name ?? ""),
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
        controller.searchController.text = location.name ?? "";
        controller.getWeather(location);
      },
    );
  }
}
