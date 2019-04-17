import 'package:firebase_auth/firebase_auth.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  static FirebaseUser user;
  static String username = '';
  static String UID = "";
  static bool isLogged = false;
  static UserUpdateInfo info;

  void logout() {
    GoogleSignIn().signOut();
    isLogged = false;
  }

  void login(FirebaseUser loguser) {
    user = loguser;
    UID = loguser.uid;
    username = loguser.displayName;
    isLogged = true;
  }
}
