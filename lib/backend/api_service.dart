import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

const String baseUrl = 'https://quickbackend-733b.onrender.com';
// const String baseUrl = 'http://192.168.1.135:5000';
Future<List<Map<String, dynamic>>> fetchCollection(String tableName) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/api/$tableName'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
  } catch (e) {
    print('Error fetching collection: $e');
  }
  return [];
}

Future<Map<String, dynamic>?> requestRide(Map<String, dynamic> data) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/rides/request'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    ).timeout(const Duration(seconds: 45));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    try {
      final body = json.decode(response.body);
      return {'_error': body['message'] ?? 'Server error (${response.statusCode})'};
    } catch (_) {
      return {'_error': 'Server error (${response.statusCode})'};
    }
  } on TimeoutException {
    return {'_error': 'Request timed out — server may be starting up. Please try again.'};
  } catch (e) {
    print('Error requesting ride: $e');
    return {'_error': 'Could not connect. Please check your internet connection.'};
  }
}

Future<bool> updateRideStatus(String rideId, String endpoint, [Map<String, dynamic>? data]) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final headers = {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final uri = Uri.parse('$baseUrl/api/rides/$rideId/$endpoint');
    final body = data != null ? json.encode(data) : null;

    // Try PUT first, then PATCH if the server doesn't accept PUT
    var response = await http.put(uri, headers: headers, body: body);
    if (response.statusCode == 405) {
      response = await http.patch(uri, headers: headers, body: body);
    }
    print('[updateRideStatus] $endpoint → ${response.statusCode}: ${response.body}');
    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print('Error updating ride status: $e');
  }
  return false;
}

Future<bool> rateRide(String rideId, int rating) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/rides/$rideId/rate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'rating': rating}),
    );
    return response.statusCode == 200;
  } catch (e) {
    print('Error rating ride: $e');
  }
  return false;
}

Future<void> updateDriverFcmToken(String driverUid, String fcmToken) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    await http.put(
      Uri.parse('$baseUrl/api/drivers/fcm-token'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: json.encode({'driver_uid': driverUid, 'fcm_token': fcmToken}),
    );
  } catch (e) {
    print('[FCM] Failed to save token: $e');
  }
}

Future<Map<String, dynamic>> requestLoginOtp(String emailOrPhone) async {
  try {
    bool isEmail = emailOrPhone.contains('@');
    final Map<String, dynamic> bodyData = isEmail
        ? {'email': emailOrPhone}
        : {'phone_number': emailOrPhone};

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/request-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bodyData),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'success': true, 'debug_otp': data['debug_otp']};
    }
    return {'success': false};
  } catch (e) {
    print('Error requesting OTP: $e');
    return {'success': false};
  }
}

Future<Map<String, dynamic>?> verifyLoginOtp(String emailOrPhone, String code, String role) async {
  try {
    bool isEmail = emailOrPhone.contains('@');
    final Map<String, dynamic> bodyData = {
      'code': code,
      'role': role,
    };
    if (isEmail) {
      bodyData['email'] = emailOrPhone;
    } else {
      bodyData['phone_number'] = emailOrPhone;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bodyData),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error verifying OTP: $e');
  }
  return null;
}

Future<Map<String, dynamic>?> driverLogin(String emailOrPhone, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/driver-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': emailOrPhone, 'password': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error in driver login: $e');
  }
  return null;
}

Future<Map<String, dynamic>?> driverSignup(String email, String phoneNumber, String fullName, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/driver-signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'phone_number': phoneNumber,
        'display_name': fullName,
        'password': password,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    }
    try {
      final body = json.decode(response.body);
      return {'error': body['message'] ?? body['error'] ?? 'Signup failed (${response.statusCode})'};
    } catch (_) {
      return {'error': 'Signup failed (${response.statusCode})'};
    }
  } catch (e) {
    print('Error in driver signup: $e');
    return {'error': 'Could not connect. Please check your internet connection.'};
  }
}

Future<Map<String, dynamic>?> googleLogin(String idToken, {String? displayName}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idToken': idToken,
        if (displayName != null) 'displayName': displayName,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    // Try to parse error message; if body isn't JSON return the raw text
    try {
      final body = json.decode(response.body);
      return {'error': body['message'] ?? body['error'] ?? 'Google sign-in failed (${response.statusCode})'};
    } catch (_) {
      return {'error': 'Server error ${response.statusCode}: ${response.body.substring(0, response.body.length.clamp(0, 120))}'};
    }
  } catch (e) {
    print('Error in google login: $e');
    return {'error': e.toString()};
  }
}

Future<Map<String, dynamic>?> userLogin(String emailOrPhone, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/user-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': emailOrPhone, 'password': password}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    try {
      final body = json.decode(response.body);
      return {'error': body['message'] ?? body['error'] ?? 'Login failed (${response.statusCode})'};
    } catch (_) {
      return {'error': 'Login failed (${response.statusCode})'};
    }
  } catch (e) {
    print('Error in user login: $e');
    return {'error': 'Could not connect. Please check your internet connection.'};
  }
}

Future<Map<String, dynamic>?> userSignup(String email, String phoneNumber, String fullName, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/user-signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'phone_number': phoneNumber,
        'display_name': fullName,
        'password': password,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    }
    try {
      final body = json.decode(response.body);
      return {'error': body['message'] ?? body['error'] ?? 'Signup failed (${response.statusCode})'};
    } catch (_) {
      return {'error': 'Signup failed (${response.statusCode})'};
    }
  } catch (e) {
    print('Error in user signup: $e');
    return {'error': 'Could not connect. Please check your internet connection.'};
  }
}

Future<String?> uploadProfileImage(String imagePath) async {
  try {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/upload'));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url'];
    }
  } catch (e) {
    print('Error uploading profile image: $e');
  }
  return null;
}

Future<Map<String, dynamic>?> updatePassengerProfile(String userId, Map<String, dynamic> data) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$userId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error updating passenger profile: $e');
  }
  return null;
}

Future<Map<String, dynamic>?> fetchUserById(String id) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map) return Map<String, dynamic>.from(data);
    }
  } catch (e) {
    print('Error fetching user by id: $e');
  }
  return null;
}

Future<Map<String, dynamic>?> fetchDriverById(String id) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/drivers/$id'),
      headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error fetching driver by id: $e');
  }
  return null;
}

Future<bool> updateDriverProfile(String id, Map<String, dynamic> data) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/api/drivers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return response.statusCode == 200;
  } catch (e) {
    print('Error updating driver profile: $e');
  }
  return false;
}

Future<Map<String, dynamic>?> fetchRideById(String rideId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/rides/$rideId'),
      headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return json.decode(response.body);
  } catch (e) {
    print('Error fetching ride: $e');
  }
  return null;
}

Future<bool> markDriverArrived(String rideId, String driverId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken') ?? '';
  final headers = {
    'Content-Type': 'application/json',
    if (token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
  final body = json.encode({'driver_id': driverId, 'driverId': driverId});

  // Try POST on every common action endpoint name first (most backends use POST for actions)
  for (final ep in ['arrive', 'arrived', 'driver-arrived', 'pickup-arrived', 'mark-arrived']) {
    try {
      final uri = Uri.parse('$baseUrl/api/rides/$rideId/$ep');
      final res = await http.post(uri, headers: headers, body: body);
      print('[markDriverArrived] POST $ep → ${res.statusCode}: ${res.body}');
      if (res.statusCode == 200 || res.statusCode == 201) return true;
    } catch (e) {
      print('[markDriverArrived] POST $ep error: $e');
    }
  }

  // Try PATCH /api/rides/:id with status field (most flexible fallback)
  try {
    final res = await http.patch(
      Uri.parse('$baseUrl/api/rides/$rideId'),
      headers: headers,
      body: json.encode({'status': 'arrived', 'driver_id': driverId}),
    );
    print('[markDriverArrived] PATCH status → ${res.statusCode}: ${res.body}');
    if (res.statusCode == 200 || res.statusCode == 201) return true;
  } catch (e) {
    print('[markDriverArrived] PATCH error: $e');
  }

  // Try PUT /api/rides/:id/status with body
  try {
    final res = await http.put(
      Uri.parse('$baseUrl/api/rides/$rideId/status'),
      headers: headers,
      body: json.encode({'status': 'arrived', 'driver_id': driverId}),
    );
    print('[markDriverArrived] PUT status → ${res.statusCode}: ${res.body}');
    if (res.statusCode == 200 || res.statusCode == 201) return true;
  } catch (e) {
    print('[markDriverArrived] PUT status error: $e');
  }

  return false;
}

Future<List<Map<String, dynamic>>> fetchPendingRides() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/rides?status=searching'),
      headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) return data.cast<Map<String, dynamic>>();
      if (data is Map && data['rides'] is List) {
        return (data['rides'] as List).cast<Map<String, dynamic>>();
      }
    }
  } catch (e) {
    print('Error fetching pending rides: $e');
  }
  return [];
}

Future<Map<String, dynamic>?> scheduleRide(Map<String, dynamic> data) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.post(
      Uri.parse('$baseUrl/api/scheduled-rides'),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    try {
      final body = json.decode(response.body);
      return {'_error': body['message'] ?? 'Failed to schedule ride (${response.statusCode})'};
    } catch (_) {
      return {'_error': 'Failed to schedule ride (${response.statusCode})'};
    }
  } catch (e) {
    print('Error scheduling ride: $e');
    return {'_error': 'Could not connect. Please check your internet connection.'};
  }
}

Future<List<Map<String, dynamic>>> fetchUserRideHistory(String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/rides/history/user/$userId'),
      headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) return data.cast<Map<String, dynamic>>();
    }
  } catch (e) {
    print('Error fetching user ride history: $e');
  }
  return [];
}

Future<List<Map<String, dynamic>>> fetchDriverRideHistory(String driverId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/api/rides/history/driver/$driverId'),
      headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) return data.cast<Map<String, dynamic>>();
    }
  } catch (e) {
    print('Error fetching driver ride history: $e');
  }
  return [];
}

Future<Map<String, dynamic>> resetDriverPassword({
  required String email,
  required String otp,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp, 'newPassword': newPassword}),
    );
    if (response.statusCode == 200) return {'success': true};
    try {
      final body = json.decode(response.body);
      return {'success': false, 'message': body['message'] ?? 'Reset failed'};
    } catch (_) {
      return {'success': false, 'message': 'Reset failed (${response.statusCode})'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Could not connect. Check your internet.'};
  }
}

Future<Map<String, dynamic>> resetUserPassword({
  required String email,
  required String otp,
  required String newPassword,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/reset-user-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp, 'newPassword': newPassword}),
    );
    if (response.statusCode == 200) return {'success': true};
    try {
      final body = json.decode(response.body);
      return {'success': false, 'message': body['message'] ?? 'Reset failed'};
    } catch (_) {
      return {'success': false, 'message': 'Reset failed (${response.statusCode})'};
    }
  } catch (e) {
    return {'success': false, 'message': 'Could not connect. Check your internet.'};
  }
}

Future<List<Map<String, dynamic>>> fetchScheduledRides({String? status, String? userId}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final params = <String, String>{};
    if (status != null) params['status'] = status;
    if (userId != null) params['passenger_ref'] = userId;
    final uri = Uri.parse('$baseUrl/api/scheduled-rides')
        .replace(queryParameters: params.isEmpty ? null : params);
    final response = await http.get(
      uri,
      headers: {if (token.isNotEmpty) 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) return data.cast<Map<String, dynamic>>();
      if (data is Map && data['rides'] is List) return (data['rides'] as List).cast<Map<String, dynamic>>();
    }
  } catch (e) {
    print('Error fetching scheduled rides: $e');
  }
  return [];
}

Future<bool> cancelScheduledRide(String rideId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    final headers = {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    for (final ep in ['cancel', 'cancelled']) {
      final res = await http.post(
        Uri.parse('$baseUrl/api/scheduled-rides/$rideId/$ep'),
        headers: headers,
      );
      if (res.statusCode == 200 || res.statusCode == 201) return true;
    }
    final res = await http.patch(
      Uri.parse('$baseUrl/api/scheduled-rides/$rideId'),
      headers: headers,
      body: json.encode({'status': 'cancelled'}),
    );
    return res.statusCode == 200 || res.statusCode == 201;
  } catch (e) {
    print('Error cancelling scheduled ride: $e');
  }
  return false;
}
