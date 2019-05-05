
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthpageState();
  }
}

class _AuthpageState extends State<AuthPage> {
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _isLogin = true;
  void changePage(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
    });
  }

  void scafoldMessages(String msg) {
    _scafoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'back',
        child: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      key: _scafoldKey,
      body: _isLoading
          ? loadingScreen()
              : Container(
                  padding: EdgeInsets.all(25),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 150,
                            width: 150,
                            child: Image.asset(
                              "assets/images/logo.png",
                            ),
                          ),
                          _isLogin
                              ? LoginPage(changePage, scafoldMessages)
                              : SignUpPage(changePage, scafoldMessages),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget loadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void enableLoadingScreen() {
    setState(() {
      _isLoading = true;
    });
  }

  void disableLoadingScreen() {
    setState(() {
      _isLoading = false;
    });
  }

}
