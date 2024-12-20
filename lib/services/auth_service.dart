import 'dart:convert';
import 'package:babel/constant.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/user.dart';
import 'package:babel/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Register
  Future<ApiResponse> register(Map<String, String> requestBody) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(
        Uri.parse(registerURL),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      switch (response.statusCode) {
        case 201:
          final data = jsonDecode(response.body);
          apiResponse.data = UserData.fromJson(data['data']);
          break;

        case 422:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;

        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = '$serverError: $e';
    }
    return apiResponse;
  }

  // Login
  Future<ApiResponse> login(String phoneNumber, String password) async {
    ApiResponse apiResponse = ApiResponse();
    try {
      final response = await http.post(
        Uri.parse(loginURL),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"phone_number": phoneNumber, "password": password}),
      );

      switch (response.statusCode) {
        case 200: // Successful login
          final data = jsonDecode(response.body);
          apiResponse.data = UserData.fromJson(data['data']);
          break;
        case 422:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 403:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        case 401:
          apiResponse.error = jsonDecode(response.body)['message'];
          break;
        default:
          apiResponse.error = somethingWentWrong;
          break;
      }
    } catch (e) {
      apiResponse.error = '$serverError: $e';
    }
    return apiResponse;
  }

  // Logout
  Future<ApiResponse> logout() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      if (token == null) {
        apiResponse.error = "No token found. User is not logged in.";
        return apiResponse;
      }

      final response = await http.post(
        Uri.parse(logoutURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      switch (response.statusCode) {
        case 200:
          apiResponse.data = jsonDecode(response.body)['message'];

          await preferences.remove('token');
          await preferences.remove('userId');
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

  Future<ApiResponse> getUserDetails() async {
    ApiResponse apiResponse = ApiResponse();
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('token');

      if (token == null) {
        apiResponse.error = "No token found. User is not logged in.";
        return apiResponse;
      }

      // Make the API request
      final response = await http.get(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      switch (response.statusCode) {
        case 200:
          // Parse and save the user data
          final data = jsonDecode(response.body)['user'];
          apiResponse.data = User.fromJson(data);
          break;

        default:
          // Parse and handle error messages
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
