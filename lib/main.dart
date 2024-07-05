import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/weather_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/homepage', // Start at homepage
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/homepage':
            return MaterialPageRoute(
              builder: (_) => Homepage(
                isDarkMode: isDarkMode,
                onThemeChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
            );
          case '/weatherpage':
            return MaterialPageRoute(
              builder: (_) => WeatherPage(
                isDarkMode: isDarkMode,
                cityName: settings.arguments as String?, // Extract city name
                onThemeChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
            );
          
        }
      },
    );
  }
}

