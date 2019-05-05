import 'package:firebase_database/firebase_database.dart';
import 'package:parkit/parking/Timing.dart';
import 'package:rxdart/rxdart.dart';

class TimingBloc
{
  List<Timing>_listAvailableTiming;
  BehaviorSubject <List<Timing>> _behaviorSubject;
TimingBloc()
{
  _listAvailableTiming=[
    Timing(10,30,false)
  ];
  _behaviorSubject=BehaviorSubject <List<Timing>>.seeded(_listAvailableTiming);
}
  Observable<List<Timing>> get timingObservable=> _behaviorSubject.stream;
   
   void getfromFirebase()async
   {
     await loadfromFirebase();
      var obj=Timing(10,43 ,false);
     _behaviorSubject.sink.add([obj]);
   }
   
   void dispose(){
    _behaviorSubject.close();
  }
  Future loadfromFirebase()async
  {

    final notesReference= FirebaseDatabase.instance.reference().child('parkit').child("-Ld7m-0y9qeo0mDpt30_").child("availability").child("Dates").child("2019-4-23");
    notesReference.once().then((DataSnapshot snapshot)
    {
      _listAvailableTiming.removeRange(0, _listAvailableTiming.length);
       Map<dynamic, dynamic> values = snapshot.value;
         values.forEach((key,val){
            List _splitedtime=key.toString().split(":");

              _listAvailableTiming.add(Timing(int.parse(_splitedtime[0]),int.parse(_splitedtime[1]),true ));
    
       }
         
       );
    }).catchError((onError)=>print(onError));
    _listAvailableTiming.sort((a,b)=>a.from.compareTo(b.from));
  }
}