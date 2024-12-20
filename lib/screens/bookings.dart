import 'package:babel/l10n/app_localizations.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/booking.dart';
import 'package:babel/models/trip.dart';
import 'package:babel/services/booking_service.dart';
import 'package:babel/services/trip_service.dart';
import 'package:flutter/material.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  List<Booking> bookings = [];
  Map<int, Trip> tripCache = {};
  bool loading = true;
  void fetchBookings() async {
    final ApiResponse response = await BookingService().getBookings();

    if (!mounted) return;

    if (response.error == null) {
      setState(() {
        bookings = response.data as List<Booking>;
        loading = false;
        // Sort bookings in descending order by creation date
        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        // Pre-fetch trips for all bookings
        for (var booking in bookings) {
          if (!tripCache.containsKey(booking.tripId)) {
            fetchTrip(booking.tripId);
          }
        }
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> fetchTrip(int tripId) async {
    if (tripCache.containsKey(tripId)) return;

    final ApiResponse response = await TripService().getTripById(tripId);

    if (response.error == null) {
      setState(() {
        tripCache[tripId] = response.data as Trip;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

// ---------- Booking Card -----------
  Widget bookingCard(Booking booking, BuildContext context) {
    final theme = Theme.of(context); // Access current theme
    final localizations = AppLocalizations.of(context); // Access localization
    final locale = Localizations.localeOf(context).languageCode;

    // Maps for vehicle, entry requirement, and status translations
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

    // Translate vehicle, entry requirement, and status based on locale
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
// Format the createdAt date as dd/mm/yyyy
    final String formattedDate = booking.createdAt
        .toString()
        .substring(0, 10)
        .split('-')
        .reversed
        .join('/');
    // Get trip details from cache
    final trip = tripCache[booking.tripId];
    final String pickupLocation = trip != null
        ? (locale == 'ar' ? trip.pickupLocationAr : trip.pickupLocationEn)
        : localizations.translate('loading');
    final String destination = trip != null
        ? (locale == 'ar' ? trip.destinationAr : trip.destinationEn)
        : localizations.translate('loading');

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(
          color: theme.primaryColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${localizations.translate('name')}: ${booking.name}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('status')}: $status',
            style: TextStyle(
              color: booking.status == 'confirmed'
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('vehicleType')}: $vehicle',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('entryRequirement')}: $entryRequirement',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('pickupLocation')}: $pickupLocation',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('destination')}: $destination',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('tripDate')}: ${booking.date.toString().substring(0, 10).split('-').reversed.join('/')}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('numberOfPassengers')}: ${booking.numberOfPassengers}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations.translate('bags')}:\n'
            ' - ${localizations.translate('10kg')}: ${booking.numberOfBagsOfWeight10}\n'
            ' - ${localizations.translate('23kg')}: ${booking.numberOfBagsOfWeight23}\n'
            ' - ${localizations.translate('30kg')}: ${booking.numberOfBagsOfWeight30}',
            style: theme.textTheme.bodyMedium,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              formattedDate,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : bookings.isEmpty
            ? Center(
                child: Text(
                AppLocalizations.of(context).translate('noBookingsFound'),
                style: Theme.of(context).textTheme.bodyLarge,
              ))
            : Expanded(
                child: ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: bookingCard(bookings[index], context));
                  },
                ),
              );
  }
}
