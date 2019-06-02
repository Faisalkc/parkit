import 'package:flutter/material.dart';
import 'package:parkit/Bloc/myfavlist_bloc.dart';
import 'package:parkit/Widget/customBottomNavigation.dart';
import 'package:parkit/model/favorites.dart';
import 'package:parkit/screens/booking/available_times.dart';
import 'package:parkit/screens/parkingspotDetails.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  
  @override
  void initState() {
     myfavlistbloc.myfavlistbloc(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: bottomAppBar(context,1),
      body: favlist(),
    );
  }

  Widget favlist() {
   
    return StreamBuilder(
      stream: myfavlistbloc.fetcher,
      builder: (BuildContext context, AsyncSnapshot<FavoritesModel> snapshot) {
        if (snapshot.hasData) {
          if (FavoritesModel.favlistavailable.length > 0) {
            return Container(
              child: ListView.builder(
                itemCount: FavoritesModel.favlistavailable.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildApartmentList(context, index);
                },
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Container(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text(snapshot.error)));
        }

        return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: Hero(
              tag: 'spotimage',
              child: CircularProgressIndicator(),
            )));
      },
    );
  }

  Row buildApartmentList(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          
          children: <Widget>[
            Container(

              margin: EdgeInsets.only(top: 8,),
              width: 20,
              height: 20,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
            ),
            Container(
              width: 2,
              height: MediaQuery.of(context).size.height * 0.46,
              margin: EdgeInsets.only(top: 8,),
              color: Colors.grey,
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  FavoritesModel.favlistavailable[index].spotname,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              // Container(
              //   child: Text(
              //     '10 days ago 8-9 Nov',
              //     style: TextStyle(
              //         fontSize: 17,
              //         color: Colors.grey,
              //         fontWeight: FontWeight.w600),
              //   ),
              // ),
              SizedBox(
                height: 18,
              ),
              Material(
                elevation: 4.0,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 350,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Hero(
                                child: GestureDetector(
                                  child: Image(
                                    height: 250,
                                    width: double.infinity,
                                    image: NetworkImage(FavoritesModel
                                        .favlistavailable[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ParkingSpotDetails(parkingSpotKey: FavoritesModel.favlistavailable[index].parkingKey,))),
                                ),
                                tag: 'spotimage',
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 10, bottom: 6),
                              child: Text(
                                FavoritesModel.favlistavailable[index].desc,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () =>Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>ShowtimeDateSelector(parkingspotkey: FavoritesModel.favlistavailable[index].parkingKey))),
                                  child: Wrap(
                                    spacing: 4,
                                    children: <Widget>[
                                      Text(
                                        'Book Now',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Icon(Icons.arrow_forward_ios)
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {},
                                  child: Wrap(
                                    spacing: 4,
                                    children: <Widget>[
                                      Text(
                                        'Feedback',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Icon(Icons.feedback)
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
