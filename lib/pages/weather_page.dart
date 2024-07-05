import 'package:flutter/material.dart';
import 'package:simple_weatherapp/models/weather_model.dart';
import 'package:simple_weatherapp/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';

class WeatherPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final String? cityName;

  const WeatherPage({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.cityName,
  }) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService =
      WeatherService(apiKey: '4385f0100a5ab1e34991330346f53145');
  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage; // To store error messages

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => _isLoading = true); // Start loading

    try {
      String? city = widget.cityName ?? await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(city!);
      setState(() {
        _weather = weather;
        _isLoading = false;
        _errorMessage = null; // Clear any previous error messages
      });
    } on SocketException {
      _handleException(
          "No internet connection. Please check your network and try again.");
    } catch (e) {
      _handleException(
          "Sorry but this City/Country is currently unavailable, Please stay tuned!");
    }
  }

  void _handleException(String message) {
    if (mounted) {
      setState(() {
        _isLoading = false;
        _errorMessage = message;
      });
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sun.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
      default:
        return 'assets/sun.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust UI based on the screen size
        double iconSize = constraints.maxWidth > 600 ? 50.0 : 35.0;
        double textSize = constraints.maxWidth > 600 ? 30.0 : 25.0;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'WeatherApp',
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: iconSize,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            WeatherPage(
                          isDarkMode: widget.isDarkMode,
                          onThemeChanged: widget.onThemeChanged,
                          cityName: widget.cityName,
                        ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
          body: Center(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        "Loading city...",
                        style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : _errorMessage != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: textSize - 5,
                              color: widget.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _fetchWeather(),
                            child: Text(
                              "Retry",
                              style: TextStyle(
                                fontSize: textSize - 5,
                                color: widget.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: widget.isDarkMode ? Colors.white : Colors.black,
                                size: iconSize,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _weather?.cityName ?? "Loading city...",
                                style: TextStyle(
                                  fontSize: textSize,
                                  fontWeight: FontWeight.w700,
                                  color: widget.isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                          Text(
                            '${_weather?.temperature?.round() ?? 0}°C',
                            style: TextStyle(
                              fontSize: textSize,
                              fontWeight: FontWeight.w700,
                              color: widget.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            _weather?.mainCondition ?? '',
                            style: TextStyle(
                              fontSize: textSize,
                              fontWeight: FontWeight.w700,
                              color: widget.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Humidity: ${_weather?.humidity ?? 0}%',
                            style: TextStyle(
                              fontSize: textSize - 5,
                              color: widget.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            'Wind Speed: ${_weather?.windSpeed ?? 0} m/s',
                            style: TextStyle(
                              fontSize: textSize - 5,
                              color: widget.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}
