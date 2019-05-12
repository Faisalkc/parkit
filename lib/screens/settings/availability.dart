import 'package:flutter/material.dart';
import 'package:parkit/model/available_model.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/spot_date_model.dart';
import 'package:parkit/resources/repository.dart';

class AddAvailability extends StatefulWidget {
  @override
  _AddAvailabilityState createState() => _AddAvailabilityState();
}

class _AddAvailabilityState extends State<AddAvailability> {
  bool isloading=false;
  DateTime _selectedDate;
  String _selectedParkingSpot;
  TimeOfDay _selectedFromTime, _selectedToTimie;
  TextStyle _headerText=TextStyle(fontSize: 20,fontWeight: FontWeight.bold);
  TextStyle _subHeaderText=TextStyle(fontSize: 15,fontWeight: FontWeight.bold);
  TextStyle _hintText=TextStyle(fontSize: 9,fontWeight: FontWeight.bold);
  GlobalKey<ScaffoldState> _scafoldkey=GlobalKey<ScaffoldState>();
  @override
  void initState() {
   _selectedFromTime = TimeOfDay(hour: 0, minute: 01);
    _selectedToTimie = TimeOfDay(hour: 23, minute: 59);
    _selectedDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldkey,
    bottomNavigationBar: BottomAppBar(
      color: Colors.green,
      child:InkResponse(
        child:  Container(
        height: 40  ,
        child: Center(
        child:
          isloading?Text('Please Wait....',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),): Text('Place Your Parking',style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
       
      ),
      ),
        onTap: (){
            _selectedParkingSpot!=null?
            addAvailabliliy()
            :_scafoldkey.currentState.showSnackBar(SnackBar(content: Text('Please Select a parking spot'),));
          }
      ) 
     ,
    ),
      body
      : Container(
        padding: EdgeInsets.all(10),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            scrollDirection: Axis.vertical,
          children: <Widget>[
             Align(child:InkResponse(child: Icon(Icons.arrow_back_ios),onTap: ()=>Navigator.of(context).pop(false),),alignment: Alignment.topLeft,),
            
              Align(child:   Text("Add Availability".toUpperCase(),style: _headerText,),alignment: Alignment.center,),
               minimunPadding(),
               Align(child:   Text("Select Your Parking Spot".toUpperCase(),style: _subHeaderText,),alignment: Alignment.topLeft,),
                 Align(child:   Text("*only your verfied parking will be available here".toUpperCase(),style: _hintText,),alignment: Alignment.topLeft,),
  available(),
minimunPadding(),
                 Divider(),
                  Align(child:   Text("Select Date".toUpperCase(),style: _subHeaderText,),alignment: Alignment.topLeft,),
                  Row(
                    children: <Widget>[
                      InkResponse(child: Text('${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}'),onTap: (){ _selectDate(context);}),
                    ],
                  ),
                  minimunPadding(),
                  Divider(),
                   Align(child:   Text("Select Time".toUpperCase(),style: _subHeaderText,),alignment: Alignment.topLeft,),
                   Row(
                    children: <Widget>[
                      InkResponse(
                        child: Text('From : ${_selectedFromTime.hour}:${_selectedFromTime.minute}'),
                        onTap: ()=>_selectFromTime(context),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      InkResponse(
                        child: Text('To : ${_selectedToTimie.hour}:${_selectedToTimie.minute}'),
                        onTap: ()=>_selectToTime(context),
                      )
                    ],
                  ),
                   minimunPadding(),
                   Divider(),


                
          ],
        ),
        ),
     
    );
  }
Widget minimunPadding()
{
  return SizedBox(height: 10,);
}
  Future _selectDate(context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
        firstDate: DateTime.now(),
        lastDate: new DateTime(DateTime.now().year + 1));
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future _selectFromTime(context) async {
    TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _selectedFromTime);
    if (picked != null) setState(() => _selectedFromTime = picked);
  }

  Future _selectToTime(context) async {
    TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _selectedToTimie);
    if (picked != null) setState(() => _selectedToTimie = picked);
  }
  Widget available()
  {
    return  FutureBuilder(
        future: repository.getMyParkingList(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, ParkingModel>> snapshot) {
          if (snapshot.hasData) {
            Map<String, ParkingModel> mylist = snapshot.data;
            return  Container(
              height: 90,
              child: ListView.builder(
           
              itemCount: mylist.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Row(
            
                    children: <Widget>[
                      Radio(

                    onChanged: (o){
                      setState(() {
                        _selectedParkingSpot=o.toString();
                      });
                    },
                    groupValue: _selectedParkingSpot,
                    value: mylist.keys.toList()[index],
                   
                  
                  ),Text(mylist.values.toList()[index].spotname)
                    ],
                  ),
                );
              },
            ),
            );
          } else if (snapshot.hasError) {
            return Text('No record found');
          }
          return Container(
              padding: EdgeInsets.all(20.0),
              child: Center(child: CircularProgressIndicator()));
        },
      );
  }
  void addAvailabliliy()
  {
    setState(() {
      isloading=true;
    });
    repository.makeAvailability(_selectedParkingSpot, AvailableModel.forFirebase(SpotDate('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}', _selectedFromTime.hour, _selectedFromTime.minute, _selectedToTimie.hour, _selectedToTimie.minute))).then((onValue){setState(() {
      isloading=false;
      _scafoldkey.currentState.showSnackBar(SnackBar(content: Text('Your Parking has been Placed'),));
    });});
  }
}
