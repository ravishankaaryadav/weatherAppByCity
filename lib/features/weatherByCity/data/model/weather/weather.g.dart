// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Weather _$$_WeatherFromJson(Map<String, dynamic> json) => _$_Weather(
      cloud_pct: (json['cloud_pct'] as num).toDouble(),
      temp: (json['temp'] as num).toDouble(),
      feels_like: (json['feels_like'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      min_temp: (json['min_temp'] as num).toDouble(),
      max_temp: (json['max_temp'] as num).toDouble(),
      wind_speed: (json['wind_speed'] as num).toDouble(),
      wind_degrees: (json['wind_degrees'] as num).toDouble(),
      sunrise: (json['sunrise'] as num).toDouble(),
      sunset: (json['sunset'] as num).toDouble(),
    );

Map<String, dynamic> _$$_WeatherToJson(_$_Weather instance) =>
    <String, dynamic>{
      'cloud_pct': instance.cloud_pct,
      'temp': instance.temp,
      'feels_like': instance.feels_like,
      'humidity': instance.humidity,
      'min_temp': instance.min_temp,
      'max_temp': instance.max_temp,
      'wind_speed': instance.wind_speed,
      'wind_degrees': instance.wind_degrees,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
    };
