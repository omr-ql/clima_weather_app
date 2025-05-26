import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import 'search_screen.dart';
import 'weather_details_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e3c72),
      appBar: AppBar(
        title: const Text(
          'Your Weather',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Add details button - only show when weather data is available
          Consumer<WeatherProvider>(
            builder: (context, weatherProvider, child) {
              if (weatherProvider.weather != null) {
                return IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  tooltip: 'Weather Details',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherDetailsScreen(
                          weather: weatherProvider.weather!,
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink(); // Return empty widget if no weather data
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'Search City',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh Weather',
            onPressed: () {
              context.read<WeatherProvider>().fetchWeatherByLocation();
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          if (weatherProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${weatherProvider.error}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      weatherProvider.fetchWeatherByLocation();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (weatherProvider.weather == null) {
            return const Center(
              child: Text(
                'No weather data available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: WeatherCard(weather: weatherProvider.weather!),
          );
        },
      ),
    );
  }
}
