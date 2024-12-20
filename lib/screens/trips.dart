import 'package:babel/models/api_response.dart';
import 'package:babel/screens/trip_view.dart';
import 'package:babel/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:babel/models/trip.dart';
import 'package:babel/constant.dart';
// import 'package:babel/screens/trip_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:babel/l10n/app_localizations.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  List<Trip> trips = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  void fetchTrips() async {
    final ApiResponse response = await TripService().getTrips();

    if (!mounted) return;

    if (response.error == null) {
      setState(() {
        trips = response.data as List<Trip>;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme
    final localizations = AppLocalizations.of(context); // Access localization
    // final locale =
    //     Localizations.localeOf(context).languageCode; // Get current locale

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        SizedBox(
          height: 75,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              servicesContainer(localizations.translate('availableVisas'),
                  Icons.translate, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('embassyBooking'),
                  FontAwesomeIcons.calendarCheck, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('languageTest'),
                  Icons.school, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('flightTickets'),
                  Icons.flight, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('accommodation'),
                  Icons.home, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('resume'),
                  Icons.assignment, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('studyAbroad'),
                  Icons.public, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('hotelBooking'),
                  Icons.local_hotel, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('healthInsurance'),
                  Icons.health_and_safety, () {}, context),
              const SizedBox(width: 20.0),
              servicesContainer(localizations.translate('translation'),
                  Icons.translate, () {}, context),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            localizations.translate('trips'),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        loading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: tripCard(
                        trips[index],
                        () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TripView(trip: trips[index]),
                            ),
                          );
                        },
                        context,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
