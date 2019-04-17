import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:parkit/parking/appdetails.dart';
import 'package:parkit/screens/CheckAvailabilityScreen.dart';

class ParkingDetials extends StatefulWidget {
  @override
  _ParkingDetialsState createState() => _ParkingDetialsState();
}

class _ParkingDetialsState extends State<ParkingDetials> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  List<String> imageList = [
    "http://centurylightingsolutions.com/wp-content/uploads/bfi_thumb/shutterstock_48636268-1-t8xn3rbse7ret6l1j8jthc.jpg",
    "https://www.trbimg.com/img-56799d21/turbine/ct-mre-1227-condo-adviser-20151222",
    "https://urbanmatter.com/chicago/wp-content/uploads/2015/09/All-Day-Parking.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: ApplicationDetails().bottomAppBar(context),
        body: ListView(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Swiper(
                itemCount: 3,
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
                      Image.asset('assets/icons/location.png',
                          fit: BoxFit.cover, width: 40)
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
                            'AHAMED',
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
                      builder: (context) => CheckAvailability()));
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
}
