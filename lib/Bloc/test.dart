import 'package:flutter/material.dart';
import 'package:parkit/Bloc/TimingBloc.dart';
import 'package:parkit/parking/Timing.dart';
class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  TimingBloc _timingBloc=TimingBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: ()=>_timingBloc.getfromFirebase(),
      ),
      body: ListView(
        children: <Widget>[

          Text('data'),
          StreamBuilder(
        stream: _timingBloc.timingObservable,
        builder: (context, AsyncSnapshot<List<Timing>> snapshot){
          return Text(snapshot.data[0].from);
        },

      )
        ],
      ),
    );
  }
}