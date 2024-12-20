import 'dart:convert';
import 'dart:typed_data';

import 'package:babel/main.dart';
import 'package:babel/models/booking.dart';
import 'package:babel/models/newsfeed.dart';
import 'package:babel/models/trip.dart';
import 'package:babel/screens/bookings.dart';
import 'package:babel/theme_provider.dart';
import 'package:babel/utils/image_utils.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

// ---------- BASE URL -----------
const baseURL = 'http://192.168.103.19:8000/api';
// php artisan serve --host=192.168.103.19 --port=8000
// API Endpoints
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const tripsURL = '$baseURL/trips';
const newsfeedsURL = '$baseURL/newsfeeds';
const bookingsURL = '$baseURL/bookings';
const bookURL = '$baseURL/book';

// ---------- ERROR MESSAGES -----------
// String serverError(BuildContext context) =>
//     AppLocalizations.of(context).translate('serverError');
// String unauthorized(BuildContext context) =>
//     AppLocalizations.of(context).translate('unauthorized');
// String somethingWentWrong(BuildContext context) =>
//     AppLocalizations.of(context).translate('somethingWentWrong');

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// ---------- Input Decoration -----------
InputDecoration inputDecoration(
    String label, IconData iconData, BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  return InputDecoration(
    prefixIcon: Icon(
      iconData,
      color: theme.primaryColor, // Theme-based icon color
    ),
    labelText: label, // Use the string passed directly
    labelStyle: TextStyle(
      color: theme.textTheme.bodyLarge?.color, // Theme-based label text color
    ),
    contentPadding: const EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Theme.of(context).primaryColor, // Theme-based border color
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: theme.primaryColor, // Theme-based focused border color
      ),
    ),
  );
}

// ---------- Text Button -----------
TextButton textButton(String label, Function onPressed, BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  return TextButton(
    onPressed: () => onPressed(),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
          (states) => theme.primaryColor), // Theme-based background color
      padding: WidgetStateProperty.resolveWith(
          (states) => const EdgeInsets.symmetric(vertical: 10)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: theme.textTheme.bodyLarge?.color, // Theme-based text color
      ),
    ),
  );
}

// ---------- Login Register Hint -----------
Row loginRegisterHintRow(
    String text, String label, Function onTap, BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color, // Theme-based text color
        ),
      ),
      GestureDetector(
        child: Text(
          label,
          style: TextStyle(
            color: theme.primaryColor, // Theme-based highlight color
            fontWeight: FontWeight.bold, // Highlighted label styling
          ),
        ),
        onTap: () => onTap(),
      ),
    ],
  );
}

// ---------- AppBar -----------
AppBar appBar(BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  return AppBar(
    leading: Builder(
      builder: (context) => IconButton(
        icon: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Icon(
            Icons.menu,
            color: theme.iconTheme.color, // Theme-based icon color
          ),
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    ),
    actions: [
      // IconButton(
      //   icon: Icon(
      //     Icons.search,
      //     color: theme.iconTheme.color, // Theme-based icon color
      //   ),
      //   onPressed: () {},
      // ),
      IconButton(
        icon: Icon(
          Icons.language,
          color: theme.iconTheme.color,
        ),
        onPressed: () {
          final currentLocale = Localizations.localeOf(context).languageCode;
          final newLocale =
              currentLocale == 'en' ? const Locale('ar') : const Locale('en');
          MyApp.setLocale(context, newLocale);
        },
      ),
      Builder(
        builder: (context) => IconButton(
          icon: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Icon(
              Icons.notifications_none_rounded,
              color: theme.iconTheme.color, // Theme-based icon color
            ),
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ),
    ],
    backgroundColor: theme.primaryColor, // Theme-based background color
  );
}

// ---------- Services Container -----------
GestureDetector servicesContainer(
    String text, IconData iconData, Function onTap, BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      width: 75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor, // Theme-based background color
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: theme.primaryColor, // Theme-based border color
          width: 3.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 25,
            color: theme.primaryColor, // Theme-based icon color
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor, // Theme-based text color
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

// ---------- Bottom Navigation Bar -----------
Container bottomNavBar(
    Function(int) onTabChange, int selectedIndex, BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  final localizations = AppLocalizations.of(context); // Access localization

  return Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withOpacity(0.5), // Theme-based shadow color
          spreadRadius: 5,
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: CurvedNavigationBar(
      index: selectedIndex,
      height: 60.0,
      items: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flight,
              size: selectedIndex == 0 ? 35 : 30,
              color: selectedIndex == 0
                  ? theme.primaryColor // Theme-based active icon color
                  : theme
                      .scaffoldBackgroundColor, // Theme-based inactive icon color
            ),
            Text(
              localizations.translate('flights'), // Localized text
              style: TextStyle(
                fontSize: 12,
                color: selectedIndex == 0
                    ? theme.primaryColor // Theme-based active text color
                    : theme
                        .scaffoldBackgroundColor, // Theme-based inactive text color
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.newspaper,
              size: selectedIndex == 1 ? 35 : 30,
              color: selectedIndex == 1
                  ? theme.primaryColor // Theme-based active icon color
                  : theme
                      .scaffoldBackgroundColor, // Theme-based inactive icon color
            ),
            Text(
              localizations.translate('news'), // Localized text
              style: TextStyle(
                fontSize: 12,
                color: selectedIndex == 1
                    ? theme.primaryColor // Theme-based active text color
                    : theme
                        .scaffoldBackgroundColor, // Theme-based inactive text color
              ),
            ),
          ],
        ),
      ],
      color: theme.primaryColor, // Theme-based navigation bar color
      buttonBackgroundColor:
          theme.scaffoldBackgroundColor, // Theme-based button color
      backgroundColor:
          theme.scaffoldBackgroundColor, // Theme-based background color
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      onTap: (index) => onTabChange(index),
    ),
  );
}

// ---------- Left Drawer -----------
Drawer drawer(BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  final localizations = AppLocalizations.of(context); // Access localization

  return Drawer(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            // Logo
            DrawerHeader(
              child: Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/image1.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Text(
              localizations.translate('babelStation'), // Localized text
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.primaryColor, // Theme-based color
              ),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
              color: theme.dividerColor, // Theme-based divider color
            ),
            Switch(
              activeColor: theme.primaryColor, // Theme-based switch color
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
            // I want to add a card here that shows the user info as this
            // Name : or الاسم:
            // Phone Number : or رقم الهاتف:
            // Location : or الموقع:
            // so it should be like this and handle the language change
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListTile(
            leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {},
              color: theme.iconTheme.color, // Theme-based icon color
            ),
            title: Text(
              localizations.translate('logout'), // Localized text
              style: TextStyle(
                color:
                    theme.textTheme.bodyLarge?.color, // Theme-based text color
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// ---------- Right Drawer -----------
Drawer endDrawer(BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  final localizations = AppLocalizations.of(context); // Access localization

  return Drawer(
    child: Column(
      children: [
        // Drawer header
        DrawerHeader(
          decoration: BoxDecoration(
            color: theme.primaryColor, // Theme-based background color
          ),
          child: Center(
            child: Text(
              localizations.translate('myBookings'), // Localized text
              style: const TextStyle(
                color: Colors.white, // Fixed color for contrast
                fontSize: 24,
              ),
            ),
          ),
        ),
        const Bookings(), // Assuming this is another widget
      ],
    ),
  );
}

// ---------- Trip Card -----------
Widget tripCard(Trip trip, VoidCallback onPressed, BuildContext context) {
  final theme = Theme.of(context); // Access theme
  final locale =
      Localizations.localeOf(context).languageCode; // Get current locale

  // Dynamically select pickup and destination based on locale
  final pickupLocation =
      locale == 'ar' ? trip.pickupLocationAr : trip.pickupLocationEn;
  final destination = locale == 'ar' ? trip.destinationAr : trip.destinationEn;

  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: theme.cardColor, // Themed background color
        padding: const EdgeInsets.fromLTRB(30, 30, 0, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.centerLeft,
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          '${AppLocalizations.of(context).translate('from')} $pickupLocation ${AppLocalizations.of(context).translate('to')} $destination',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color, // Themed text color
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}

// ---------- Newsfeed Card -----------
Widget newsfeedCard(
    Newsfeed newsfeed, VoidCallback onTap, BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  final locale = Localizations.localeOf(context); // Access current locale

  // Determine the title based on the locale
  final title =
      locale.languageCode == 'ar' ? newsfeed.titleAr : newsfeed.titleEn;

  return InkWell(
    onTap: onTap,
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.primaryColor, // Theme-based background color
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: newsfeed.images.isNotEmpty
                ? Image.memory(
                    ImageUtils.convertBase64ToUint8List(newsfeed.images[0]),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
          ),
          // Overlay Text
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[600]
                    ?.withOpacity(0.8), // Semi-transparent overlay
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Text(
                title, // Dynamically selected title
                style: const TextStyle(
                  color: Colors.white, // Fixed text color for contrast
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------- Add Delete Container -----------
void incrementCounter(Function(int) onUpdate, int currentValue) {
  onUpdate(currentValue + 1);
}

Widget buildAddDeleteContainer({
  required String label,
  required int value,
  required Function(int) onUpdate,
  required Function(Function(int), int) decrementFunction,
  required BuildContext context,
}) {
  final theme = Theme.of(context); // Access current theme

  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyLarge?.color, // Theme-based text color
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            color: theme.primaryColor, // Application primary color for the icon
            onPressed: () => decrementFunction(onUpdate, value),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  theme.scaffoldBackgroundColor, // Application background color
              borderRadius: BorderRadius.circular(8), // Rounded container
              border: Border.all(
                  color: theme.primaryColor, width: 1.5), // Border color
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                color:
                    theme.textTheme.bodyLarge?.color, // Theme-based text color
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            color: theme.primaryColor, // Application primary color for the icon
            onPressed: () => incrementCounter(onUpdate, value),
          ),
        ],
      ),
    ],
  );
}

// ---------- Booking Card -----------
Widget bookingCard(Booking booking, BuildContext context) {
  final theme = Theme.of(context); // Access current theme
  final localizations = AppLocalizations.of(context); // Access localization
  final locale = Localizations.localeOf(context).languageCode;

  // Maps for vehicle and entry requirement translations
  final Map<String, String> vehicleMap = {
    "Car": "سيارة",
    "Van": "فان",
    "Car or Van": "سيارة أو فان",
  };

  final Map<String, String> entryRequirementMap = {
    "Visa": "تأشيرة",
    "Foreign Passport": "جواز سفر أجنبي",
    "Residency": "إقامة",
    "E-Visa": "تأشيرة إلكترونية",
  };

  final Map<String, String> statusMap = {
    "pending": "قيد الانتظار",
    "confirmed": "مؤكد",
    "cancelled": "ملغى",
    "completed": "مكتمل",
  };
  // Translate vehicle and entry requirement based on locale
  final String vehicle = locale == 'ar'
      ? vehicleMap[booking.vehicle] ?? booking.vehicle
      : booking.vehicle;

  final String entryRequirement = locale == 'ar'
      ? entryRequirementMap[booking.entryRequirement] ??
          booking.entryRequirement
      : booking.entryRequirement;

  final String status = locale == 'ar'
      ? statusMap[booking.status] ?? booking.status
      : booking.status;
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: theme.cardColor, // Theme-based card background color
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withOpacity(0.5), // Theme-based shadow color
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Booking Name
        Text(
          '${localizations.translate('name')}: ${booking.name}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Booking Status
        Text(
          '${localizations.translate('status')} : $status',
          style: TextStyle(
            color: booking.status == 'confirmed'
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        // Vehicle Type
        Text(
          '${localizations.translate('vehicleType')} : $vehicle',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),

        // Entry Requirement
        Text(
          '${localizations.translate('entryRequirement')} : $entryRequirement',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),

        // Date
        Text(
          '${localizations.translate('tripDate')} : ${booking.date.toString().substring(0, 10).split('-').reversed.join('-')}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),

        // Number of Passengers
        Text(
          '${localizations.translate('numberOfPassengers')} : ${booking.numberOfPassengers}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),

        // Number of Bags
        Text(
          '${localizations.translate('bags')} :\n'
          ' - ${localizations.translate('10kg')} : ${booking.numberOfBagsOfWeight10}\n'
          ' - ${localizations.translate('23kg')} : ${booking.numberOfBagsOfWeight23}\n'
          ' - ${localizations.translate('30kg')} : ${booking.numberOfBagsOfWeight30}',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),

        // Passport and Ticket Photos
      ],
    ),
  );
}

// ---------- Error Dialog -----------
void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

// ---------- Custom Image -----------
Widget customImage({
  required String imageSource,
  bool isBase64 = false,
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  // Helper to decode Base64 to Uint8List
  Uint8List base64ToUint8List(String base64String) {
    return base64Decode(base64String);
  }

  if (isBase64) {
    // Handle Base64 image
    return Image.memory(
      base64ToUint8List(imageSource),
      width: width,
      height: height,
      fit: fit,
    );
  } else if (imageSource.startsWith('http')) {
    // Handle network image
    return Image.network(
      imageSource,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 50);
      },
    );
  } else {
    // Handle local asset image
    return Image.asset(
      imageSource,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
