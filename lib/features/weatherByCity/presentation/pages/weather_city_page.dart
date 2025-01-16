import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/app_theme.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../widgets/city_weather.dart';
import '../widgets/search_box.dart';
import '../widgets/switch_temp.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.rainGradient,
          ),
        ),
        child: BlocProvider(
          create: (context) => WeatherBloc(),
          child: BlocListener<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherNoInternetState) {
                _showToastMessage(context, "No internet connection");
              } else if (state is WeatherLocationPermissionState) {
                _showToastMessage(context, state.locationMessage);
              } else if (state is WeatherErrorState) {
                _showToastMessage(context, state.errorMsg);
              }
            },
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Spacer(),
                  WeatherSwitchTemp(),
                  Spacer(),
                  CitySearchBox(),
                  Spacer(),
                  CurrentWeather(),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showToastMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        content: Text(msg),
      ),
    );
  }
}
