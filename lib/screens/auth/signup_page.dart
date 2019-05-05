import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:parkit/parking/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:parkit/resources/repository.dart';

class SignUpPage extends StatefulWidget {
  final Function changePage;
  final Function(String msg) sncakbarMessages;
  SignUpPage(this.changePage,  this.sncakbarMessages);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _userName, _useremail;
  String _userphone, _userPassword;

  @override
  Widget build(BuildContext context) {
    return _buildLoginWidget(context: context);
  }

  bool fieldValidation() {
    if (_userName == null ||
        _userName == '' ||
        _userPassword == null ||
        _userPassword == '' ||
        _useremail == null ||
        _useremail == '' ||
        _userphone == null ||
        _userphone == '') {
      return false;
    } else {
      return true;
    }
  }

  void signUpProcess() async {
    if (fieldValidation()) {
      print('started');
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _useremail, password: _userPassword);
        UserUpdateInfo info = UserUpdateInfo();
        info.displayName = _userName;

        user.updateProfile(info);
        await afterLogin();
        widget.sncakbarMessages("Welcome ...");
      } catch (e ) {
        print(e);
        switch (e.toString()) {
          case 'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)':
          widget.sncakbarMessages('The email address is badly formatted');
          break;
          case 'PlatformException(ERROR_WEAK_PASSWORD, The password must be 6 characters long or more., null)':
            widget.sncakbarMessages('The password must be 6 characters long or more');
            break;
            case 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)':
            widget.sncakbarMessages('The email address is already in use by another account');
            break;
          default:
           widget.sncakbarMessages('Something went wrong');
        }
      }
    } else {
      widget.sncakbarMessages("please enter your details ");
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> googleSignUp() async {
    try {
      print("Started");
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        if (googleAuth.accessToken.isNotEmpty) {
          try {
            final AuthCredential credential = GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            final FirebaseUser user =
                await _auth.signInWithCredential(credential);
                await afterLogin();
            print("signed in " + user.displayName);
            Navigator.of(context).pop(false);
          } catch (e) {
            setState(() {});
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void facebookSignUp() async {
    final facebookLogin = new FacebookLogin();
//    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
       await _auth.signInWithCredential(credential);
       await afterLogin();
        break;
      case FacebookLoginStatus.cancelledByUser:
        widget.sncakbarMessages('CANCELED BY USER');
        break;
      case FacebookLoginStatus.error:
        widget.sncakbarMessages(result.errorMessage);
        break;
    }
  }

  Column _buildLoginWidget({context: BuildContext}) {
    return Column(
      children: <Widget>[
        TextField(
          style: TextStyle(color: Colors.black45),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(labelText: 'Name'),
          onChanged: (String value) {
            _userName = value;
            setState(() {});
          },
        ),
        _space(),
        TextField(
          style: TextStyle(color: Colors.black45),
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Email Address'),
          onChanged: (String value) {
            _useremail = value;
//             setState(() {});
          },
        ),
        _space(),
        TextField(
          style: TextStyle(color: Colors.black45),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Phone Number',
          ),
          onChanged: (String value) {
            _userphone = value;
            setState(() {});
          },
        ),
        _space(),
        TextField(
          style: TextStyle(color: Colors.black45),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Password'),
          onChanged: (String value) {
            // setState(() {});
            _userPassword = value;
          },
        ),
        SizedBox(
          height: 25,
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: Colors.green)),
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          // color: Theme.of(context).buttonColor,
          textColor: Colors.green,
          child: Text('   Sign Up  '),
          onPressed: () {
            signUpProcess();
          },
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: Colors.blue)),
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          // color: Theme.of(context).buttonColor,
          textColor: Colors.blueAccent,
          child: Text('Facebook'),
          onPressed: () {
            facebookSignUp();
          },
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: Colors.red)),
          padding: EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          // color: Theme.of(context).buttonColor,
          textColor: Colors.redAccent,
          child: Text('+Google'),
          onPressed: () {
            googleSignUp();
          },
        ),
        Container(
          margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Text(
            'Or',
            style: TextStyle(
              color: Colors.black45,
            ),
          ),
        ),
        FlatButton(
          child: Text(
            'Already have an account? Login ',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            widget.changePage(true);
          },
        ),
      ],
    );
  }

  Widget _space() {
    return SizedBox(
      height: 10,
    );
  }
  afterLogin()async
  {
    final user=await FirebaseAuth.instance.currentUser();
    await repository.firebaseDatabase.updateProfilePicInDb(Uri.encodeFull(user.photoUrl), user.uid);
    await repository.firebaseDatabase.updateProfileName(user.displayName, user.uid);
  }
}
