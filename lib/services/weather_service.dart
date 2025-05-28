import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = '61d3e920c441e6623c0f1d674906f87c';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5'; // Fixed this line

  // Get weather by city name (supports any country)
  Future<WeatherModel> getWeatherByCity(String cityName) async {
    try {
      final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';

      print('Fetching weather for: $cityName');
      print('API URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City "$cityName" not found. Try format: "City, Country Code" (e.g., "Cairo, EG")');
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your OpenWeatherMap API key.');
      } else {
        throw Exception('Failed to load weather data. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  // Get weather by coordinates (for current location)
  Future<WeatherModel> getWeatherByLocation() async {
    try {
      Position position = await _getCurrentLocation();
      final url = '$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=metric';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data for current location');
      }
    } catch (e) {
      throw Exception('Error fetching weather by location: $e');
    }
  }

  // Search cities by name (returns multiple results)
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    try {
      final url = 'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey'; // Also fixed this URL

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((city) => {
          'name': city['name'],
          'country': city['country'],
          'state': city['state'] ?? '',
          'lat': city['lat'],
          'lon': city['lon'],
          'display': '${city['name']}, ${city['country']}${city['state'] != null ? ', ${city['state']}' : ''}',
        }).toList();
      } else {
        throw Exception('Failed to search cities');
      }
    } catch (e) {
      throw Exception('Error searching cities: $e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}
