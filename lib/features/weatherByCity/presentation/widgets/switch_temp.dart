import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/application/app_theme.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import 'package:flutter_weather_app/application/text_style.dart';

class WeatherSwitchTemp extends StatelessWidget {
  static const double boxWidth = 62.0;
  static const double boxHeight = 40.0;

  const WeatherSwitchTemp({super.key});
  @override
  Widget build(BuildContext context) {
    final counterCubit = context.read<WeatherBloc>();

    return BlocBuilder<WeatherBloc, WeatherState>(
      buildWhen: (previous, current) {
        return current is WeatherSwitchtempState;
      },
      builder: (context, state) {
        return SizedBox(
          width: 135,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: counterCubit.isCelsius
                              ? const Offset(1.0, 0.0)
                              : const Offset(-1.0, 0.0),
                          end: const Offset(0.0, 0.0),
                        ).animate(animation),
                        child: child,
                      );
                    },
                    child: counterCubit.isCelsius
                        ? GestureDetector(
                            key: const ValueKey<int>(0),
                            child: Row(
                              children: [
                                Container(
                                  height: boxHeight,
                                  width: boxWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: counterCubit.isLoading
                                        ? Colors.grey
                                        : AppColors.rainBlueLight,
                                  ),
                                ),
                                Container(
                                  height: boxHeight,
                                  width: boxWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => counterCubit.isLoading
                                ? null
                                : counterCubit.switchTempUnit(),
                          )
                        : GestureDetector(
                            key: const ValueKey<int>(1),
                            child: Row(
                              children: [
                                Container(
                                  height: boxHeight,
                                  width: boxWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                Container(
                                  height: boxHeight,
                                  width: boxWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: counterCubit.isLoading
                                        ? Colors.grey
                                        : AppColors.rainBlueLight,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => counterCubit.switchTempUnit(),
                          ),
                  ),
                  IgnorePointer(
                    child: Row(
                      children: [
                        Container(
                          height: boxHeight,
                          width: boxWidth,
                          alignment: Alignment.center,
                          child: Text(
                            '°C',
                            style: semiboldText.copyWith(
                              fontSize: 16,
                              color: counterCubit.isCelsius
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Container(
                          height: boxHeight,
                          width: boxWidth,
                          alignment: Alignment.center,
                          child: Text(
                            '°F',
                            style: semiboldText.copyWith(
                              fontSize: 16,
                              color: counterCubit.isCelsius
                                  ? Colors.grey.shade600
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }
}
