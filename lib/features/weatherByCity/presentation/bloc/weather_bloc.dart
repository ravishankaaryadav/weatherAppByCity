import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../api/api_endpoint.dart';
import '../../data/weather_repo_implementation.dart';
import '../../domain/temperature.dart';
import '../../domain/weather/weather_data.dart';

import '../../domain/weather/weather_hive_data.dart';
import 'weather_state.dart';

class WeatherBloc extends Cubit<WeatherState> {
  late WeatherRepoImplementation weatherRepository;

  WeatherBloc() : super(WeatherInitialState()) {
    Hive.openBox<WeatherHiveData>('weatherdb');
    weatherRepository = WeatherRepoImplementation(
      api: OpenWeatherMapAPI(),
      client: http.Client(),
    );

    _checkStatusOfInternet();
    _getCurrentLocationWeather();
  }
  bool isLoading = false;
  bool isCelsius = true;
  bool isInternetConnected = false;

  void _checkStatusOfInternet() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (ConnectivityResult.none == result) {
        emit(WeatherNoInternetState()); //Notify no internet state.
        isInternetConnected = false;
      } else if (ConnectivityResult.mobile == result ||
          ConnectivityResult.wifi == result) {
        isInternetConnected = true;
        _getCurrentLocationWeather();
      }
    });
  }

//This method calls the HTTP request, parses the response, and returns the actual readable data.
  Future<void> getWeatherofCity({required String city}) async {
    List<Location>? locations = [];
    isLoading = true;
    //Could you validate all scenarios before making an API call? Yes.
    if (isInternetConnected == false) {
      ///Get Offline Data from local DB
      WeatherHiveData? weatherHiveData =
          _checkLocalDbHaveCityRecords(city); //get records by key
      if (weatherHiveData == null) {
        emit(WeatherErrorState(errorMsg: 'No internet connection'));
        return;
      }
      _featchRecordsFromDb(weatherHiveData, city);
      return;
    }

    if (city.isEmpty) {
      emit(WeatherErrorState(errorMsg: 'Please enter city name'));
      return;
    }
    emit(WeatherLoadingState());
    locations = await getLatLong(city) ?? locations;
    if (locations.isEmpty) {
      emit(WeatherErrorState(errorMsg: 'No city found'));
      return;
    }
    double latitude = locations[0].latitude;
    double longitude = locations[0].longitude;

    await _getWeatherDataFromAPI(latitude, longitude, city);
  }

  void _featchRecordsFromDb(WeatherHiveData weatherHiveData, String city) {
    isLoading = false;
    emit(WeatherCityState(
        WeatherData(
            feelsLike: Temperature.celsius(weatherHiveData.feelsLike ?? 0),
            humidity: Temperature.celsius(weatherHiveData.humidity ?? 0),
            maxTemp: Temperature.celsius(weatherHiveData.maxTemp ?? 0),
            minTemp: Temperature.celsius(weatherHiveData.minTemp ?? 0),
            temp: Temperature.celsius(weatherHiveData.temp ?? 0)),
        city));
  }

  Future<void> _getWeatherDataFromAPI(
      //Weather by city name API request.
      double latitude,
      double longitude,
      String city) async {
    try {
      final WeatherData? weatherResponse = await weatherRepository.weatherCity(
          lat: latitude.toString(), lon: longitude.toString());
      isLoading = false;
      await _storeInLocalDb(city, weatherResponse);
      emit(WeatherCityState(weatherResponse, city));
    } on Exception catch (e) {
      emit(WeatherErrorState(errorMsg: e.toString()));
    }
  }

  WeatherHiveData? _checkLocalDbHaveCityRecords(String city) {
    Box<WeatherHiveData> weatherdbBox = Hive.box<WeatherHiveData>('weatherdb');
    WeatherHiveData? weatherHiveData = weatherdbBox.get(city); //get by key
    return weatherHiveData;
  }

  Future<void> _storeInLocalDb(
      //Store records in locale hive db.
      String city,
      WeatherData? weatherResponse) async {
    Box<WeatherHiveData> weatherdbBox = Hive.box<WeatherHiveData>('weatherdb');
    var catModel = WeatherHiveData(
        feelsLike: weatherResponse?.feelsLike.celsius,
        humidity: weatherResponse?.humidity.celsius,
        maxTemp: weatherResponse?.maxTemp.celsius,
        minTemp: weatherResponse?.minTemp.celsius,
        temp: weatherResponse?.temp.celsius); //creating object
    await weatherdbBox.put(city, catModel); //putting object into hive box
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

//Switch toggle temp for C/F selection and emit state to update UI.
  void switchTempUnit() {
    isCelsius = !isCelsius;
    emit(WeatherSwitchtempState(isCelsius));
  }

//Convert temp unit based on C/F selection.
  String? switchTempData(Temperature? temp) {
    final tempData = isCelsius
        ? temp?.celsius.toInt().toString()
        : temp?.farhenheit.toInt().toString();
    return tempData;
  }

  Future<void> _getCurrentLocationWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(WeatherLocationPermissionState(
          locationMessage: "Location services are disabled."));
      return;
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(WeatherLocationPermissionState(
            locationMessage: "Location permissions are denied."));

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(WeatherLocationPermissionState(
          locationMessage: "Location permissions are permanently denied."));
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String city = await _getAddressFromLatLng(position);

    if (isInternetConnected == false) {
      //Get Offline Data from local DB
      WeatherHiveData? weatherHiveData =
          _checkLocalDbHaveCityRecords(city); //get records by key

      if (weatherHiveData == null) {
        return;
      }
      _featchRecordsFromDb(weatherHiveData, city.trim());
      return;
    }
    emit(WeatherLoadingState());
    await _getWeatherDataFromAPI(position.latitude, position.longitude, city);
  }

  Future<String> _getAddressFromLatLng(Position currentPosition) async {
    String currentAddress;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = placemarks[0];
      currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      return currentAddress;
    } catch (e) {
      return "";
    }
  }
}
