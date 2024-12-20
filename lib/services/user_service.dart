import 'dart:convert';
import 'package:babel/constant.dart';
import 'package:babel/models/api_response.dart';
import 'package:babel/models/user.dart';
import 'package:babel/models/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Login
Future<ApiResponse> login(String phoneNumber, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL), headers: {
      'Accept': 'application/json',
    }, body: {
      'phone_number': phoneNumber,
      'password': password
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Register
Future<ApiResponse> register(Map<String, String> requestBody) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL),
        headers: {'Accept': 'application/json'}, body: jsonEncode(requestBody));
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

// User
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;

      case 401:
        apiResponse.error = unauthorized;
        break;

      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  return preferences.getInt('userId') ?? 0;
}

// logout
Future<bool> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return await preferences.remove('token');
}
