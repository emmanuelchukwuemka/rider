import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base_auth_user_provider.dart';

class QuickDropCustomUser extends BaseAuthUser {
  QuickDropCustomUser({this.loggedIn = false, this.uid, this.email, this.displayName, this.phoneNumber});
  @override
  bool loggedIn;
  final String? uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;

  @override
  bool get emailVerified => false;
  @override
  AuthUserInfo get authUserInfo => AuthUserInfo(
    uid: uid,
    email: email,
    displayName: displayName,
    phoneNumber: phoneNumber,
  );
  @override
  Future? delete() async {}
  @override
  Future? updateEmail(String email) async {}
  @override
  Future? updatePassword(String newPassword) async {}
  @override
  Future? sendEmailVerification() async {}
}


final BehaviorSubject<QuickDropCustomUser> quickDropAuthSubject =
    BehaviorSubject<QuickDropCustomUser>.seeded(QuickDropCustomUser(loggedIn: false));

Stream<BaseAuthUser> QuickDropCustomUserStream() {
  SharedPreferences.getInstance().then((prefs) {
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final uid = prefs.getString('uid');
    final email = prefs.getString('email');
    quickDropAuthSubject.add(QuickDropCustomUser(
      loggedIn: isLoggedIn,
      uid: uid,
      email: email,
    ));
  });
  return quickDropAuthSubject.stream;
}
