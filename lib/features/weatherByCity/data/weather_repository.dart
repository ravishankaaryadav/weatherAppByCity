import '../domain/weather/weather_data.dart';

abstract class WeatherRepository {
  Future<WeatherData?> weatherCity({required String lat, required String lon});
}
