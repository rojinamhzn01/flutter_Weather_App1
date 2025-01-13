import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Weather App",
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
          home: Helpscreen(),
        ));
  }
}

class Helpscreen extends StatefulWidget {
  const Helpscreen({super.key});

  @override
  State<Helpscreen> createState() => _HelpscreenState();
}

class _HelpscreenState extends State<Helpscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 5),
      () {
        Get.off(() => HomeScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "We show weather for you",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.off(() => HomeScreen());
              },
              child: Text("Skip"),
            ),
          ],
        ),
      ),
    );
  }
}

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
                weatherController.fetchWeather(weatherController.location.value);
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

class WeatherController extends GetxController {
  var location = "".obs;
  var temperature = "".obs;
  var weatherText = "".obs;
  var weatherIcon = "".obs;
  var isloading = false.obs;

  Future<void> fetchWeather(String query) async {
    if (query.isEmpty) {
      Get.snackbar("Error", "Location cannot be empty");
      return;
    }

    try {
      isloading.value = true;
      // Replace with your actual WeatherAPI endpoint and API key
      var url = Uri.parse(
          "http://api.weatherapi.com/v1/current.json?key=d19b8d1653a34c5f800123433251101&q=$query");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        temperature.value = "${data["current"]["temp_c"]}°C";
        weatherText.value = data["current"]["condition"]["text"];
        weatherIcon.value = "https:${data["current"]["condition"]["icon"]}";
      } else {
        Get.snackbar('Error', 'Unable to fetch weather for $query');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isloading.value = false;
    }
  }
}
