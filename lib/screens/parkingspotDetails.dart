import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/Bloc/location_bloc.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/Bloc/customer_bloc.dart';
import 'package:parkit/model/user_model.dart';
import 'package:parkit/resources/repository.dart';
import 'package:parkit/screens/booking/available_times.dart';

class ParkingSpotDetails extends StatefulWidget {
  String parkingSpotKey;
  ParkingSpotDetails({this.parkingSpotKey});
  @override
  _ParkingSpotDetailsState createState() => _ParkingSpotDetailsState();
}

class _ParkingSpotDetailsState extends State<ParkingSpotDetails> {
  GoogleMapController mapController;
  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    parkitlocationbloc.fetchlocation(widget.parkingSpotKey);
    return StreamBuilder(
      stream: parkitlocationbloc.fetcher,
      builder: (BuildContext context, AsyncSnapshot<ParkingModel> snapshot) {
        if (snapshot.hasData) {
          parkitcustomerbloc.getCustomerDetails(snapshot.data.userid);
          return _details(snapshot, size);
        } else if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _details(AsyncSnapshot<ParkingModel> snapshot, Size size) {
    MarkerId markerid = MarkerId('loc');
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{
      markerid:
          Marker(markerId: markerid, position: snapshot.data.location.latLng)
    };
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back)),

              flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    height: 30,
                child: Stack(
                  children: <Widget>[
                    Image.network(
                      snapshot.data.image[0],
                      fit: BoxFit.cover,
                      width: size.width,
                      height: double.infinity,
                      
                    ),
                    Positioned(
                      child: InkResponse(
                        onTap: ()=>repository.addToFavorites(widget.parkingSpotKey,),
                        child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                      ),
                      top: size.height / 5,
                      left: size.width - 40.0,
                    ),
                    Positioned(
                      child: Icon(
                        Icons.comment,
                        color: Colors.white,
                      ),
                      top: size.height / 4,
                      left: size.width - 40.0,
                    ),
                  ],
                ),
              )),

              // Extruding edge from the sliver appbar, may need to fix expanded height
              expandedHeight: MediaQuery.of(context).size.height / 3,
              backgroundColor: const Color.fromRGBO(52, 52, 52, 0.5),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: Text(
                  snapshot.data.spotname,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: StreamBuilder(
                                stream: parkitcustomerbloc.fetcher,
                                builder: (BuildContext context,
                                    AsyncSnapshot<UserModel> _user) {
                                  if (_user.hasData) {
                                    return CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: _user.data.photoUrl !=
                                              null
                                          ? NetworkImage(_user.data.photoUrl)
                                          : AssetImage(
                                              'assets/icons/avatar-defalut.png'),
                                    );
                                  } 
                                  return Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                })),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data.spotname,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Hosted By",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: StreamBuilder(
                                          initialData:
                                              UserModel(displayName: 'loading'),
                                          stream: parkitcustomerbloc.fetcher,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<UserModel>
                                                  _cusData) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                _cusData.data.displayName!=null?_cusData.data.displayName:'Try Again',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                'Please try again',
                                                style: TextStyle(
                                                    color: Color(0xFFFB7592)),
                                              );
                                            }
                                            return Container(
                                                padding: EdgeInsets.all(20.0),
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "See Ratings ",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        snapshot.data.votes.toString(),
                                        style:
                                            TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                              Text(
                                snapshot.data.location.city,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "About this Parking",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              snapshot.data.description != null
                                  ? snapshot.data.description
                                  : '',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Read More....",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "Check in: After 3pm",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 10.0, right: 10.0),
                          child: Text(
                            "Check Out:11am",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 400.0,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: Set<Marker>.of(markers.values),
                        initialCameraPosition: CameraPosition(
                            target: snapshot.data.location.latLng, zoom: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: new Container(
          decoration: new BoxDecoration(
              //   shape: BoxShape.circle,
              gradient: new LinearGradient(
                  colors: [
                    
                    const Color.fromRGBO(57,181,74,1),
                      const Color.fromRGBO(57,181,74,1),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.9, 0.0),
                  stops: [0.0, 0.9],
                  tileMode: TileMode.clamp)),
          child: new MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ShowtimeDateSelector(parkingspotkey: widget.parkingSpotKey,)));
            },
            child: new Padding(
              padding: const EdgeInsets.all(24.0),
              child: new Text("Book Now",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ));
  }
}

