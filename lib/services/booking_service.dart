import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babel/constant.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/booking.dart';

class BookingService {
  // Create Booking
  Future<ApiResponse> createBooking(Map<String, dynamic> bookingData) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Retrieve token from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      if (token == null) {
        apiResponse.error = "No token found. User is not logged in.";
        return apiResponse;
      }

      // Make the API request
      final response = await http.post(
        Uri.parse(bookURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bookingData),
      );

      switch (response.statusCode) {
        case 201:
          // Parse the response into a Booking object
          final data = jsonDecode(response.body);
          apiResponse.data = Booking.fromJson(data);
          break;

        default:
          // Handle errors
          final data = jsonDecode(response.body);
          apiResponse.error = data['message'] ?? somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = '$serverError: $e';
    }
    return apiResponse;
  }

// Get all bookings for the authenticated user
  Future<ApiResponse> getBookings() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Retrieve the user's token from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      // If no token is found, return an error
      if (token == null) {
        apiResponse.error = "No token found. User is not authenticated.";
        return apiResponse;
      }

      // Make the GET request to fetch bookings
      final response = await http.get(
        Uri.parse(bookingsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          // Parse the bookings list
          final List<dynamic> data = jsonDecode(response.body);
          apiResponse.data =
              data.map((booking) => Booking.fromJson(booking)).toList();
          break;

        default:
          final data = jsonDecode(response.body);
          apiResponse.error = data['message'] ?? somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = '$serverError: $e';
    }

    return apiResponse;
  }
}
