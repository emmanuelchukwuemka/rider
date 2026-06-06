import 'package:rxdart/rxdart.dart';
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
