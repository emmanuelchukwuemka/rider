import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

const String baseUrl = 'https://quick-backend-m19x.onrender.com';
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
    final response = await http.post(
      Uri.parse('$baseUrl/api/rides/request'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error requesting ride: $e');
  }
  return null;
}

Future<bool> updateRideStatus(String rideId, String endpoint, [Map<String, dynamic>? data]) async {
  try {
    final response = await http.put(
      Uri.parse('$baseUrl/api/rides/$rideId/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: data != null ? json.encode(data) : null,
    );
    return response.statusCode == 200;
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
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error in driver signup: $e');
  }
  return null;
}

Future<Map<String, dynamic>?> googleLogin(String idToken) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idToken': idToken}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return {'error': json.decode(response.body)['message'] ?? 'Google sign in failed'};
    }
  } catch (e) {
    print('Error in google login: $e');
  }
  return null;
}

Future<Map<String, dynamic>?> userLogin(String emailOrPhone, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/user-login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': emailOrPhone, 'password': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error in user login: $e');
  }
  return null;
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
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
  } catch (e) {
    print('Error in user signup: $e');
  }
  return null;
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
