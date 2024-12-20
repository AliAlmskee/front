import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babel/constant.dart';
import 'package:babel/l10n/app_localizations.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/services/booking_service.dart';
import 'package:babel/screens/home.dart';

class BookingForm extends StatefulWidget {
  final int tripId;

  const BookingForm({super.key, required this.tripId});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final GlobalKey<FormState> bookingFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  bool loading = false;
  int numOfPassengers = 1;
  int numOfBagsOfWeight10 = 0;
  int numOfBagsOfWeight23 = 0;
  int numOfBagsOfWeight30 = 0;

  String? selectedVehicle; // Backend-compatible value (e.g., "Car")
  String? entryRequirement; // Backend-compatible value (e.g., "Visa")
  String? passportPhoto;
  String? ticketPhoto;
  DateTime? tripDate;

  int? userId; // To store the dynamically fetched user ID

  // Mapping for vehicle dropdown
  final Map<String, String> vehicleMap = {
    "Car": "سيارة",
    "Van": "فان",
    "Car or Van": "سيارة أو فان",
  };

  // Mapping for entry requirement dropdown
  final Map<String, String> entryRequirementMap = {
    "Visa": "تأشيرة",
    "Foreign Passport": "جواز سفر أجنبي",
    "Residency": "إقامة",
    "E-Visa": "تأشيرة إلكترونية",
  };

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  // Fetch user ID using SharedPreferences
  Future<void> fetchUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        userId = preferences.getInt('userId');
      });
    }
  }

  // Image picker to convert images to Base64
  Future<void> pickImage(Function(String) onImageSelected) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      onImageSelected(base64Encode(bytes));
    }
  }

  // Centralized validation for the form
  bool validateForm() {
    final localizations = AppLocalizations.of(context);
    if (!bookingFormKey.currentState!.validate()) {
      showError(localizations.translate('formError'));
      return false;
    }
    if (tripDate == null) {
      showError(localizations.translate('pleaseSelectTripDate'));
      return false;
    }
    if (passportPhoto == null || ticketPhoto == null) {
      showError(localizations.translate('pleaseUploadPhotos'));
      return false;
    }
    if (numOfBagsOfWeight10 == 0 &&
        numOfBagsOfWeight23 == 0 &&
        numOfBagsOfWeight30 == 0) {
      showError(localizations.translate('pleaseAddBags'));
      return false;
    }
    return true;
  }

  // Helper function to display errors
  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Submit form and call backend
  void submitForm() async {
    if (!validateForm()) return; // Validate the form before proceeding

    setState(() {
      loading = true;
    });

    // Build the booking data
    final bookingData = {
      "user_id": userId,
      "trip_id": widget.tripId,
      "number_of_passengers": numOfPassengers,
      "number_of_bags_of_wieght_10": numOfBagsOfWeight10,
      "number_of_bags_of_wieght_23": numOfBagsOfWeight23,
      "number_of_bags_of_wieght_30": numOfBagsOfWeight30,
      "date": tripDate!.toIso8601String(), // Trip date in ISO format
      "vehicle": selectedVehicle, // Backend-compatible value (e.g., "Car")
      "name": nameController.text,
      "entry_requirement":
          entryRequirement, // Backend-compatible value (e.g., "Visa")
      "passport_photo": passportPhoto,
      "ticket_photo": ticketPhoto,
    };

    // Call the service to create booking
    final ApiResponse response =
        await BookingService().createBooking(bookingData);

    if (!mounted) return; // Ensure the widget is still mounted

    setState(() {
      loading = false;
    });

    if (response.error == null) {
      // Booking created successfully
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).translate('success')),
          content: Text(
              AppLocalizations.of(context).translate('bookedSuccessfully')),
          actions: [
            textButton(
              AppLocalizations.of(context).translate('ok'),
              () {
                Navigator.of(context).pop(); // Close success dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false,
                );
              },
              context,
            ),
          ],
        ),
      );
    } else {
      // Show error message
      showError('${response.error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: bookingFormKey,
        child: Column(
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
                  // Name Field
                  TextFormField(
                    controller: nameController,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: inputDecoration(
                      localizations.translate('fullName'),
                      Icons.person,
                      context,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('pleaseEnterFullName');
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

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
                  // Passenger Counter
                  buildBagCounter(
                    localizations.translate('numberOfPassengers'),
                    numOfPassengers,
                    (value) => setState(() => numOfPassengers = value),
                  ),

                  const SizedBox(height: 16),

                  // Bags Weight Counters
                  buildBagCounter(
                    localizations
                        .translate('numOfBags', args: {'count': '10kg'}),
                    numOfBagsOfWeight10,
                    (value) => setState(() => numOfBagsOfWeight10 = value),
                  ),
                  buildBagCounter(
                    localizations
                        .translate('numOfBags', args: {'count': '23kg'}),
                    numOfBagsOfWeight23,
                    (value) => setState(() => numOfBagsOfWeight23 = value),
                  ),
                  buildBagCounter(
                    localizations
                        .translate('numOfBags', args: {'count': '30kg'}),
                    numOfBagsOfWeight30,
                    (value) => setState(() => numOfBagsOfWeight30 = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

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
                  // Dropdown for Vehicle Type
                  DropdownButtonFormField<String>(
                    value: selectedVehicle,
                    decoration: inputDecoration(
                      localizations.translate('vehicleType'),
                      Icons.directions_car,
                      context,
                    ),
                    items: vehicleMap.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key, // Backend-compatible key
                        child: Text(isArabic ? entry.value : entry.key),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedVehicle = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.translate('pleaseSelectVehicle');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown for Entry Requirement
                  DropdownButtonFormField<String>(
                    value: entryRequirement,
                    decoration: inputDecoration(
                      localizations.translate('entryRequirement'),
                      Icons.verified_user,
                      context,
                    ),
                    items: entryRequirementMap.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key, // Backend-compatible key
                        child: Text(isArabic ? entry.value : entry.key),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => entryRequirement = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations
                            .translate('pleaseSelectRequirement');
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Date Picker
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
              child: ListTile(
                title: Text(
                  tripDate == null
                      ? localizations.translate('selectTripDate')
                      : '${localizations.translate('tripDate')}: ${tripDate.toString().substring(0, 10).split('-').reversed.join('/')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => tripDate = pickedDate);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Upload Passport Photo
            ElevatedButton.icon(
              onPressed: () => pickImage((value) {
                setState(() => passportPhoto = value);
              }),
              icon: const Icon(Icons.upload),
              label: Text(localizations.translate(passportPhoto == null
                  ? 'uploadPassport'
                  : 'passportUploaded')),
            ),
            const SizedBox(height: 16),

            // Upload Ticket Photo
            ElevatedButton.icon(
              onPressed: () => pickImage((value) {
                setState(() => ticketPhoto = value);
              }),
              icon: const Icon(Icons.upload),
              label: Text(localizations.translate(
                  ticketPhoto == null ? 'uploadTicket' : 'ticketUploaded')),
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: loading ? null : submitForm,
              child: loading
                  ? const CircularProgressIndicator()
                  : Text(localizations.translate('confirm')),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable bag counter helper
  Widget buildBagCounter(String label, int value, Function(int) onUpdate) {
    return buildAddDeleteContainer(
      label: label,
      value: value,
      onUpdate: onUpdate,
      decrementFunction: decrementBags,
      context: context,
    );
  }

  // Decrement passengers
  void decrementPassengers(Function(int) onUpdate, int currentValue) {
    if (currentValue > 1) {
      onUpdate(currentValue - 1);
    }
  }

  // Decrement bags
  void decrementBags(Function(int) onUpdate, int currentValue) {
    if (currentValue > 0) {
      onUpdate(currentValue - 1);
    }
  }
}
