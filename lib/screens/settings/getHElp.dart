import 'package:flutter/material.dart';

class GetHelp extends StatefulWidget {
  @override
  _GetHelpState createState() => _GetHelpState();
}

class _GetHelpState extends State<GetHelp> {
  TextStyle _heading = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Request help',
          style: _heading,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: size.width,
        height: size.height,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/help.png',
              fit: BoxFit.cover,
            ),
            Spacer(
              flex: 2,
            ),
            Text(
              'How can we help you?',
              style: _heading,
            ),
            Spacer(
              flex: 1,
            ),
            Text(
              'It looks like you are experiencing a problem  with the application. We are here  to help so please get in touch with us',
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(fontSize: 15),
            ),
            Spacer(
              flex: 2,
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  options(size, Icons.message, 'Chat to us'),
                  options(size, Icons.email, 'Email us'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget options(Size size, IconData _icon, String _options) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(1, 1),
              spreadRadius: 0.2,
              blurRadius: 39,
              color: Colors.black12)
        ],
        color: Colors.white,
      ),
      height: size.width / 3,
      width: size.width / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              _icon,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
          InkResponse(
            child: Text(
              _options,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
