import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';
//JSON parse model
@freezed
class Weather with _$Weather {
  factory Weather({
    @JsonKey(name: 'cloud_pct') required double cloud_pct,
    @JsonKey(name: 'temp') required double temp,
    @JsonKey(name: 'feels_like') required double feels_like,
    @JsonKey(name: 'humidity') required double humidity,
    @JsonKey(name: 'min_temp') required double min_temp,
    @JsonKey(name: 'max_temp') required double max_temp,
    @JsonKey(name: 'wind_speed') required double wind_speed,
    @JsonKey(name: 'wind_degrees') required double wind_degrees,
    @JsonKey(name: 'sunrise') required double sunrise,
    @JsonKey(name: 'sunset') required double sunset,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}
