import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkit/Firebase/FirebaseUpload.dart';

class ListParkingArea extends StatefulWidget {
  @override
  _ListParkingAreaState createState() => _ListParkingAreaState();
}

class _ListParkingAreaState extends State<ListParkingArea> {
  bool _isLoading;
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  File _image;
  String _datetime = '';
  int _year;

  int _month;
  int _date;

  int _hhfrom;
  int _mmfrom;
  int _hhTo;
  int _mmTo;
  bool _Reapted;
  String _lang = 'en';
  String _format = 'yyyy-mm-dd';
  bool _showTitleActions = true;

  @override
  void initState() {
    _isLoading = false;
    _Reapted = false;
    DateTime now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _date = now.day;
    _hhfrom = now.hour;
    _mmfrom = now.minute;
    int _hhTo = now.hour;
    int _mmTo = now.minute;
    super.initState();
  }

  /// Display date picker.
  void _showDatePicker() {
    final bool showTitleActions = false;
    DatePicker.showDatePicker(
      context,
      showTitleActions: _showTitleActions,
      minYear: _year,
      maxYear: _year + 1,
      initialYear: _year,
      initialMonth: _month,
      initialDate: _date,
      locale: _lang,
      dateFormat: _format,
      onChanged: (year, month, date) {
        debugPrint('onChanged date: $year-$month-$date');

        if (!showTitleActions) {
          _changeDatetime(year, month, date);
        }
      },
      onConfirm: (year, month, date) {
        _changeDatetime(year, month, date);
      },
    );
  }

  void _changeDatetime(int year, int month, int date) {
    setState(() {
      _year = year;
      _month = month;
      _date = date;
      _datetime = '$year-$month-$date';
    });
  }

  TextStyle _textStyle = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldKey,
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.all(25),
                child: Form(
                  key: _formState,
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "List Your Parcking Space",
                        style: TextStyle(fontSize: 29),
                      ),
                      minimumPadding(),
                      Text(
                        "Parking Name",
                        style: _textStyle,
                      ),
                      minimumPadding(),
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Type parking name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                      sectionDivider(),
                      Text(
                        'Availability',
                        style: _textStyle,
                      ),
                      minimumPadding(),
                      Container(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date:   ',
                              style: _textStyle,
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 2, color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkResponse(
                                onTap: () {
                                  _showDatePicker();
                                },
                                child: Text(
                                  _year.toString() +
                                      ' ' +
                                      _month.toString() +
                                      ' ' +
                                      _date.toString(),
                                  style: _textStyle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      minimumPadding(),
                      Container(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Time:   ',
                              style: _textStyle,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'From',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black12),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkResponse(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height /
                                                    3,
                                                child: fromTime());
                                          });
                                    },
                                    child: Text(
                                      _hhfrom.toString() +
                                          ' : ' +
                                          _mmfrom.toString(),
                                      style: _textStyle,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'To',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black12),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: InkResponse(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                                height: MediaQuery.of(context)
                                                        .copyWith()
                                                        .size
                                                        .height /
                                                    3,
                                                child: toTime());
                                          });
                                    },
                                    child: Text(
                                      _hhTo.toString() +
                                          ' : ' +
                                          _mmTo.toString(),
                                      style: _textStyle,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text("Reapet"),
                          Checkbox(
                            onChanged: (val) {
                              if (!val) {
                                setState(() {
                                  _Reapted = false;
                                });
                              } else {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext builder) {
                                      return Container(
                                          height: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height /
                                              3,
                                          child: toRepeat());
                                    });
                              }
                            },
                            value: _Reapted,
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: Text(
                          'Location',
                        ),
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.my_location),
                              Text('Choose my location')
                            ],
                          ),
                          minimumPadding(),
                          minimumPadding(),
                          Row(
                            children: <Widget>[
                              Icon(Icons.my_location),
                              Text('Manualy Locate')
                            ],
                          ),
                          minimumPadding(),
                          minimumPadding(),
                        ],
                      ),
                      sectionDivider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      spreadRadius: 2)
                                ]),
                            width: 70,
                            height: 70,
                            child: _image == null
                                ? InkResponse(
                                    child: Center(
                                      child: Icon(Icons.camera_alt),
                                    ),
                                    onTap: () {
                                      getImage();
                                    },
                                  )
                                : Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      spreadRadius: 2)
                                ]),
                            width: 70,
                            height: 70,
                            child: _image == null
                                ? InkResponse(
                                    child: Center(
                                      child: Icon(Icons.camera_alt),
                                    ),
                                    onTap: () {
                                      getImage();
                                    },
                                  )
                                : Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 1,
                                      spreadRadius: 2)
                                ]),
                            width: 70,
                            height: 70,
                            child: _image == null
                                ? InkResponse(
                                    child: Center(
                                      child: Icon(Icons.camera_alt),
                                    ),
                                    onTap: () {
                                      getImage();
                                    },
                                  )
                                : Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                          )
                        ],
                      ),
                      sectionDivider(),
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Details/Remarks',
                            border: OutlineInputBorder()),
                      ),
                      minimumPadding(),
                      Center(
                        child: Container(
                          width: 100,
                          child: RaisedButton(
                            onPressed: () {
                              createASpot();
                            },
                            child: Text('Create'),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
      ),
    );
  }

  Widget minimumPadding() {
    return SizedBox(
      height: 10,
    );
  }

  Widget sectionDivider() {
    return SizedBox(
      height: 40,
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

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

  Future<void> createASpot() async {
    if (validation()) {
      startLoading();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final StorageReference firebaseStorageRef = await FirebaseStorage.instance
          .ref()
          .child(
              '${user.email}/parkingspot/${DateTime.now().toString()}_parkingSpot.jpg');
      final StorageUploadTask task = firebaseStorageRef.putFile(_image);
      await task.onComplete.then((va) {
        _scafoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Completed')));
        stopLoading();
      }).catchError((e) {
        _scafoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Something went wrong')));
        stopLoading();
      });

      FirebaseUpload().createParkingspot();
    } else {
      _scafoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Please select an Image')));
    }
  }

  bool validation() {
    if (_image != null) {
      return true;
    }
    return false;
  }

  Widget fromTime() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      minuteInterval: 30,
      use24hFormat: false,
      initialDateTime: DateTime(
        _year,
        _month,
      ),
      onDateTimeChanged: (changedtimer) {
        setState(() {
          _hhfrom = changedtimer.hour;
          _mmfrom = changedtimer.minute;
        });
      },
    );
  }

  Widget toTime() {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      minuteInterval: 30,
      use24hFormat: false,
      initialDateTime: DateTime(
        _year,
        _month,
      ),
      onDateTimeChanged: (changedtimer) {
        setState(() {
          _hhTo = changedtimer.hour;
          _mmTo = changedtimer.minute;
        });
      },
    );
  }

  Widget toRepeat() {
    return CupertinoPicker(
      onSelectedItemChanged: (int) {
        setState(() {
          _Reapted = true;
        });
      },
      itemExtent: 30,
      backgroundColor: Colors.white,
      looping: true,
      children: <Widget>[
        Center(
          child: Text('Every Saturday'),
        ),
        Center(
          child: Text('Every Sunday'),
        ),
        Center(
          child: Text('Every Monday'),
        ),
        Center(
          child: Text('Every Tuesday'),
        ),
        Center(
          child: Text('Every Wednesday'),
        ),
        Center(
          child: Text('Every Thursday'),
        ),
        Center(
          child: Text('Every Friday'),
        ),
        Center(
          child: Text('Everyday'),
        ),
      ],
    );
  }
}
