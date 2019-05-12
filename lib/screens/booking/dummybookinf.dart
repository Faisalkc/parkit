import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:parkit/screens/settings/payment/payment.dart';

class DummyBooking extends StatefulWidget {
  String parkingspotkey;
  DummyBooking({this.parkingspotkey});
  @override
  _DummyBookingState createState() => _DummyBookingState();
}

class _DummyBookingState extends State<DummyBooking> {
  DateTime _selecteddate;
  TimeOfDay _from,to;
  @override
  void initState() {
    _from=to=TimeOfDay(hour: 0,minute: 0);
    _selecteddate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Select a date'),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  datePicker(context);
                },
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  padding: EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  width: 100,
                  child: Text(
                    '${_selecteddate.year}/${_selecteddate.month}/${_selecteddate.day}',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Select From'),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (DateTime newdate) {
                               setState(() {
                                 _from=TimeOfDay(hour: newdate.hour,minute: newdate.minute);
                               });
                              },
                              minuteInterval: 1,
                              mode: CupertinoDatePickerMode.time,
                            ));
                      });
                },
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  padding: EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  width: 100,
                  child: Text(
                    '${_from.hour}:${_from.minute}',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Select Till'),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                      showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              onDateTimeChanged: (DateTime newdate) {
                               setState(() {
                                 to=TimeOfDay(hour: newdate.hour,minute: newdate.minute);
                               });
                              },
                              minuteInterval: 1,
                              mode: CupertinoDatePickerMode.time,
                            ));
                      });
                },
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  padding: EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  width: 100,
                  child: Text('${to.hour}:${to.minute}'),
                ),
              ),
              RaisedButton(
                onPressed: () {
                   
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>PaymentPage()));
                
                },
                child: Text('BookNow'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void datePicker(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime(2020));
    setState(() {
      if (date != null) {
        _selecteddate = date;
      }
    });
  }
}
