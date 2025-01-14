import 'package:hive/hive.dart';

import '../temperature.dart';
part 'weather_hive_data.g.dart';

@HiveType(typeId: 0)
class WeatherHiveData extends HiveObject {
  WeatherHiveData({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.feelsLike,
  });
  @HiveField(0)
  double? temp;
  @HiveField(1)
  double? minTemp;
  @HiveField(2)
  double? maxTemp;
  @HiveField(3)
  double? feelsLike;
  @HiveField(4)
  double? humidity;
}
