/// Uri builder class for the OpenWeatherMap API
class OpenWeatherMapAPI {
  OpenWeatherMapAPI();
  static const String _apiBaseUrl = "api.api-ninjas.com";
  static const String _apiPath = "v1/";

  Uri weather({required String lat, required String lon}) => _buildUri(
        endpoint: "weather",
        parametersBuilder: () => cityQueryParameters(lat: lat, lon: lon),
      );

  Uri _buildUri({
    required String endpoint,
    required Map<String, dynamic> Function() parametersBuilder,
  }) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: "$_apiPath$endpoint",
      queryParameters: parametersBuilder(),
    );
  }

  Map<String, dynamic> cityQueryParameters(
          {required String lat, required String lon}) =>
      {
        "lat": lat,
        "lon": lon,
      };
}
