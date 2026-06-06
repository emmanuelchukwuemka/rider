import os
import re
import shutil

# 1. Update pubspec.yaml
pubspec_path = "pubspec.yaml"
with open(pubspec_path, "r", encoding="utf-8") as f:
    content = f.read()

# remove supabase_flutter line
content = re.sub(r'^\s*supabase_flutter:.*$\n', '', content, flags=re.MULTILINE)
with open(pubspec_path, "w", encoding="utf-8") as f:
    f.write(content)

# 2. Re-write all dart files in lib/
lib_dir = "lib"
for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            with open(file_path, "r", encoding="utf-8") as f:
                dart_content = f.read()
            
            orig_content = dart_content
            
            # string replacements
            dart_content = dart_content.replace('auth/supabase_auth/', 'auth/custom_auth/')
            dart_content = dart_content.replace('QuickDropSupabaseUserStream', 'QuickDropCustomUserStream')
            dart_content = dart_content.replace('QuickDropSupabaseUser', 'QuickDropCustomUser')
            dart_content = dart_content.replace('SupabaseAuthManager', 'CustomAuthManager')
            dart_content = dart_content.replace('SupabasePhoneAuthManager', 'CustomPhoneAuthManager')
            
            # If the file is main.dart, remove initSupabase() and supabase_config import
            if file == "main.dart":
                dart_content = re.sub(r'import.*supabase_config\.dart.*;\n', '', dart_content)
                dart_content = re.sub(r'await initSupabase\(\);\n', '', dart_content)
                dart_content = re.sub(r'import.*supabase_flutter\.dart.*;\n', '', dart_content)
            
            if dart_content != orig_content:
                with open(file_path, "w", encoding="utf-8") as f:
                    f.write(dart_content)

# 3. Create custom_auth directory and dummy files
os.makedirs("lib/auth/custom_auth", exist_ok=True)

auth_util_content = '''import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'custom_auth_manager.dart';
import 'custom_auth_user_provider.dart';
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
Future<void> authManagerSignOut() async {}
'''

with open("lib/auth/custom_auth/auth_util.dart", "w", encoding="utf-8") as f:
    f.write(auth_util_content)

custom_auth_user_provider_content = '''import 'package:rxdart/rxdart.dart';
import '../base_auth_user_provider.dart';

class QuickDropCustomUser extends BaseAuthUser {
  QuickDropCustomUser({this.loggedIn = false});
  @override
  bool loggedIn;
  @override
  bool get emailVerified => false;
  @override
  AuthUserInfo get authUserInfo => const AuthUserInfo();
  @override
  Future? delete() async {}
  @override
  Future? updateEmail(String email) async {}
  @override
  Future? updatePassword(String newPassword) async {}
  @override
  Future? sendEmailVerification() async {}
}

Stream<BaseAuthUser> QuickDropCustomUserStream() =>
    BehaviorSubject.seeded(QuickDropCustomUser(loggedIn: false));
'''

with open("lib/auth/custom_auth/custom_auth_user_provider.dart", "w", encoding="utf-8") as f:
    f.write(custom_auth_user_provider_content)

custom_auth_manager_content = '''import 'package:flutter/material.dart';
import '../auth_manager.dart';
import '../base_auth_user_provider.dart';

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
}

Future<void> loadAuthData() async {}
Stream<String> get jwtTokenStream => const Stream.empty();
Stream<BaseAuthUser> get authenticatedUserStream => const Stream.empty();
'''

with open("lib/auth/custom_auth/custom_auth_manager.dart", "w", encoding="utf-8") as f:
    f.write(custom_auth_manager_content)

# 4. Create mock versions of api_service.dart and socket_service.dart
api_service_content = '''// api_service.dart mock
Future<List<Map<String, dynamic>>> fetchCollection(String tableName) async => [];
Future<Map<String, dynamic>?> requestRide(Map<String, dynamic> data) async => null;
Future<bool> updateRideStatus(String rideId, String endpoint, [Map<String, dynamic>? data]) async => false;
Future<bool> rateRide(String rideId, int rating) async => false;
Future<String> requestLoginOtp(String emailOrPhone) async => 'error';
Future<Map<String, dynamic>?> verifyLoginOtp(String emailOrPhone, String code, String role) async => null;
Future<Map<String, dynamic>?> driverLogin(String emailOrPhone, String password) async => null;
Future<Map<String, dynamic>?> driverSignup(String email, String phoneNumber, String fullName, String password) async => null;
'''

with open("lib/backend/api_service.dart", "w", encoding="utf-8") as f:
    f.write(api_service_content)

socket_service_content = '''// socket_service.dart mock
class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  bool isConnected = false;

  Function(dynamic)? onNewRideOffer;
  Function(dynamic)? onRideAccepted;
  Function(dynamic)? onDriverLocationUpdated;
  Function(dynamic)? onRideStarted;
  Function(dynamic)? onRideCompleted;
  Function(dynamic)? onRideCancelled;

  void initSocket(String userId, String role) {}
  void updateLocation(double lat, double lng) {}
  void disconnect() {}
}
'''

with open("lib/backend/socket_service.dart", "w", encoding="utf-8") as f:
    f.write(socket_service_content)

# 5. Delete supabase directories
shutil.rmtree("lib/auth/supabase_auth", ignore_errors=True)
shutil.rmtree("lib/backend/supabase", ignore_errors=True)

print("Migration script completed.")
