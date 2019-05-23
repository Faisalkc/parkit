import 'package:flutter/material.dart';
import 'package:parkit/model/available_model.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/spot_date_model.dart';
import 'package:parkit/resources/repository.dart';
import 'package:flutter/cupertino.dart';

class AddAvailability extends StatefulWidget {
  @override
  _AddAvailabilityState createState() => _AddAvailabilityState();
}

class _AddAvailabilityState extends State<AddAvailability> {
  double parkingfee;
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
    parkingfee=1;
   _selectedFromTime = TimeOfDay(hour: 0, minute: 00);
    _selectedToTimie = TimeOfDay(hour: 23, minute: 00);
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
                      Padding(
                        child: InkResponse(child: Text('${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',),onTap: (){ _selectDate(context);}),
                        padding: EdgeInsets.only(left: 20,top: 10),
                      )
                    ],
                  ),
                  minimunPadding(),
                  Divider(),
                   Align(child:   Text("Select Time".toUpperCase(),style: _subHeaderText,),alignment: Alignment.topLeft,),
                   Row(
                    children: <Widget>[
                      Padding(
                        child: InkResponse(
                        child: Text('From : ${_selectedFromTime.hour}:${_selectedFromTime.minute}'),
                        onTap: ()=>_selectFromTime(context),
                      ),
                      padding: EdgeInsets.only(left: 20,top: 10),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        child: InkResponse(
                        child: Text('To : ${_selectedToTimie.hour}:${_selectedToTimie.minute}'),
                        onTap: ()=>_selectToTime(context),
                      ),
                      padding: EdgeInsets.only(left: 20,top: 
                      10),
                      )
                    ],
                  ),
                   minimunPadding(),
                   Divider(),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: <Widget>[
                          
                           Text('\$ $parkingfee',style: TextStyle(color: Colors.blue,fontSize: 25),),
                       Slider(
                         
                     activeColor: Colors.blue,
                     min: 1,
                  divisions: 24,
                     max: 25,
                     value: parkingfee,
                     onChanged: (val)
                     {
                        setState(() {
                          parkingfee=val;
                        });
                     },
                   ),
                   
                         ],
                       )
                     ],
                   ),


                
          ],
        ),
        ),
     
    );
  }
Widget minimunPadding()
{
  return SizedBox(height: 10,);
}
  Future _selectDate(context)  async{
  return   showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              minimumDate: DateTime.now(),
                              minimumYear: DateTime.now().year,
                              onDateTimeChanged: (DateTime newdate) {
                               setState(() {
                                 _selectedDate=newdate;
                               });
                              },
                              minuteInterval: 1,
                              mode: CupertinoDatePickerMode.date,
                            ));
                      });
      

  }

  Future _selectFromTime(context) async {
       return showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              minuteInterval: 60,
                              initialDateTime: DateTime(DateTime.now().year),
                              onDateTimeChanged: (DateTime newdate) {
                               setState(() {
                                 _selectedFromTime=TimeOfDay(hour: newdate.hour,minute: newdate.minute);
                               });
                              },
                             
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: true,
                              
                            ));
                      });
  }

  Future _selectToTime(context) async {
    return showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder) {
                        return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    3,
                            child: CupertinoDatePicker(
                              minuteInterval: 60,
                              initialDateTime: DateTime(DateTime.now().year),
                              onDateTimeChanged: (DateTime newdate) {
                               setState(() {
                                 _selectedToTimie=TimeOfDay(hour: newdate.hour,minute: newdate.minute);
                               });
                              },
                             
                              mode: CupertinoDatePickerMode.time,
                              use24hFormat: true,
                              
                            ));
                      });
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
              height: 50*snapshot.data.length.toDouble(),
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
    repository.makeAvailability(_selectedParkingSpot, AvailableModel.forFirebase(SpotDate('${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}', _selectedFromTime.hour, _selectedToTimie.hour,))).then((onValue){setState(() {
      isloading=false;
      onValue? _scafoldkey.currentState.showSnackBar(SnackBar(content: Text('Your Parking has been Placed'))):_scafoldkey.currentState.showSnackBar(SnackBar(content: Text('Something went wrong'),));
    });});
  }
}
