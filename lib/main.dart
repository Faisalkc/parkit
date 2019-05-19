import 'dart:async';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/Widget/customBottomNavigation.dart';
import 'package:location/location.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:parkit/resources/HistoryDB.dart';
import 'package:parkit/screens/auth/user_profile.dart';
import 'package:parkit/screens/listingScreen/Listing.dart';
import 'package:parkit/resources/repository.dart';
import 'package:parkit/screens/settings/favorites.dart';
import 'resources/favoritesDB.dart';
import 'screens/settings/history/earnings_details.dart';
import 'screens/settings/history/promotions.dart';
import 'screens/settings/history/recent_transactions.dart';

void main() {
  
  initializeDateFormatting().then((_) => runApp(MyApp()));
  favoritesDb;
  historyDB;
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parkit',
        routes:
        {
          '/': (context) => MyHomePage(),
          '/ListAPark':(context)=>Listing_page(),
          '/userProfile':(context)=>UserDetails(),
          '/favorites':(context)=>Favorites(),
          '/earnings_details':(context)=>EarningsDetailsPage(),
          '/recent_transations':(context)=>RecentTransactionsPage(),
          '/promotions':(context)=>PromotionsPage(),

        },
        theme: ThemeData(fontFamily: 'Raleway', primarySwatch: Colors.grey),
       );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class _MyHomePageState extends State<MyHomePage> {
   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static LatLng center = const LatLng(-33.86711, 151.1947171);

  GoogleMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  Repository _reposioty=Repository();

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    _goToTheLake();
  }

@override
void initState() {
    loc().then((onValue){
      setState(() {
       center=onValue; 
        checkingforlocatiuon();
        
      });
     });
    super.initState();
      _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      repository.updateFCM(token);
       print(token);
     
    });
  }
  @override
  void dispose() {
    super.dispose();

  }

 Future<void> _goToTheLake() async {
   
   controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: center,zoom: 15)));
 }
void checkingforlocatiuon()async
{
  
   _reposioty.getMarkers(center, context).then((val)=> setState(() {
     markers= <MarkerId, Marker>{};
  val.forEach((k,v)
  {
    markers[k]=v;
  });
  }));

}


  Future<LatLng> loc() async {
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

    setState(() {
     center = LatLng(currentLocation.latitude, currentLocation.longitude); 
    });
    print(currentLocation.latitude.toString() +'' +currentLocation.longitude.toString());
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Icon(Icons.my_location),
        onPressed: ()=>loc().then((val){_goToTheLake();checkingforlocatiuon();}),
      ),
        bottomNavigationBar: bottomAppBar(context,0),
        body: Stack(
               overflow: Overflow.clip,
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height,
                      child: GoogleMap(
                      
                        onMapCreated: _onMapCreated,
                       
                        myLocationButtonEnabled: false,
                        initialCameraPosition:  CameraPosition(
                          target: center,
                          zoom: 11.0,
                        ),
                        markers: Set<Marker>.of(markers.values),
                      )),
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: TextField(
                      keyboardAppearance: Brightness.light,
                      decoration: InputDecoration(
                          enabled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Search',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.yellow,
                                  width: 20,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                ],
              ));
             
  }



  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context,message),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }
  Widget _buildDialog(BuildContext context,Map<String, dynamic> msg) {
    return AlertDialog(
      content: Wrap(
        
        children: <Widget>[
          Row(children: <Widget>[Text(msg['notification']['title']),],),
          Text(msg['notification']['body'],style: TextStyle(fontSize: 13),)
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
  void _navigateToItemDetail(Map<String, dynamic> message) {
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    
  }
}
