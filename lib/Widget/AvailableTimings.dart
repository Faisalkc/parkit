import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parkit/parking/Timing.dart';

class ShowAvailableTiming extends StatefulWidget {
  static List<Timing> selectedtimting = [];
  String onDateAvailability;
  String parkinSpotId;
  ShowAvailableTiming({this.parkinSpotId,this.onDateAvailability});

  @override
  _ShowAvailableTimingState createState() => _ShowAvailableTimingState();
}

class _ShowAvailableTimingState extends State<ShowAvailableTiming> {
 
   List<Timing> timingList = [
     
   ];
  @override
  void initState() {
loadingFirebaseData();
    super.initState();
  }
  Future<bool> loadingFirebaseData()async
  {

    final notesReference= FirebaseDatabase.instance.reference().child('parkit').child(widget.parkinSpotId).child("availability").child("Dates").child(widget.onDateAvailability);
    notesReference.once().then((DataSnapshot snapshot)
    {
      timingList.removeRange(0, timingList.length);
       Map<dynamic, dynamic> values = snapshot.value;
         values.forEach((key,val){
            List _splitedtime=key.toString().split(":");
           setState(() {

              timingList.add(Timing(int.parse(_splitedtime[0]),int.parse(_splitedtime[1]),true ));
           });
    
       }
         
       );
    }).catchError((onError)=>print(onError));
    timingList.sort((a,b)=>a.from.compareTo(b.from));
    return true;
  }
  @override
  Widget build(BuildContext context) {
      return FutureBuilder(
        future: loadingFirebaseData(),
        initialData: CircularProgressIndicator(),
        builder: (BuildContext context,snapshot){
          return
          
           Container(
        height: 30,
        width: double.infinity,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timingList.length,
            itemBuilder: (context, index) {
              return InkResponse(
                onTap: () {
                  if (timingList[index].isAvailable) {
                    ShowAvailableTiming.selectedtimting.add(timingList[index]);
                  } else {
                    ShowAvailableTiming.selectedtimting
                        .remove(timingList[index]);
                  }
                  // setState(() {
                  //   timingList[index].isAvailable =
                  //       !timingList[index].isAvailable;
                  // });
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: timingList[index].isAvailable
                            ? Colors.green
                            : Colors.red),
                    width: 125,
                    height: 10,
                    child: timingList[index].isAvailable
                        ? Center(
                            child: Text(
                              timingList[index].from +
                                  " - " +
                                  timingList[index].to,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              timingList[index].from +
                                  " - " +
                                  timingList[index].to,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                  ),
                ),
              );
            }),
      );
        },
      );
    
  }
}
