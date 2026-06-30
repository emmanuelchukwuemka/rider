import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'custom_auth_manager.dart';
import 'custom_auth_user_provider.dart';
import 'custom_auth_user_provider.dart';
import '../base_auth_user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'custom_auth_manager.dart';

final _authManager = CustomAuthManager();
CustomAuthManager get authManager => _authManager;
String get currentUserEmail => currentUser?.email ?? '';
String get currentUserUid => currentUser?.uid ?? '';
String get currentUserDisplayName => currentUser?.displayName ?? '';
String get currentUserPhoto => currentUser?.photoUrl ?? '';
String get currentPhoneNumber => currentUser?.phoneNumber ?? '';
String get currentJwtToken => '';
bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

Future<void> authManagerSignIn(BuildContext context, String email, String password) async {}
Future<void> authManagerSignOut() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  await prefs.remove('authToken');
  await prefs.remove('uid');
  await prefs.remove('email');
  await prefs.remove('displayName');
  await prefs.remove('phoneNumber');
  await prefs.remove('driverType');
  await prefs.remove('activeRideId');
  await prefs.remove('activeRideStatus');
  currentUser = null;
  quickDropAuthSubject.add(QuickDropCustomUser(loggedIn: false));
}

class AuthUserStreamWidget extends StatelessWidget {
  const AuthUserStreamWidget({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

Future<void> saveAuthData(String token, String accountId, String email, {String? displayName, String? phoneNumber}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('authToken', token);
  await prefs.setString('uid', accountId);
  await prefs.setString('email', email);
  if (displayName != null) await prefs.setString('displayName', displayName);
  if (phoneNumber != null) await prefs.setString('phoneNumber', phoneNumber);
  final user = QuickDropCustomUser(loggedIn: true, uid: accountId, email: email, displayName: displayName, phoneNumber: phoneNumber);
  currentUser = user;
  quickDropAuthSubject.add(user);
}
dynamic get currentUserReference => null;
