import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 6),
        child: ListView(
          children: <Widget>[
            buildApartmentList(context, 'Zurich', 2),
            buildApartmentList(context, 'Stockholm', 3)
          ],
        ),
      ),
    
    );
  }

  Row buildApartmentList(BuildContext context, cityName, index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black87),
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
                  cityName,
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500),
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
                                image:
                                    NetworkImage('http://clipart-library.com/img/1319788.jpg'),fit: BoxFit.cover,
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
                                   
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: (){},
                                  child: Wrap(
                                    spacing: 4,
                                    children: <Widget>[
                                    Text('Book Again',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                                    Icon(Icons.replay)
                                  ],),
                                ),
                                FlatButton(
                                  onPressed: (){},
                                  child: Wrap(
                                    spacing: 4,
                                    children: <Widget>[
                                      Text('Feedback',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
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
