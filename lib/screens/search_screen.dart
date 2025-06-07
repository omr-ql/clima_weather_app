import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e3c72),
      appBar: AppBar(
        title: const Text(
          'Search Global Weather',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search any city worldwide...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (value) {
          context.read<WeatherProvider>().searchCities(value);
        },
        onSubmitted: (value) => _searchWeather(value),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.searchResults.isEmpty) {
          return const Expanded(
            child: Center(
              child: Text(
                'Type to search for cities worldwide\nExamples: "Cairo", "London", "Tokyo"',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final city = provider.searchResults[index];
              return Card(
                color: Colors.white.withOpacity(0.1),
                child: ListTile(
                  title: Text(
                    city['display'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Lat: ${city['lat'].toStringAsFixed(2)}, Lon: ${city['lon'].toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () {
                    _searchWeather(city['display']);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _searchWeather(String cityName) {
    if (cityName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a city name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<WeatherProvider>().fetchWeatherByCity(cityName.trim());
    context.read<WeatherProvider>().clearSearch();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
