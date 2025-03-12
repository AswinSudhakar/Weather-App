import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/models/model1.dart';
import 'package:weather_app/secrets/api.dart';
import 'package:http/http.dart' as htttp;

//https://api.openweathermap.org/data/2.5/weather?q=kannur&appid=acd282864699df2d24c4ef331f45bd01&units=metric
class WeatherserviceProvider extends ChangeNotifier {
  WeatherModel? _weather;
  WeatherModel? get weather => _weather;

  bool _isloading = false;
  bool get isloading => _isloading;

  String _error = "";
  String get error => _error;

  Future<void> fetchWeatherDataByCity(String city) async {
    _isloading = true;
    _error = "";

    try {
      final apiUrl =
          "${APIEndPoints().CityUrl}${city}&appid=${APIEndPoints().apikey}${APIEndPoints().unit}";
      print(apiUrl);

      final response = await htttp.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        _weather = WeatherModel.fromJson(data);
        print(_weather);
        notifyListeners();
      } else {
        _error = "Failed to load data";
      }
    } catch (e) {
      _error = "an error Occured :$e";
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
