import '../../../domain/entity/temperature.dart';
import 'weather.dart';

// Derived model class used in the UI
class WeatherData {
  WeatherData({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.humidity,
  });
  final Temperature? temp;
  final Temperature? minTemp;
  final Temperature? maxTemp;
  final Temperature? feelsLike;
  final Temperature? humidity;

  factory WeatherData.from(
    Weather weather,
  ) {
    return WeatherData(
      temp: Temperature.celsius(weather.temp),
      minTemp: Temperature.celsius(weather.min_temp),
      maxTemp: Temperature.celsius(weather.max_temp),
      feelsLike: Temperature.celsius(weather.feels_like),
      humidity: Temperature.celsius(weather.humidity),
    );
  }
}
