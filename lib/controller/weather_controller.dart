import 'dart:convert';

import 'package:get/get.dart';

class WeatherController extends GetxController {
  var location = "".obs;
  var temperature = "".obs;
  var weatherText = "".obs;
  var weatherIcon = "".obs;
  var isloading = false.obs;

  Future<void> fetchWeather(String query, dynamic http) async {
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