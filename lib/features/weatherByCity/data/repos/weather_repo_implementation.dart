import 'dart:convert';
import 'dart:io';

import 'package:flutter_weather_app/constants/constant.dart';

import '../../../../api/api_exception.dart';
import '../../../../api/weather_api_endpoint.dart';
import '../../domain/repos/weather_repository.dart';
import 'package:http/http.dart' as http;

import '../model/weather/weather.dart';
import '../model/weather/weather_data.dart';

/// Weather Repository using the http client. Calls API methods and parses responses.
class WeatherRepoImplementation extends WeatherRepository {
  WeatherRepoImplementation() {
    api = WeatherApiEndPoint();
    client = http.Client();
  }
  late WeatherApiEndPoint api;
  late http.Client client;

  @override
  Future<WeatherData?> weatherCity(
      {required String lat, required String lon}) async {
    final weather = await getWeather(lat: lat, lon: lon, endpoint: "weather");
    return WeatherData.from(weather);
  }

  Future<Weather> getWeather(
          {required String lat,
          required String lon,
          required String endpoint}) =>
      _getData(
        uri: api.weather(lat: lat, lon: lon, endpoint: endpoint),
        builder: (data) {
          return Weather.fromJson(data);
        },
      );

  Future<T> _getData<T>({
    required Uri uri,
    required T Function(dynamic data) builder,
  }) async {
    try {
      final response = await client.get(uri, headers: {
        'X-Api-Key': APIKeys.weatherAPIKey,
      });
      switch (response.statusCode) {
        case 200:
          final data = json.decode(response.body);
          return builder(data);
        case 401:
          throw InvalidApiKeyException();
        case 404:
          throw CityNotFoundException();
        default:
          throw UnknownException();
      }
    } on SocketException catch (_) {
      throw NoInternetConnectionException();
    }
  }
}
