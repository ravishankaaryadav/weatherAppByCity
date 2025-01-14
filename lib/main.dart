import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/weatherByCity/domain/weather/weather_hive_data.dart';
import 'features/weatherByCity/presentation/pages/weather_city_page.dart';

Future<void> main() async {
 // It is used so that void main function  
  // can be intiated after successfully 
  // intialization of data 
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // To intialise the hive database 
  await Hive.initFlutter(); 
  Hive.registerAdapter(WeatherHiveDataAdapter());


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final textStyleWithShadow = TextStyle(color: Colors.white, shadows: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.25),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 0.5),
      )
    ]);
    return MaterialApp(
      title: 'Flutter Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
          displayLarge: textStyleWithShadow,
          displayMedium: textStyleWithShadow,
          displaySmall: textStyleWithShadow,
          headlineMedium: textStyleWithShadow,
          headlineSmall: textStyleWithShadow,
          titleMedium: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          bodySmall: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ),
      home: const WeatherPage(),
    );
  }
}
