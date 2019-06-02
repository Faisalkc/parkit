import 'package:parkit/model/base_model.dart';
import 'spot_date_model.dart';
import 'package:flutter/material.dart';

class AvailableModel extends BaseModel {
  double parkingfee ;

  bool suspended;
  SpotDate soptDates;
  Map<DateTime, List<SpotDate>> availableTiming ={};

  AvailableModel.forFirebase(this.soptDates) {
    this.suspended = false;
  }
  AvailableModel.fromFirebase(dynamic snapshot) {
    final datenow = DateTime.now();
    Map<dynamic, dynamic> _dates = snapshot;
    _dates
    ..forEach((k, v) {

      if (extractDate(k).isAfter(
              DateTime(datenow.year, datenow.month, datenow.day-1 )) 
          ) {
            print(v);
        List<SpotDate> _temp = [];
     
        Map<dynamic, dynamic> _available = v;
        _available.forEach((timing, avail) {

          try {
          
            if (avail == true) {
              final time = extractTime(timing.toString());
              SpotDate _s = SpotDate.fromFirebase(time.hour,);
              if(parkingfee!=null)
              {
                _s.price=parkingfee.round();
              }
              _temp.add(_s);
            }
            else if(timing.toString()=='25:00')
            {print('found price' +avail.toString());
            
              parkingfee=double.parse(avail.toString());
              _temp.first.price=parkingfee.round();
             
            }
            
            
          } catch (e) {
            print(e);
          }
        });
        availableTiming[extractDate(k)] = _temp;
      }
      availableTiming.keys.toList().sort((a,b)=> a.compareTo(b));
    });
    
  }
 
  Map<String, dynamic> availabletoJson() {
    return soptDates.availableDates;
  }

  DateTime extractDate(String date) {
    final splitedDate = date.split('-');
    return DateTime(int.parse(splitedDate[0]), int.parse(splitedDate[1]),
        int.parse(splitedDate[2]));
  }

  TimeOfDay extractTime(String date) {
    final data=date.split(':');
    return TimeOfDay(
        hour: int.parse(data[0]), minute : 00);
  }
}
