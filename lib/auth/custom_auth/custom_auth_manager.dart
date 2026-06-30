import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth_manager.dart';
import '../base_auth_user_provider.dart';
import 'custom_auth_user_provider.dart';

class CustomPhoneAuthManager extends ChangeNotifier {
  void updateState(int state) {
    notifyListeners();
  }
}

class CustomAuthManager extends AuthManager {
  final CustomPhoneAuthManager phoneAuthManager = CustomPhoneAuthManager();

  @override
  Future signOut() async {}
  @override
  Future deleteUser(BuildContext context) async {}
  @override
  Future updateEmail({required String email, required BuildContext context}) async {}
  @override
  Future resetPassword({required String email, required BuildContext context}) async {}
  
  void handlePhoneAuthStateChanges(BuildContext context) {}
  Future beginPhoneAuth({
    required BuildContext context,
    required String phoneNumber,
    required void Function(BuildContext context) onCodeSent,
  }) async {}
  Future verifySmsCode({
    required BuildContext context,
    required String smsCode,
  }) async {}
  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {}
}

Future<void> loadAuthData() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn) {
    final uid = prefs.getString('uid') ?? '';
    final email = prefs.getString('email') ?? '';
    final displayName = prefs.getString('displayName');
    final phoneNumber = prefs.getString('phoneNumber');
    final user = QuickDropCustomUser(
      loggedIn: true,
      uid: uid,
      email: email,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );
    currentUser = user;
    quickDropAuthSubject.add(user);
  }
}
Stream<String> get jwtTokenStream => const Stream.empty();
Stream<BaseAuthUser> get authenticatedUserStream => const Stream.empty();
