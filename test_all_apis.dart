import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://quick-backend-m19x.onrender.com';

Future<void> testEndpoint(String name, Future<http.Response> Function() request) async {
  try {
    print('Testing $name...');
    final response = await request();
    print('Status: ${response.statusCode}');
    if (response.body.isNotEmpty) {
      try {
        final decoded = json.decode(response.body);
        print('Body: $decoded');
      } catch (e) {
        print('Body: ${response.body}');
      }
    } else {
      print('Body: <empty>');
    }
  } catch (e) {
    print('Error: $e');
  }
  print('--------------------------------------------------');
}

void main() async {
  await testEndpoint('Verify OTP', () => http.post(
    Uri.parse('$baseUrl/api/auth/verify-otp'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': 'test@example.com', 'code': '123456', 'role': 'passenger'}),
  ));

  await testEndpoint('Driver Login', () => http.post(
    Uri.parse('$baseUrl/api/auth/driver-login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': 'driver@example.com', 'password': 'password123'}),
  ));

  await testEndpoint('Driver Signup', () => http.post(
    Uri.parse('$baseUrl/api/auth/driver-signup'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': 'newdriver@example.com',
      'phoneNumber': '+1234567890',
      'fullName': 'Test Driver',
      'password': 'password123'
    }),
  ));

  await testEndpoint('Request Ride', () => http.post(
    Uri.parse('$baseUrl/api/rides/request'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'pickup': {'lat': 0.0, 'lng': 0.0},
      'dropoff': {'lat': 0.0, 'lng': 0.0},
      'passengerId': '123'
    }),
  ));

  await testEndpoint('Update Ride Status', () => http.put(
    Uri.parse('$baseUrl/api/rides/123/accept'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'driverId': '456'}),
  ));

  await testEndpoint('Rate Ride', () => http.post(
    Uri.parse('$baseUrl/api/rides/123/rate'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'rating': 5}),
  ));

  await testEndpoint('Fetch Collection', () => http.get(
    Uri.parse('$baseUrl/api/users'),
    headers: {'Content-Type': 'application/json'},
  ));
}
