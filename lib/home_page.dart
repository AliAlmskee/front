import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'main.dart';
import 'l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizations = AppLocalizations.of(context); // Access localizations

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('appTitle')), // Translated title
        backgroundColor: Theme.of(context).primaryColor, // Themed AppBar color
        actions: [
          // Toggle theme button
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: themeProvider.toggleTheme,
          ),
          // Language toggle button
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              final currentLocale =
                  Localizations.localeOf(context).languageCode;
              final newLocale = currentLocale == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
              MyApp.setLocale(context, newLocale);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Text
          Text(
            localizations.translate('widgetsShowcase'),
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ?.copyWith(fontSize: 28),
          ),
          const SizedBox(height: 16),

          // Elevated Button
          ElevatedButton(
            onPressed: () {},
            child: Text(localizations.translate('elevatedButton')),
          ),
          const SizedBox(height: 16),

          // Outlined Button
          OutlinedButton(
            onPressed: () {},
            child: Text(localizations.translate('outlinedButton')),
          ),
          const SizedBox(height: 16),

          // Themed TextField
          TextField(
            cursorColor: Theme.of(context).primaryColor, // Cursor color
            decoration: InputDecoration(
              labelText: localizations.translate('themedTextField'),
              labelStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, // Border color
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor, // Focused border
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Switch (auto-themed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localizations.translate('switchTheme')),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Slider (auto-themed)
          Slider(
            value: 50,
            min: 0,
            max: 100,
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),

          // Manual Theme Change Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!themeProvider.isDarkMode) themeProvider.toggleTheme();
                },
                child: Text(localizations.translate('switchToDarkMode')),
              ),
              ElevatedButton(
                onPressed: () {
                  if (themeProvider.isDarkMode) themeProvider.toggleTheme();
                },
                child: Text(localizations.translate('switchToLightMode')),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Additional Text for theme testing
          Text(
            localizations.translate('additionalThemedText'),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),

          // Centered Button for Theme Toggle
          Center(
            child: ElevatedButton(
              onPressed: themeProvider.toggleTheme,
              child: Text(
                themeProvider.isDarkMode
                    ? localizations.translate('switchToLightMode')
                    : localizations.translate('switchToDarkMode'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
