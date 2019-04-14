import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/parking/appdetails.dart';
import 'package:location/location.dart';
import 'package:parkit/parking/MarkersForPaking.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ApplicationDetails.app_name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  static LatLng newLoc = LatLng(37.43296265331129, -122.08832357078792);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),

    zoom: 15.4746,
  );
  static CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: newLoc,
//    tilt: 59.440717697143555,
    zoom: 18.151926040649414,
  );
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
void mainUpdate()
{
  setState(() {

  });
}
  void loc() async {
    LocationData currentLocation;

    var location = new Location();

    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (await location.serviceEnabled()) {
        if (await location.hasPermission()) {
          print('there is an issue');
        } else {
          location.requestPermission();
          print('requensting for permission');
        }
      } else {
        location.requestService();
        location.requestPermission();
        print('requesting for both');
      }
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }

    newLoc = LatLng(currentLocation.latitude, currentLocation.longitude);

    print(" ${currentLocation.latitude} : ${currentLocation.longitude}");
  }



  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
        child: Column(

          children: <Widget>[
            Stack(

              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height,
                    child: GoogleMap(
                      markers: Set<Marker>.of(markers.values),
                      myLocationEnabled: true,

//                    mapType: MapType.hybrid,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      compassEnabled: false,
                    )),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: TextField(

                    keyboardAppearance: Brightness.light,
                    decoration: InputDecoration(
                        enabled: true,
                        suffixIcon: InkResponse(
                          child: Icon(
                            Icons.my_location,
                            color: ApplicationDetails.primaryColor,
                          ),
                          onTap: () async {

                            await loc();
                            markers.addAll(await ParkingMarker().getMarkers(newLoc));
                            await _goToTheLake();

                            mainUpdate();


                          },
                          onDoubleTap: () async {
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'we are near to you',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.yellow,
                                width: 20,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  @override
  void initState() {
  }
}
