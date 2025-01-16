import 'package:geocoding/geocoding.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/model/weather/weather_data.dart';
import '../../data/model/weather/weather_hive_data.dart';
import '../entity/temperature.dart';
import '../repos/weather_repository.dart';

class WeatherCityUsecases {
  final WeatherRepository _weatherRepoImplementation;
  WeatherCityUsecases(this._weatherRepoImplementation);

  Future<WeatherData?> weatherCity(
      {required String city, required bool isInternetConnected}) async {
    List<Location>? locations = [];

    //If No internet
    if (isInternetConnected == false) {
      WeatherHiveData? weatherHiveData = await fetchRecordsFromDb(city: city);
      return WeatherData(
        temp: Temperature.celsius(weatherHiveData?.temp ?? 0),
        minTemp: Temperature.celsius(weatherHiveData?.minTemp ?? 0),
        maxTemp: Temperature.celsius(weatherHiveData?.maxTemp ?? 0),
        humidity: Temperature.celsius(weatherHiveData?.humidity ?? 0),
        feelsLike: Temperature.celsius(weatherHiveData?.feelsLike ?? 0),
      );
    }

    locations = await getLatLong(city) ?? locations;
    if (locations.isEmpty) {
      return null;
    }
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;

    WeatherData? weatherData = await _weatherRepoImplementation.weatherCity(
        lat: latitude.toString(), lon: longitude.toString());
    storeInLocalDb(city, weatherData);
    return weatherData;
  }

  Future<WeatherHiveData?> fetchRecordsFromDb({required String city}) async {
    await Hive.openBox<WeatherHiveData>('weatherdb');
    WeatherHiveData? weatherHiveData = await _checkLocalDbHaveCityRecords(city);
    return weatherHiveData;
  }

  //Convert City name into lat and long.
  Future<List<Location>?> getLatLong(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      return locations;
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  Future<void> storeInLocalDb(
      //Store records in locale hive db.
      String city,
      WeatherData? weatherResponse) async {
    if (weatherResponse == null) {
      return;
    }
    await Hive.openBox<WeatherHiveData>('weatherdb');
    Box<WeatherHiveData> weatherdbBox = Hive.box<WeatherHiveData>('weatherdb');
    var catModel = WeatherHiveData(
        feelsLike: weatherResponse.feelsLike?.celsius,
        humidity: weatherResponse.humidity?.celsius,
        maxTemp: weatherResponse.maxTemp?.celsius,
        minTemp: weatherResponse.minTemp?.celsius,
        temp: weatherResponse.temp?.celsius); //creating object
    await weatherdbBox.put(city, catModel); //putting object into hive box
  }

  Future<WeatherHiveData?> _checkLocalDbHaveCityRecords(String city) async {
    await Hive.openBox<WeatherHiveData>('weatherdb');
    Box<WeatherHiveData> weatherdbBox = Hive.box<WeatherHiveData>('weatherdb');
    WeatherHiveData? weatherHiveData = weatherdbBox.get(city); //get by key
    return weatherHiveData;
  }
}
