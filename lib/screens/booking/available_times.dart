import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:parkit/Bloc/location_bloc.dart';
import 'package:parkit/model/available_model.dart';
import 'package:parkit/model/booking_model.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/spot_date_model.dart';
import 'package:parkit/resources/repository.dart';

import 'booking_confirmations_screen.dart';

class ShowtimeDateSelector extends StatefulWidget {
  String parkingspotkey;
  ShowtimeDateSelector({this.parkingspotkey});
  @override
  _ShowtimeDateSelectorState createState() => _ShowtimeDateSelectorState();
}

class _ShowtimeDateSelectorState extends State<ShowtimeDateSelector> {
  ParkingModel modeldata;
  GlobalKey<ScaffoldState> _scafold = GlobalKey<ScaffoldState>();
  DateTime _selectedDate;
  List<SpotDate> _selectedDates;
  int price;
  @override
  void initState() {
    _selectedDates = [];
    parkitlocationbloc.fetchlocation(widget.parkingspotkey);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafold,
      bottomNavigationBar: new Container(
        decoration: new BoxDecoration(

            //   shape: BoxShape.circle,
            gradient: new LinearGradient(
                colors: [
                  const Color.fromRGBO(57, 181, 74, 1),
                  const Color.fromRGBO(57, 181, 74, 1),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.9, 0.0),
                stops: [0.0, 0.9],
                tileMode: TileMode.clamp)),
        child: new MaterialButton(
          onPressed: _selectedDates.isNotEmpty
              ? () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BookingConfirmations(
                      modeldata,
                    getbookingDate(),
                      getlistOfslots(),price)
                    
                    )) 
              : null,
          child: _selectedDates.isNotEmpty
              ? new Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: new Text('Continue',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600)),
                )
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: new Text('Continue',
                      style: new TextStyle(
                          color: Colors.grey,
                          fontSize: 22.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600)),
                ),
        ),
      ),
      body: StreamBuilder(
        stream: parkitlocationbloc.fetcher,
        builder: (BuildContext context, AsyncSnapshot<ParkingModel> snapshot) {
          final size = MediaQuery.of(context).size;
          if (snapshot.hasData) {
            modeldata = snapshot.data;
     
           
           snapshot.data.availability.availableTiming.keys
                .toList()
                ..sort((a, b) {
                  print(a.compareTo(b));
              return a.day.compareTo(b.day);
            });
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: Text(
                      'Select your Timing',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  availableListOnDate(snapshot.data.availability, size),
                  _selectedDate == null
                      ? Align(
                          child: Center(
                            child: Text('select a date'),
                          ),
                          heightFactor: 20,
                          alignment: Alignment.center,
                        )
                      : availableTiming(snapshot.data.availability, size,
                          _selectedDate, snapshot.data.parkingkey)
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Something went wrong');
          } else
            return Container(
                color: Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  Widget availableListOnDate(AvailableModel _available, Size _size) {
    return Container(
      width: _size.width,
      height: _size.height * .12,
      color: Colors.transparent,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _available.availableTiming.length,
        itemBuilder: (BuildContext context, int index) {
          return dateDisplay(
              _available.availableTiming.keys.toList()[index], _size);
        },
      ),
    );
  }

  Widget availableDates(AvailableModel _available, Size _size) {
    return Container(
      width: _size.width,
      child: ListView.builder(
          itemCount: _available.availableTiming.length,
          itemBuilder: (BuildContext context, int index) {
            return dateDisplay(
                _available.availableTiming.keys.toList()[index], _size);
          }),
    );
  }

  Widget dateDisplay(DateTime date, Size _size) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
            width: 1,
          )),
          color: _selectedDate == DateTime(date.year, date.month, date.day)
              ? Colors.green
              : Colors.white),
      width: _size.width * .25,
      height: _size.height * .08,
      child: InkResponse(
        onTap: () {
          setState(() {
            _selectedDate = DateTime(date.year, date.month, date.day);
          });
        },
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              date.day.toString(),
              style: _selectedDate == DateTime(date.year, date.month, date.day)
                  ? TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 3)
                  : TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 3),
            ),
            Text(
              '${date.month} / ${date.year}',
              style: _selectedDate == DateTime(date.year, date.month, date.day)
                  ? TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 3)
                  : TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 3),
            ),
          ],
        )),
      ),
    );
  }

  Widget priceDisplay(String price) {
    return Container(
        color: Colors.green,
        width: double.infinity,
        child: ListTile(
          title: Text(
            'Price/Hour : \$ ${price}',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget availableTiming(AvailableModel _available, Size _size,
      DateTime _selectedDate, String parkingkey) {

        for (var item in _available.availableTiming[_selectedDate]) {
          if(item.price!=null)
          {
            price=item.price;
            break;
          }
          else
         { price=null;}
        }
    (_available.availableTiming[_selectedDate]).sort((a, b) {
      return a.fromHH.compareTo(b.fromHH);
    });
    try {
      
      return Column(
        children: <Widget>[
          priceDisplay(price!=null?price.toString():'Not available'),
          Container(
            width: _size.width * 0.85,
            height: _size.height * .60,
            // color: Colors.yellow  ,
            child: ListView.builder(
              itemCount:
                  _available.availableTiming[_selectedDate].toList().length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    setState(() {
                      _selectedDates.contains(
                              _available.availableTiming[_selectedDate][index])
                          ? _selectedDates.remove(
                              _available.availableTiming[_selectedDate][index])
                          : _selectedDates.add(
                              _available.availableTiming[_selectedDate][index]);
                    });
                  },
                  title: Text(getTiming(
                      _available.availableTiming[_selectedDate][index].fromHH)),
                  leading: Icon(Icons.local_parking),
                  trailing: !_selectedDates.contains(
                          _available.availableTiming[_selectedDate][index])
                      ? Icon(Icons.check_box_outline_blank)
                      : Icon(
                          Icons.check_box,
                          color: Colors.green,
                        ),
                );
              },
            ),
          )
        ],
      );
    } catch (e) {
      return Center(
        child: Icon(Icons.error),
      );
    }
  }

  String getTiming(int fromtime) {
    return fromtime == 12
        ? '12:00 pm to 1:00 pm'
        : fromtime > 12
            ? '${fromtime - 12}:00 pm to ${fromtime - 11}:00 pm'
            : fromtime == 11
                ? '$fromtime:00 am to ${fromtime + 1}:00 pm'
                : '$fromtime:00 am to ${fromtime + 1}:00 am';
  }

  void _showDialog(
    String parkingkey,
    String onDate,
    List<String> slot,
  ) {
    // flutter defined function
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("You Booking Details"),
          content: Text("Date: $onDate& Time: $slot"),
          actions: <Widget>[
            FlatButton(
                child: new Text("Book Now"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                }),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((onValue) async {
      if (onValue) {
        _scafold.currentState.showSnackBar(SnackBar(
          content: Text('Please Wait'),
          duration: Duration(seconds: 2),
        ));
        BookingModel mybooking = await repository.bookaSlot(
          parkingkey,
          onDate,
          slot,
        );
        switch (mybooking.bookingstatus) {
          case true:
            Navigator.pop(context);
            break;
          case false:
            _onFail(context, mybooking);
            break;
          default:
        }
      }
    });
  }

  List<String> getlistOfslots() {
    List<String> _spotdates = [];
    for (var ondate in _selectedDates) {
      _spotdates.add(ondate.fromHH.toString());
    }
    return _spotdates;
  }

  String getbookingDate() {
    return '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
  }

  _onSuccess(context) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Success",
      desc: "You have booked succesfully",
      buttons: [
        DialogButton(
          child: Text(
            "FLAT",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  _onFail(BuildContext context, BookingModel model) {
    String title = 'Fail', reason = 'Unknown Error';
    switch (model.type) {
      case 'time':
        title = 'Follwoing time is not available now';
        reason = model.reason;
        break;
      case 'balance':
        title = 'Less Balance';
        reason = model.reason;
        break;
      case 'booking':
        title = 'Something went while booking';
        reason = model.reason;
        break;
      default:
        title = 'Fail';
        reason = 'Unknown Error';
    }
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: reason,
      buttons: [
        DialogButton(
          child: Text(
            "Balance",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
}
