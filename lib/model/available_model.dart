import 'package:parkit/model/base_model.dart';
import 'spot_date_model.dart';
import 'package:flutter/material.dart';

class AvailableModel extends BaseModel {
  bool suspended;
  SpotDate soptDates;
  Map<DateTime, List<SpotDate>> availableTiming = {};

  AvailableModel.forFirebase(this.soptDates) {
    this.suspended = false;
  }
  AvailableModel.fromFirebase(dynamic snapshot) {
    final datenow = DateTime.now();
    Map<dynamic, dynamic> _dates = snapshot;
    _dates.forEach((k, v) {
      if (extractDate(k).isAfter(
              DateTime(datenow.year, datenow.month, datenow.day )) 
          ) {
        List<SpotDate> _temp = [];
        Map<dynamic, dynamic> _available = v;
        _available.forEach((timing, avail) {
          try {
            if (avail == true) {
              final time = extractTime(timing.toString());
              SpotDate _s = SpotDate.fromFirebase(time.hour, time.minute);
              _temp.add(_s);
            }
          } catch (e) {}
        });
        availableTiming[extractDate(k)] = _temp;
      }
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
    final splitedDate = date.split(':');
    return TimeOfDay(
        hour: int.parse(splitedDate[0]), minute: int.parse(splitedDate[1]));
  }
}
