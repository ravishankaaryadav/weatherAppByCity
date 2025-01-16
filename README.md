# flutter_weather_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
![Screenshot_20250117-000708](https://github.com/user-attachments/assets/3102ebf7-47d2-428f-b072-d4cf340558b6)



## Technologies and libraries used:
* [Flutter](https://flutter.io)
* Dart
* Dart extensions
*  connectivity_plus: ^5.0.1 check Internet connection
*  hive_flutter: ^1.1.0 for local DB
*  hive: ^2.2.3
*  geolocator: ^9.0.2 current GPS location
* [BLoC Pattern](https://github.com/felangel/bloc) - state management
* [Http](https://pub.dev/packages/dio) - Http client for Dart
* [Retrofit](https://pub.dev/packages/retrofit) - type conversion dio client generator
* [Cached Network Image](https://pub.dev/packages/cached_network_image) - displays and caches images

## Features      
- Automatically acquire user current location
- Searchable location
- Offline weather information
- Local DB store weather information   

## How to Run
1. Create an account at [API ninjas](https://www.api-ninjas.com/).
2. Then get your API key from https://www.api-ninjas.com/profile.
3. Clone the repo
   ```sh
   git clone https://github.com/ravishankaaryadav/weatherAppByCity.git
   ```
4. Install all the packages by typing
   ```sh
   flutter pub get
   ```
5. Navigate to **lib/constants/constant.dart** and paste your API key to the apiKey variable
   ```dart
   String weatherAPIKey = 'Paste Your API Key Here';
   ```
6. Run the App
   ```dart
   flutter run
   ```

