import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationCoordinates {
  final double latitude;
  final double longitude;

  LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });
}

class WeatherData {
  final double temperature;
  final String city;

  WeatherData({required this.temperature, required this.city});
}

class WeatherApi {
  static Future<WeatherData?> getWeatherData(
      double latitude, double longitude) async {
    final apiKey =
        '8ef875dbb8484fdb85c60059242601'; // Replace with your actual API key
    const apiUrl = 'http://api.weatherapi.com/v1';
    try {
      final queryParameters = {
        'key': apiKey,
        'q': '$latitude,$longitude',
      };

      final uri =
          Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final temperature = data['current']['temp_c'] as double;
        final city = data['location']['name'] as String;

        return WeatherData(temperature: temperature, city: city);
      } else {
        // Handle error
        print('Failed to fetch weather data');
        return null;
      }
    } catch (e) {
      // Handle other errors
      print('Error in getWeatherData: $e');
      return null;
    }
  }
}
