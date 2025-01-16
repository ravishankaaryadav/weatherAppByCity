// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_hive_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherHiveDataAdapter extends TypeAdapter<WeatherHiveData> {
  @override
  final int typeId = 0;

  @override
  WeatherHiveData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherHiveData(
      temp: fields[0] as double?,
      minTemp: fields[1] as double?,
      maxTemp: fields[2] as double?,
      humidity: fields[4] as double?,
      feelsLike: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherHiveData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.temp)
      ..writeByte(1)
      ..write(obj.minTemp)
      ..writeByte(2)
      ..write(obj.maxTemp)
      ..writeByte(3)
      ..write(obj.feelsLike)
      ..writeByte(4)
      ..write(obj.humidity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherHiveDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
