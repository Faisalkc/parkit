import 'package:flutter/material.dart';
import 'package:parkit/Bloc/location_bloc.dart';
import 'package:parkit/model/available_model.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/spot_date_model.dart';
import 'package:parkit/resources/repository.dart';


class ShowtimeDateSelector extends StatefulWidget {
  String parkingspotkey;
  ShowtimeDateSelector({this.parkingspotkey});
  @override
  _ShowtimeDateSelectorState createState() => _ShowtimeDateSelectorState();
}

class _ShowtimeDateSelectorState extends State<ShowtimeDateSelector> {
  GlobalKey<ScaffoldState> _scafold=GlobalKey<ScaffoldState>();
  DateTime _selectedDate;
  List<SpotDate> _selectedDates;
@override
void initState() {
  _selectedDates=[];
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    parkitlocationbloc.fetchlocation(widget.parkingspotkey);
 return Scaffold(
   key: _scafold,
   bottomNavigationBar: BottomAppBar(
     color: Colors.green,
     child: Container(
       child: Center(
         child: _selectedDates.isNotEmpty?Text(_selectedDates.length.toString(),style: TextStyle(color: Colors.white),):Text('Select a slot',style: TextStyle(color: Colors.white),),
       ),
       height: MediaQuery.of(context).size.height*.08,
  
     ),
   ),
   body:     StreamBuilder(

      stream: parkitlocationbloc.fetcher,
      builder: (BuildContext context, AsyncSnapshot<ParkingModel> snapshot) {
        final size=MediaQuery.of(context).size;
        if (snapshot.hasData) {
          print(snapshot.data);
            return SafeArea(  
              child:  Column(
                
              children: <Widget>[
                availableListOnDate(snapshot.data.availability,size),
                _selectedDate==null?Center(child:Text('select a date'),):availableTiming(snapshot.data.availability,size,_selectedDate,snapshot.data.parkingkey)


              ],
            ),
            );
        } 
        else if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        else
         return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()));

      },
    ),
 );
  }
  Widget availableListOnDate(AvailableModel _available,Size _size)
  {
    
    return Container(
      width:_size.width ,
      height: _size.height*.10,
      color: Colors.blue,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _available.availableTiming.length,
        itemBuilder: (BuildContext context,int index)
        {
          return dateDisplay(_available.availableTiming.keys.toList()[index],_size);
        },
      ),
    );
  }

   Widget availableDates(AvailableModel _available,Size _size)
  {
    return Container(
      width:_size.width ,
      child: ListView.builder(
        
        itemCount:_available.availableTiming.length,
        itemBuilder: (BuildContext context,int index)
        {
          return dateDisplay(_available.availableTiming.keys.toList()[index],_size);
        }
        
      ),
    );
  }
  Widget dateDisplay(DateTime date,Size _size)
  {
    return Container(
      decoration: BoxDecoration(border:Border(left: BorderSide(width: 1,)),color: Colors.yellow),
      width:_size.height*.10 ,
      height: _size.height*.08,
  
      child: InkResponse(
        onTap: ()
        {
         setState(() {
            _selectedDate=DateTime(date.year,date.month,date.day);
         });
        },
        child: Center(child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Text(date.day.toString()  ,style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.normal,letterSpacing: 3),),
        Text('${date.month} / ${date.year}' ,style: TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.normal,letterSpacing: 3),),
      ],)),
      ),
    );
  }
  Widget availableTiming(AvailableModel _available,Size _size,DateTime _selectedDate,String parkingkey)
  {
    (_available.availableTiming[_selectedDate]).sort((a,b){
   int val=a.fromHH.compareTo( b.fromHH);
    return val==0? a.fromMM.compareTo(b.fromMM):val;  

    });
    
   try {
      return Container(
      width: _size.width*0.85,
      height: _size.height-_size.height*.18,
      // color: Colors.yellow  ,
      child:ListView.builder(
        itemCount: _available.availableTiming[_selectedDate].toList().length,
        itemBuilder: (BuildContext context,int index)
        {
          return ListTile(
            onTap: (){
              setState(() {
               _selectedDates.add(_available.availableTiming[_selectedDate][index]);
              });
            },
            title: Text('${(_available.availableTiming[_selectedDate])[index].fromHH.toString()} : ${(_available.availableTiming[_selectedDate])[index].fromMM.toString()}'),
            leading: !_selectedDates.contains(_available.availableTiming[_selectedDate][index])?Icon(Icons.local_parking):Icon(Icons.zoom_in),
      trailing: GestureDetector(
        onTap: (){
          _showDialog( parkingkey,'${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}','${(_available.availableTiming[_selectedDate])[index].fromHH.toString()}:${(_available.availableTiming[_selectedDate])[index].fromMM.toString()}');
        },
        child: Text('BookNow'),
      ),
          );
        },
      ),
    );
     
   } catch (e) {
     return Center(child: Icon(Icons.error),);
   }

  }
    void _showDialog(String parkingkey,String onDate,String slot,) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:  Text("You Booking Details"),
          content:  Text("Date: ${onDate}& Time: ${slot}"),
          actions: <Widget>[
            FlatButton(
              child: new Text("Book"),
              onPressed: () async{
               if(await repository.bookaSlot(parkingkey, onDate, slot,))
               {
                 _scafold.currentState.showSnackBar(SnackBar(content: Text('Your booking is done'),duration: Duration(seconds: 2),action: SnackBarAction(onPressed: ()=>_scafold.currentState.hideCurrentSnackBar(),label: 'Close ',),));
                  parkitlocationbloc.fetchlocation(widget.parkingspotkey);
               }
               else
               {
                 _scafold.currentState.showSnackBar(SnackBar(content: Text('Please try another slot it\'s booked'),));
               }
              // await Future.delayed(Duration(seconds: 3),);
                Navigator.of(context).pop(false);
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
