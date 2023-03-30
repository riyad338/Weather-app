import 'package:flutter/material.dart';
import 'package:weather_app/pages/settings.dart';
import 'package:weather_app/pages/weather_home.dart';
import 'package:weather_app/weather_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => WeatherProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WeatherHome.routeName,
      routes: {
        WeatherHome.routeName: (context) => WeatherHome(),
        SettingsPage.routeName: (context) => SettingsPage(),
      },
    );
  }
}
