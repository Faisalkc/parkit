import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  String phoneNumber;
  OtpPage({this.phoneNumber});
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  GlobalKey<ScaffoldState> _scafoldKey;
  bool onTap;
  @override
  void initState() {
    onTap=false;
    _scafoldKey = GlobalKey<ScaffoldState>();
    otpVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      body: SingleChildScrollView(
          child: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'OTP ',
                style: TextStyle(fontSize: 18),
              ),
              Container(
                width: 200,
                child: TextField(
                  onChanged: (otp) {
                    setState(() {
                      _optCode = otp;
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                child: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.grey,
                      onPressed: () async {
                        setState(() {
                          onTap=true;
                        });
                        if (await _signInWithOtp(_optCode, verificationId)) {
                          Navigator.of(context).pop(false);
                        }
                        else{
                          showSnackBar(_message);
                        }
                      },
                      child: onTap?Text(
                        'Retry',
                        style: TextStyle(fontSize: 16),
                      ):Text(
                        'Verify',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.grey,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  width: 200,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 7,
                    children: <Widget>[
                      Text(
                        'Resend',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        '00:00',
                        style: TextStyle(color: Colors.blue),
                      )
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }

  String _message, verificationId, _optCode;
  otpVerification() async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: _optCode);
      FirebaseAuth.instance.linkWithCredential(credential);
      Navigator.of(context).pop(false);
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _scafoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Enter a valid code'),
      ));
      print(authException);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print(verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print(verificationId);
      _scafoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Timeout'),
      ));
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: Duration(seconds: 2),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  showSnackBar(String msg) {
    _scafoldKey.currentState.showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }
  Future<bool> _signInWithOtp(String sms, String tocken) async {
  try {
    await FirebaseAuth.instance.linkWithCredential(
      PhoneAuthProvider.getCredential(smsCode: sms, verificationId: tocken),
    );
    return true;
  } on TargetPlatform catch (e) {
     print(e);
    return false;
  } catch (e) {
    print(e);
   setState(() {
    _message= 'Enter a valid code/ Mobile is associated with a different user account';
   });

return false;
    
  }
}
}


