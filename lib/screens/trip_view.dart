import 'package:babel/screens/booking_form.dart';
import 'package:flutter/material.dart';
import 'package:babel/models/trip.dart';
import 'package:babel/utils/image_utils.dart';

class TripView extends StatefulWidget {
  final Trip trip;
  const TripView({super.key, required this.trip});

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {
  late Trip trip;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
  }

  @override
  Widget build(BuildContext context) {
    // Access theme and localization
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    // Dynamically get localized text for trip details
    final pickupLocation =
        locale == 'ar' ? trip.pickupLocationAr : trip.pickupLocationEn;
    final destination =
        locale == 'ar' ? trip.destinationAr : trip.destinationEn;
    final description =
        locale == 'ar' ? trip.descriptionAr : trip.descriptionEn;

    return Scaffold(
      body: Stack(
        children: [
          // PageView for scrolling through images
          PageView.builder(
            itemCount: trip.images.length,
            itemBuilder: (context, index) {
              return Image.memory(
                ImageUtils.convertBase64ToUint8List(trip.images[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          /*
          
          */
          // Positioned back button
          locale == 'ar'
              ? Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.primaryColor, // Theme-based color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              : Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.primaryColor, // Theme-based color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
          // DraggableScrollableSheet for the article
          DraggableScrollableSheet(
            initialChildSize: 0.2, // Initially visible part
            minChildSize: 0.2, // Minimum visible size
            maxChildSize: 0.9, // Maximum size when fully dragged up
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  // color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
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
                            children: [
                              Text(
                                '${locale == 'ar' ? 'من' : 'From'} $pickupLocation ${locale == 'ar' ? 'إلى' : 'to'} $destination',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Divider(
                                height: 20.0,
                                color: theme.dividerColor,
                                thickness: 2.0,
                                indent: 20.0,
                                endIndent: 20.0,
                              ),
                              Text(
                                description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    '${locale == 'ar' ? 'سعر التذكرة :' : 'Ticket Price:'} ',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${trip.price} \$',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        BookingForm(
                          tripId: trip.id,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
