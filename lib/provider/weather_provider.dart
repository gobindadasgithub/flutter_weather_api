
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/current_weather.dart';
import '../models/forecast_weather.dart';
import '../uilts/constraints.dart';
import 'package:http/http.dart' as Http;

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse? currentWeatherResponse;
  ForecastWeatherResponse? forecastWeatherResponse;
  double latitude = 0.0;
  double longitude = 0.0;
  String tempUnit = metric;
  String tempUnitSymbol = celsius;

  void setNewLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
  }

  bool get hasDataLoaded =>
      currentWeatherResponse != null && forecastWeatherResponse != null;

  void getData() {
    _getCurrentWeatherData();
    _getForecastWeatherData();
  }

  Future<void> _getCurrentWeatherData() async {
    final urlString =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$weatherApiKey';
    final response = await Http.get(Uri.parse(urlString));
    final map = json.decode(response.body);
    if (response.statusCode == 200) {
      currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
      notifyListeners();
    } else {
      print(map['message']);
    }
  }

  Future<void> _getForecastWeatherData() async {
    final urlString =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$weatherApiKey';
    final response = await Http.get(Uri.parse(urlString));
    final map = json.decode(response.body);
    if (response.statusCode == 200) {
      forecastWeatherResponse = ForecastWeatherResponse.fromJson(map);
      notifyListeners();
    } else {
      print(map['message']);
    }
  }
}
