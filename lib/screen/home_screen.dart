import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app1/controller/theme_controller.dart';
import 'package:weather_app1/controller/weather_controller.dart';
import 'package:weather_app1/screen/help_screen.dart';

class HomeScreen extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            tooltip: "Help",
            onPressed: () {
              Get.to(() => Helpscreen());
            },
          ),
          Obx(
            () => IconButton(
              icon: Icon(themeController.isDarkMode.value
                  ? Icons.light_mode
                  : Icons.dark_mode),
              tooltip: "Toggle Theme",
              onPressed: themeController.toggleTheme,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                weatherController.location.value = value;
              },
              decoration: InputDecoration(
                labelText: "Enter Location",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                weatherController.fetchWeather(weatherController.location.value,"d19b8d1653a34c5f800123433251101");
              },
              child: Text("Search"),
            ),
            SizedBox(height: 20),
            Obx(
              () => weatherController.isloading.value
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        if (weatherController.temperature.isNotEmpty)
                          Text(
                            weatherController.temperature.value,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        if (weatherController.weatherText.isNotEmpty)
                          Text(weatherController.weatherText.value),
                        if (weatherController.weatherIcon.isNotEmpty)
                          Image.network(weatherController.weatherIcon.value),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}