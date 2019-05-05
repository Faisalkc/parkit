import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function changePage;
  final Function(String msg) sncakbarMessages;

  LoginPage(this.changePage, this.sncakbarMessages);

  @override
  State<StatefulWidget> createState() {
    return _LoginState(changePage);
  }
}

class _LoginState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Function _changePage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _loginData = {'email': null, 'password': null};
  _LoginState(this._changePage);

  @override
  Widget build(BuildContext context) {
    return _buildLoginWidget(_formKey, context: context);
  }

  Form _buildLoginWidget(GlobalKey formkey, {context: BuildContext}) {
    Widget _buildEmailField() {
      return TextField(
        style: TextStyle(color: Colors.black45),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Email Address',
        ),
        onChanged: (String value) {
          setState(() {
            _loginData['email'] = value;
          });
        },
      );
    }

    Widget _buildPasswordField() {
      return TextField(
        style: TextStyle(color: Colors.black45),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        onChanged: (String value) {
          setState(() {
            _loginData['password'] = value;
          });
        },
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildEmailField(),
          SizedBox(
            height: 15,
          ),
          _buildPasswordField(),
          SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 25, right: 5),
            child: InkResponse(
              onTap: () {
                _neverSatisfied();
              },
              child: Text(
                'Forgot Password ??',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                side: BorderSide(color: Colors.black45)),
            padding: EdgeInsets.only(
              left: 50,
              right: 50,
            ),
            // color: Theme.of(context).buttonColor,
            textColor: Colors.black45,
            child: Text('Login'),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                print('Started');
                _formKey.currentState.save();

                try {
                  FirebaseUser user = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _loginData['email'],
                          password: _loginData['password']);
                  print(user.uid);
                  widget.sncakbarMessages("Welcome back...");
                } catch (e) {
                  print(e);
                  print(
                    _loginData['email'] + _loginData['password'],
                  );
                  widget.sncakbarMessages("Enter valid credintials");
                }
                //  Navigator.pushReplacementNamed(context, '/home');
                return;
              } else {}
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
              'Create an account, Sign Up',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              _changePage(false);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  style: TextStyle(color: Colors.black45),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (val) {
                    setState(() {
                      _loginData['email'] = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Please check mail to reset your password'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () async{
                if (_loginData['email'] != null) {
                  try {
                    await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: _loginData['email']);
                  Navigator.of(context).pop();
                  } catch (e) {
                    widget.sncakbarMessages('something went wrong');
                  }
                } else {
                  widget.sncakbarMessages('enter a valid email');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
