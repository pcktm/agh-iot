import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/models/api_response.dart';
import 'package:http/http.dart' as http;

import '../models/api_error.dart';

String _baseUrl = "192.168.68.220:3000";
// String _baseUrl = "localhost:3000";
Future<ApiResponse> authenticateUser(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  var url = Uri.http(_baseUrl, 'api/auth/login');

  try {
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = json.decode(response.body)["token"];
        break;
      case 400:
        apiResponse.apiError = ApiError("Wrong format of data");
        break;
      default:
        apiResponse.apiError = ApiError("Wrong email or password");
        break;
    }
  } on SocketException {
    apiResponse.apiError = ApiError("Server error. Please retry");
  }
  return apiResponse;
}

Future<ApiResponse> createUser(
    String username, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  var url = Uri.http(_baseUrl, 'api/auth/signup');

  try {
    final response = await http.post(url, body: {
      'name': username,
      'email': email,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = json.decode(response.body)["token"];
        break;
      case 400:
        apiResponse.apiError = ApiError("Wrong format of data");
        break;
      case 409:
        apiResponse.apiError = ApiError("User with this email already exists");
        break;
      default:
        apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
  } on SocketException {
    apiResponse.apiError = ApiError("Server error. Please retry");
  }
  return apiResponse;
}
