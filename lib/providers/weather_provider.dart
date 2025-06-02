import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _searchResults = [];

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get searchResults => _searchResults;

  final WeatherService _weatherService = WeatherService();

  Future<void> fetchWeatherByLocation() async {
    _setLoading(true);
    _error = null;

    try {
      _weather = await _weatherService.getWeatherByLocation();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _setLoading(true);
    _error = null;

    try {
      _weather = await _weatherService.getWeatherByCity(cityName);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchCities(String query) async {
    if (query.length < 2) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      _searchResults = await _weatherService.searchCities(query);
      notifyListeners();
    } catch (e) {
      _searchResults = [];
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
