import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/model/weather/weather_data.dart';
import '../../data/repos/weather_repo_implementation.dart';
import '../../domain/entity/temperature.dart';

import '../../domain/usecases/weather_city_usecases.dart';
import 'weather_state.dart';

class WeatherBloc extends Cubit<WeatherState> {
  late WeatherCityUsecases _weatherCityUsecases;

  WeatherBloc() : super(WeatherInitialState()) {
    _weatherCityUsecases = WeatherCityUsecases(WeatherRepoImplementation());
    Connectivity().onConnectivityChanged.listen(internetStatusHandler);
    _getCurrentLocationWeather();
  }
  bool isLoading = false;
  bool isCelsius = true;
  bool isInternetConnected = false;

  internetStatusHandler(ConnectivityResult result) {
    if (ConnectivityResult.none == result) {
      emit(WeatherNoInternetState()); //Notify no internet state.
      isInternetConnected = false;
    } else if (ConnectivityResult.mobile == result ||
        ConnectivityResult.wifi == result) {
      isInternetConnected = true;
      _getCurrentLocationWeather();
    }
  }

  //Validate all scenarios before making an API call.
  Future<void> getWeatherofCity({required String city}) async {
    if (city.isEmpty) {
      emit(WeatherErrorState(errorMsg: 'Please enter city name'));
      return;
    }
    emit(WeatherLoadingState());
    isLoading = true;
    await _getWeatherDataFromAPI(city);
  }

  //This method calls the HTTP request, parses the response, and returns the actual readable data.
  Future<void> _getWeatherDataFromAPI(String city) async {
    try {
      final WeatherData? weatherResponse = await _weatherCityUsecases
          .weatherCity(city: city, isInternetConnected: isInternetConnected);
      isLoading = false;
      if (weatherResponse == null) {
        emit(WeatherErrorState(errorMsg: "No records"));
      }
      emit(WeatherCityState(weatherResponse, city));
    } on Exception catch (e) {
      emit(WeatherErrorState(errorMsg: e.toString()));
    }
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
    emit(WeatherLoadingState());
    await _getWeatherDataFromAPI(city);
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
