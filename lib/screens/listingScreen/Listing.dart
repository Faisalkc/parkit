
import 'package:flutter/material.dart';
import 'package:parkit/model/user_model.dart';
import 'package:parkit/screens/settings/incompleteScreens.dart';
import 'lising_screen.dart';
import 'package:parkit/Bloc/user_bloc.dart';
class Listing_page extends StatefulWidget {
  @override
  _Listing_pageState createState() => _Listing_pageState();
}

class _Listing_pageState extends State<Listing_page> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    userblock.fetchUserDetails();
    return StreamBuilder(
      stream: userblock.userdetails,
      builder: (context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.isVerified&&snapshot.data.mobile!=null? ListingProcess():IncompleteStepts(snapshot: snapshot,);
        } else if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()));
      });
  }
}