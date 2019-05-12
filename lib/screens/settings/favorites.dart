import 'package:flutter/material.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/resources/repository.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:favlist(),
    );
  }

    Widget favlist() {
    return FutureBuilder(

      future: repository.getMyFavorites(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, ParkingModel>> snapshot) {
        if (snapshot.hasData) {
          print('length:'+snapshot.data.keys.toString());  
          Map<String, ParkingModel> mylist = snapshot.data;
          return Container(
            child: ListView.builder(
              itemCount: mylist.length,
              itemBuilder: (BuildContext context, int index) {
                return buildApartmentList(context,snapshot,index);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('No record found');
        }
        else
        return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Row buildApartmentList(BuildContext context,
     AsyncSnapshot<Map<String, ParkingModel>> snapshot, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 24,
              height: 24,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
            ),
            Container(
              width: 2,
              height: MediaQuery.of(context).size.height * 0.46,
              margin: EdgeInsets.only(top: 8),
              color: Colors.grey,
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                 snapshot.data.values.toList()[index].spotname,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                child: Text(
                  '10 days ago 8-9 Nov',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                ),
              ),
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
                              child: Image(
                                height: 250,
                                width: double.infinity,
                                image: NetworkImage(
                                    snapshot.data.values.toList()[index].image[0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                'Perfectly located apartment in city\ncenter',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {},
                                  child: Wrap(
                                    spacing: 4,
                                    children: <Widget>[
                                      Text(
                                        'Book Again',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Icon(Icons.replay)
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