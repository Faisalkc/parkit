import 'package:flutter/material.dart';

class PromotionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PromotionsView();
  }
}

class PromotionsView extends StatefulWidget {
  @override
  _PromotionsViewState createState() => _PromotionsViewState();
}

class _PromotionsViewState extends State<PromotionsView> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: Text("Promotions",style: TextStyle(color: Colors.white ),),
        ),
        body: ListView(
          children: <Widget>[
          ],
        ));
  }
}