import '../../data/model/weather/weather_data.dart';

abstract class WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherNoInternetState extends WeatherState {}

class WeatherErrorState extends WeatherState {
  final String errorMsg;
  WeatherErrorState({required this.errorMsg});
}

class WeatherLocationPermissionState extends WeatherState {
  final String locationMessage;
  WeatherLocationPermissionState({required this.locationMessage});
}

class WeatherSwitchtempState extends WeatherState {
  final bool isCelsius;
  WeatherSwitchtempState(this.isCelsius);
}

class WeatherCityState extends WeatherState {
  final WeatherData? weatherData;
  final String city;
  WeatherCityState(this.weatherData, this.city);
}
