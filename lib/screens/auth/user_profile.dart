import 'package:flutter/material.dart';
import 'package:parkit/Firebase/UserDetails.dart';

class UserDetails extends StatefulWidget {
  final Function(bool access) logout;
  final Function(String msg) showMessage;

  UserDetails(this.logout, this.showMessage);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String _profilePic =
      "https://www.pngarts.com/files/3/Avatar-Transparent-Image.png";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.yellow],
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft),
            color: Colors.yellow),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                onPressed: () {
                  widget.logout(false);
                  widget.showMessage("You have logout successfully");
                },
                child: Text("Logout"),
              ),
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(Uri.encodeFull(_profilePic)),
                radius: 80,
              ),
            )
          ],
        ),
      ),
    );
  }

  void getUserData() async {
    String url = await User().getUserPrifilePic();
    setState(() {
      _profilePic = url;
    });
  }
}
