import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/Widget/customBottomNavigation.dart';
import 'package:parkit/screens/CheckAvailabilityScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingDetials extends StatefulWidget {
  MarkerId markerId;
  ParkingDetials({this.markerId});
  @override
  _ParkingDetialsState createState() => _ParkingDetialsState();
}

class _ParkingDetialsState extends State<ParkingDetials> {
  ScrollController _controller;

  @override
  void initState() {
    _search(widget.markerId);
    _controller = ScrollController();
    super.initState();
  }

  List<String> imageList = [
    "http://centurylightingsolutions.com/wp-content/uploads/bfi_thumb/shutterstock_48636268-1-t8xn3rbse7ret6l1j8jthc.jpg",

  ];
 String  _userName='user';
  double latitude=24, longitude=24;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomAppBar(context,0),
        body: ListView(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Swiper(
                itemCount: imageList.length,
                controller: SwiperController(),
                layout: SwiperLayout.STACK,
                itemHeight: 300,
                itemWidth: 300,
                itemBuilder: (context, index) {
                  return Image.network(
                    imageList[index].toString(),
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Center(
                child: Text(
                  'down town toronto parking space'.toUpperCase(),
                  style: TextStyle(letterSpacing: 2, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                size: 25,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'ST CLAIR AWE W 371-357',
                                style: TextStyle(
                                    letterSpacing: 2.5,
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'TORONTO, ON M5P 1N5',
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'CANADA 371-351 ST CLAIR AVE W',
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      InkResponse(
                        onTap: (){
                          openMap(latitude, longitude);
                        },
                        child: Image.asset('assets/icons/location.png',
                            fit: BoxFit.cover, width: 40),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            Icons.person_pin_circle,
                            size: 25,
                          ),
                          Text(
                            'Hosted By:',
                            style: TextStyle(letterSpacing: 0.5, fontSize: 10),
                          ),
                          Text(
                            _userName,
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        child: Image.asset(
                          "assets/icons/avatar-defalut.png",
                          width: 150,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                'Details'.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                'parking is availableparking is availableparking is availableparking is availableparking is availableparking is availableparking is availableparking is available'
                    .toUpperCase(),
                style: TextStyle(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CheckAvailability(widget.markerId.value.toString())));
                },
                color: Colors.green,
                child: Text(
                  'Check Availability'.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }

  void _search( MarkerId markerId) async{
    final notesReference= FirebaseDatabase.instance.reference().child('parkit').child(markerId.value.toString());
    await  notesReference.once().then((DataSnapshot snapshot)
    {
      Map<dynamic, dynamic> values = snapshot.value;
      print(values);
      imageList.removeLast();
      setState(() {
        for(int i=0;i<values['images'].length;i++)
        {
          print(values['images'][i]);
          imageList.add(values['images'][i]);

        }
        _userName=values['name'];
        longitude=values['log'];
        latitude=values['lat'];
      });
    });


  }


  void openMap(double latitude, double longitude) async {
  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
  await launch(googleUrl);
  } else {
  throw 'Could not open the map.';
  }
  }

}
