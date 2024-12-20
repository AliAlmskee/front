// import 'package:babel/screens/home.dart';
import 'package:babel/screens/login.dart';
// import 'package:babel/screens/trip_detail_page.dart';
// import 'package:babel/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();

  // Method to dynamically set the locale
  static void setLocale(BuildContext context, Locale newLocale) {
    final MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.setLocale(newLocale);
  }
}

class MyAppState extends State<MyApp> {
  // // Variables to check if it's the first run and loading status
  // bool isFirstRun = false;
  // bool isLoading = true;

  Locale _locale = const Locale('ar'); // Default locale is Arabic

  // @override
  // void initState() {
  //   super.initState();
  //   _checkFirstRun(); // Check if it's the first time the app is run
  // }

  // Future<void> _checkFirstRun() async {
  //   // Access shared preferences to store persistent data
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? firstRun = prefs.getBool('first_run');

  //   if (firstRun == null || firstRun == true) {
  //     // If it's the first run or the value is null
  //     prefs.setBool('first_run', false); // Set it to false for future runs
  //     isFirstRun = true; // Update the flag to indicate first run
  //   }
  //   // Loading is complete, update state
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // if (isLoading) {
    //   // Show a loading indicator while checking for the first run
    //   return const MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: Scaffold(
    //       body: Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     ),
    //   );
    // }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Demo',
      theme: themeProvider.currentTheme,
      locale: _locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: const Login(),
    );
  }
}//const TripDetailPage(tripId: 1),
//    home: isFirstRun ? const Intro() : const Home(),