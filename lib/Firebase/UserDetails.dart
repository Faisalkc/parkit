import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  FirebaseAuth _auth;

  User() {
    _auth = FirebaseAuth.instance;
  }

  Future<bool> islogged() async {
    if (await _auth.currentUser() != null) {
      return true;
    }
    return false;
  }

  void logout() {
    _auth.signOut();
    GoogleSignIn().signOut();
    FacebookLogin().logOut();
  }

  Future<String> getUserPrifilePic() async {
    FirebaseUser _user = await _auth.currentUser();
    if (_user.photoUrl != null) {
      return _user.photoUrl;
    } else {
      return "https://www.pngarts.com/files/3/Avatar-Transparent-Image.png";
    }
  }
}
