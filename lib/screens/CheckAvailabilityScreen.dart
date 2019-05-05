import 'package:flutter/material.dart';
import 'package:parkit/Widget/AvailableTimings.dart';
import 'package:parkit/parking/Timing.dart';
import 'package:parkit/screens/CheckoutScreen.dart';
import 'package:table_calendar/table_calendar.dart';

class CheckAvailability extends StatefulWidget {
  DateTime todaysDate;
  String parkinSpotId;

  CheckAvailability(this.parkinSpotId ) {
    todaysDate = DateTime.now();
  }

  @override
  _CheckAvailabilityState createState() => _CheckAvailabilityState();
}

class _CheckAvailabilityState extends State<CheckAvailability> {
  List<Timing> _availableTiming=[];
  bool _isLoading = true;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool available = false;
  String _selectedDate ;
  Map<DateTime, List> listofEvents = {
  };
  void startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }


  @override
  void initState() {
    DateTime now = DateTime.now();

    _selectedDate="${now.year}-${now.month}-${now.day}";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'CHeck Availability'.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, left: 25),
            child: Text(
              widget.todaysDate.day.toString(),
              style: TextStyle(fontSize: 50),
            ),
          ),
          TableCalendar(
            locale: 'en_US',
            events: listofEvents,
            onDaySelected: (date, List) {
              setState(() {
                _selectedDate = date.year.toString() +
                    '-' +
                    date.month.toString() +
                    '-' +
                    date.day.toString();
                available = true;
              });
            },
          ),
          available
              ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Availabilty on'.toUpperCase(),
                    style: TextStyle(fontSize: 19, letterSpacing: 1),
                  ),
                )
              : Text(''),
          available
              ? Align(
                  alignment: Alignment.center,
                  child: Text(
                    _selectedDate.toUpperCase(),
                    style: TextStyle(fontSize: 19, letterSpacing: 1),
                  ),
                )
              : Text(''),
         ShowAvailableTiming(onDateAvailability: _selectedDate,parkinSpotId: widget.parkinSpotId,),
          RaisedButton(
            onPressed: () {
              ShowAvailableTiming.selectedtimting.length > 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Checkout()))
                  : _globalKey.currentState.showSnackBar(
                      SnackBar(content: Text('Please select any timimng')));
            },
            child: Text('Book Now'),
          )
        ],
      ),
    );
  }
}
