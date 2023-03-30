import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/models/current_response.dart';
import 'package:weather_app/models/forcast_response.dart';

class WeatherProvider extends ChangeNotifier {
  double latitude = 0.0;
  double longitude = 0.0;
  CurrentResponse? currentResponse;
  ForcastResponse? forcastResponse;
  void setNewLatLng(double lat, double lng) {
    latitude = lat;
    longitude = lng;

    _getData();
  }

  void _getData() {
    _getCurrentData();
    _getForcastData();
  }

  bool get hasDataLoaded => currentResponse != null && forcastResponse != null;
  _getCurrentData() async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$weatherApiKey";

    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        currentResponse = CurrentResponse.fromJson(map);

        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  _getForcastData() async {
    final url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$weatherApiKey";

    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        final map = json.decode(response.body);
        forcastResponse = ForcastResponse.fromJson(map);
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
