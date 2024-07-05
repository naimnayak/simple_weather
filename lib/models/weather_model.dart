class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double humidity; // Add humidity field
  final double windSpeed; // Add wind speed field

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toDouble(), // Parse humidity from API response
      windSpeed: json['wind']['speed'].toDouble(), // Parse wind speed from API response
    );
  }
}
