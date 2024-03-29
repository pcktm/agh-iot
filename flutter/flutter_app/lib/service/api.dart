import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/models/api_response.dart';
import 'package:flutter_app/models/laundry_session.dart';
import 'package:flutter_app/models/measurment.dart';
import 'package:http/http.dart' as http;

import '../models/api_error.dart';
import '../models/device.dart';
import '../models/user.dart';

// String _baseUrl = "localhost:3000";
// String _baseUrl = "192.168.68.220:3000";
// String _baseUrl = "10.204.91.9:3000";
// String _baseUrl = "192.168.5.143:3000";
// String _baseUrl = "localhost:3000";
String _baseUrl = "iotapi.k00l.net";

Future<ApiResponse> authenticateUser(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  var url = Uri.https(_baseUrl, 'api/auth/login');

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
  var url = Uri.https(_baseUrl, 'api/auth/signup');

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

Future<User> getUser(String token) async {
  var url = Uri.https(_baseUrl, 'api/user');

  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}

Future<List<Device>> getDevices(String token) async {
  var url = Uri.https(_baseUrl, 'api/user/devices');

  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

  if (response.statusCode == 200) {
    return deviceFromJson(response.body);
  } else {
    throw Exception('Failed to load devices');
  }
}

Future<ApiResponse> createLaundrySession(String token, String deviceId,
    String name, String icon, String color) async {
  ApiResponse apiResponse = ApiResponse();
  var url = Uri.https(_baseUrl, 'api/laundrysession');

  try {
    final response = await http.post(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token"
    }, body: {
      'deviceId': deviceId,
      'name': name,
      'icon': icon,
      'color': color,
    });

    if (response.statusCode == 201) {
      apiResponse.data = json.decode(response.body);
    } else {
      try {
        apiResponse.apiError = ApiError.fromJson(json.decode(response.body));
      } catch (e) {
        apiResponse.apiError = ApiError(response.body);
      }
    }
  } on SocketException {
    apiResponse.apiError = ApiError("Server error. Please retry");
  }
  return apiResponse;
}

Future<List<LaundrySession>> getLaundrySession(String token) async {
  var url = Uri.https(_baseUrl, 'api/laundrysession');

  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

  if (response.statusCode == 200) {
    return laundrySessionFromJson(response.body);
  } else {
    throw Exception('Failed to load laundry sessions');
  }
}

void deleteLaundrySession(String token, String id) async {
  var url = Uri.https(_baseUrl, 'api/laundrysession/$id');

  final response = await http
      .delete(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

  if (response.statusCode != 200) {
    throw Exception('Failed to load laundry sessions');
  }
}

Future<http.Response> endLaundrySession(String token, String id) async {
  var url = Uri.https(_baseUrl, 'api/laundrysession/$id/end');

  final response = await http
      .post(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

  if (response.statusCode != 200) {
    throw Exception('Failed to load laundry sessions');
  } else {
    return response;
  }
}

Future<List<Measurement>> getMeasurement(String token, String id) async {
  var url = Uri.https(_baseUrl, 'api/laundrysession/$id/measurements');

  final response = await http
      .get(url, headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

  if (response.statusCode == 200) {
    return measurementFromJson(response.body);
  } else {
    throw Exception('Failed to load measurement');
  }
}

Future<ApiResponse> pairDevice(
    String userId, String ssid, String password) async {
  ApiResponse apiResponse = ApiResponse();
  var url = Uri.http('192.168.4.1:80', 'pair');
  var body = {
    "ssid": ssid,
    "password": password,
    "userId": userId,
  };
  var headers = {
    "Content-Type": "application/json",
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate, br",
    "Content-Length": utf8.encode(json.encode(body)).length.toString()
  };

  final response =
      await http.post(url, body: json.encode(body), headers: headers);

  if (response.statusCode != 200) {
    apiResponse.apiError = ApiError("Wrong format of data");
  } else {
    apiResponse.data = json.decode(response.body)["token"];
  }

  return apiResponse;
}
