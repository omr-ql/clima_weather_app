class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final int pressure;
  final int visibility;
  final DateTime dateTime;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.pressure,
    required this.visibility,
    required this.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      pressure: json['main']['pressure'] ?? 0,
      visibility: ((json['visibility'] as num).toDouble() / 1000).round(),
      dateTime: DateTime.now(),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  String get temperatureString => '${temperature.round()}°';

  String get capitalizedDescription =>
      description.split(' ').map((word) =>
      word[0].toUpperCase() + word.substring(1)).join(' ');
}
