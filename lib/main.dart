import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app1/controller/theme_controller.dart';
import 'package:weather_app1/screen/help_screen.dart';

void main() {
  runApp(MyApp());
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






