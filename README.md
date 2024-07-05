# Simple Weather App

A simple weather app built with Flutter that provides weather information for a specified city or the current location. This app utilizes the OpenWeatherMap API to fetch weather data.

## Features as per requirement

- Fetches weather information for the current location or a specified city.
- The App has two screens:
   a. Home screen with a search bar to enter a city name
   b. Weather details screen to display the weather information
- Implements proper error handling for API requests and display user-friendly error messages.
- Uses appropriate state management (e.g., setState, Provider) to manage the app's state.
- Implements a clean and simple responsive design that works on both mobile and tablet devices.
- Displays weather conditions, temperature, humidity, and wind speed.
- Handles network errors and displays appropriate messages.
- Includes a "Refresh" button on the weather details screen to fetch updated weather data.
- Implements data persistence to save the last searched city

## Additional Features

- Search history: Displays a list of recently searched cities instead of showing just the last searched city.
- Persistent search history: Maintains the search history even after the app is restarted.
- Delete button: Includes a delete button to clear search history.
- Theme toggle: Added a light/dark mode to suit users preference and maintain healthy user experience.
- Added custom icon and splash screen for both ios/android.

## Important note 
- Please use your own api key.
- Although the source code includes an api key (not healthy practice).

## Requirements

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- OpenWeatherMap API Key: [Get an API key](https://home.openweathermap.org/users/sign_up)

## Setup

1. Clone the repository:

git clone https://github.com/naimnayak/weather-app.git
cd weather-app.

2. Enable sdk:
   enable dart/flutter sdk for all modules of the project.

4. Open the folder in prefered IDE( VS code/ Android Studio):
   Get dependencies - Run the following command: flutter pub get.

5. Run the app:
   a. Run the app from the IDE terminal - Run the command: flutter run,
       Then choose your emulator.
   b. Run the app directly using the run button from the IDE, but first launch your emulator.

## If facing diffuculty in set up then
- Directly download the app from the repository:
- Click on build/app/outputs/flutter-apk/app-debug.apk 
