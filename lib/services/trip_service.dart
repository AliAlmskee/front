import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babel/constant.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/trip.dart';

class TripService {
  // Get Trips
  Future<ApiResponse> getTrips() async {
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
      final response = await http.get(
        Uri.parse(tripsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          // Parse the list of trips
          final List<dynamic> data = jsonDecode(response.body);
          apiResponse.data = data.map((trip) => Trip.fromJson(trip)).toList();
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

  /// Fetch a trip by its ID
  Future<ApiResponse> getTripById(int tripId) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Get user token from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      if (token == null) {
        apiResponse.error = "Unauthorized: No token found.";
        return apiResponse;
      }

      // Make the API call
      final response = await http.get(
        Uri.parse('$tripsURL/$tripId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Handle response
      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body);
          apiResponse.data = Trip.fromJson(data); // Convert JSON to Trip model
          break;

        case 404:
          apiResponse.error = "Trip not found.";
          break;

        default:
          apiResponse.error = jsonDecode(response.body)['message'] ??
              somethingWentWrong; // Default error message
          break;
      }
    } catch (e) {
      apiResponse.error = "$serverError: $e";
    }
    return apiResponse;
  }
}
