import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/weather/weather_data.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';

class CurrentWeather extends StatefulWidget {
  const CurrentWeather({super.key});

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      buildWhen: (previous, current) {
        return current is WeatherCityState ||
            current is WeatherLoadingState ||
            current is WeatherErrorState;
      },
      builder: (context, state) {
        if (state is WeatherLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherCityState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(state.city,
                    style: Theme.of(context).textTheme.headlineMedium),
                CurrentWeatherContents(
                  weatherData: state.weatherData,
                )
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class CurrentWeatherContents extends StatelessWidget {
  final WeatherData? weatherData;

  const CurrentWeatherContents({super.key, this.weatherData});
  @override
  Widget build(BuildContext context) {
    final counterCubit = context.read<WeatherBloc>();
    return BlocBuilder<WeatherBloc, WeatherState>(
      buildWhen: (previous, current) {
        return current is WeatherSwitchtempState;
      },
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;
        final temp = counterCubit.switchTempData(weatherData?.temp);
        final minTemp = counterCubit.switchTempData(weatherData?.minTemp);
        final maxTemp = counterCubit.switchTempData(weatherData?.maxTemp);
        final highAndLow = 'H:$maxTemp° L:$minTemp°';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl:
                  "https://cdn.weatherapi.com/weather/64x64/day/113.png", //Just to show icon for better UI.
              width: 20,
              height: 20,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Text(temp ?? "", style: textTheme.displayMedium),
            Text(highAndLow, style: textTheme.bodyMedium),
          ],
        );
      },
    );
  }
}
