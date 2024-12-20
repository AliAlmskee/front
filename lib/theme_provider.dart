import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  // Getter to check if the current mode is dark
  bool get isDarkMode => _isDarkMode;

  // Returns the active theme (light or dark)
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Toggles between light and dark themes and notifies listeners
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // ---------------------- LIGHT THEME ----------------------
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFD6B56A),
        scaffoldBackgroundColor: const Color(0xFFD9D9D9),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF4B4B4B),
            fontSize: 22,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF4B4B4B),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF4B4B4B),
            side: const BorderSide(color: Color(0xFF4B4B4B)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD6B56A),
            foregroundColor: const Color(0xFF4B4B4B),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? const Color(0xFFD6B56A)
                : const Color(0xFFD9D9D9);
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? const Color(0xFFD6B56A)
                : const Color(0xFF4B4B4B);
          }),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFFD6B56A),
          inactiveTrackColor: const Color(0xFFD6B56A).withOpacity(0.5),
          thumbColor: const Color(0xFFD6B56A),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: const Color(0xFFD6B56A),
          linearTrackColor: Colors.grey[200],
          circularTrackColor: Colors.grey[300],
        ),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Color(0xFFD9D9D9),
          headerBackgroundColor: Color(0xFFD6B56A),
          headerForegroundColor: Color(0xFF4B4B4B),
          yearStyle: TextStyle(
            color: Color(0xFF4B4B4B),
            fontWeight: FontWeight.bold,
          ),
          dayStyle: TextStyle(
            color: Color(0xFF4B4B4B), // Dark gray for day numbers
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF4B4B4B), // Dark gray text
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ), // Text styling
            backgroundColor: const Color(0xFFD6B56A), // Gold-like background
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Rounded button corners
            ),
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 20), // Button padding
          ),
        ),
      );

  // ---------------------- DARK THEME ----------------------
  ThemeData get darkTheme => ThemeData(
        // Brightness defines the overall theme (dark)
        brightness: Brightness.dark,

        // Primary color for the theme
        primaryColor: const Color(0xFFD6B56A), // Gold-like color

        // Background color for the scaffold
        scaffoldBackgroundColor: const Color(0xFF4B4B4B), // Dark gray

        // Text styling for headlines and body text
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFFD9D9D9), // Light gray text for headers
            fontSize: 22,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFFD9D9D9), // Light gray text for body
          ),
        ),

        // Outlined button styling
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD9D9D9), // Text color
            side: const BorderSide(color: Color(0xFFD9D9D9)), // Border color
          ),
        ),

        // Elevated button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4B4B4B), // Button background
            foregroundColor: const Color(0xFFD9D9D9), // Text color
          ),
        ),

        // Switch styling
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            // Thumb color for selected and unselected states
            return states.contains(WidgetState.selected)
                ? const Color(0xFFD6B56A) // Gold for active
                : const Color(0xFFD9D9D9); // Light gray for inactive
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            // Track color for selected and unselected states
            return states.contains(WidgetState.selected)
                ? const Color(0xFFD6B56A) // Gold for active
                : const Color(0xFF4B4B4B); // Dark gray for inactive
          }),
        ),

        // Slider styling
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFFD6B56A), // Active track color
          inactiveTrackColor:
              const Color(0xFFD6B56A).withOpacity(0.5), // Inactive track color
          thumbColor: const Color(0xFFD6B56A), // Thumb color
        ),

        // Progress indicator styling
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: const Color(
              0xFFD6B56A), // Default color for the progress indicator
          linearTrackColor:
              Colors.grey[200], // Background color for linear indicators
          circularTrackColor:
              Colors.grey[300], // Background color for circular indicators
        ),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Color(0xFF4B4B4B), // Dark gray
          headerBackgroundColor: Color(0xFFD6B56A), // Gold-like color
          headerForegroundColor: Color(0xFFD9D9D9), // Light gray text
          yearStyle: TextStyle(
            color: Color(0xFFD9D9D9), // Light gray for year selector
            fontWeight: FontWeight.bold,
          ),
          dayStyle: TextStyle(
            color: Color(0xFFD9D9D9), // Light gray for day numbers
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFD9D9D9), // Light gray text
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ), // Text styling
            backgroundColor: const Color(0xFF4B4B4B), // Dark gray background
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Rounded button corners
            ),
            padding: const EdgeInsets.symmetric(
                vertical: 12, horizontal: 20), // Button padding
          ),
        ),
      );
}
