import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    
    itemCount: 2,
    itemBuilder: (BuildContext context,int index)
    {
      return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('a', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Text('a', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.green),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('a', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
                      Text('aa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
                    ],
                  )
                ],
              ),
            );
    },
  );
  }
}