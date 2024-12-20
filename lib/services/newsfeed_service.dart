import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:babel/constant.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/newsfeed.dart';

class NewsfeedService {
  // Get Newsfeeds
  Future<ApiResponse> getNewsfeeds() async {
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
        Uri.parse(newsfeedsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          // Parse the list of newsfeeds
          final List<dynamic> data = jsonDecode(response.body);
          apiResponse.data =
              data.map((newsfeed) => Newsfeed.fromJson(newsfeed)).toList();
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
}
