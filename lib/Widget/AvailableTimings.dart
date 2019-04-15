import 'package:flutter/material.dart';
import 'package:parkit/parking/Timing.dart';

class ShowAvailableTiming extends StatefulWidget {
  static List<Timing> selectedtimting = [];

  @override
  _ShowAvailableTimingState createState() => _ShowAvailableTimingState();
}

class _ShowAvailableTimingState extends State<ShowAvailableTiming> {
  List<Timing> timingList = [];

  @override
  void initState() {
    timingList.add(Timing(from: '09:00am', to: '9:30am', isAvailable: true));
    timingList.add(Timing(from: '09:30am', to: '10:00am', isAvailable: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (timingList.length > 0) {
      return Container(
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
                  setState(() {
                    timingList[index].isAvailable =
                        !timingList[index].isAvailable;
                  });
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
    } else {
      return Text('Sorry all bookings are filled');
    }
  }
}
