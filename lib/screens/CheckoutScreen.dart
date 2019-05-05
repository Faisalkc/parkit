import 'package:flutter/material.dart';
import 'package:parkit/Widget/AvailableTimings.dart';
import 'package:parkit/parking/Timing.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
            color: Colors.green,
            child: InkResponse(
              onTap: () {
                Alert(
                    context: context,
                    title: "PARK IT",
                    desc: "Your Booking is Confirmed.",
                    type: AlertType.success,
                    buttons: [
                      DialogButton(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(116, 116, 191, 1.0),
                          Color.fromRGBO(52, 138, 199, 1.0)
                        ]),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ]).show();
              },
              child: Container(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'PAY NOW',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )),
        body: ListView(
          shrinkWrap: false,
          children: <Widget>[
            Text('CHECK OUT'),
            Container(
              width: 300,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.credit_card),
                    Form(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: 'CARD NUMBER',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          onEditingComplete: () {},
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'MM',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          onEditingComplete: () {},
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'YY',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          onEditingComplete: () {},
                        ),
                        TextField(
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.numberWithOptions()),
                        TextField(
                            decoration: InputDecoration(
                              labelText: 'Card Holder',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            textInputAction: TextInputAction.done),
                      ],
                    )),
                    Text('Details'.toUpperCase()),
                    Container(
                      width: 300,
                      child: showselectedTiming(),
                    ),
                    Container(
                      width: 300,
                      child: Center(
                        child: Table(
                          defaultColumnWidth: FlexColumnWidth(4.0),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text('PARKING FEE'),
                              ),
                              Center(
                                child: Text('\$10'),
                              )
                            ]),
                            TableRow(children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text('PARKING IT FEE'),
                              ),
                              Center(
                                child: Text('\$2'),
                              )
                            ]),
                            TableRow(children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text('TOTAL FEE'),
                              ),
                              Center(
                                child: Text('\$12'),
                              )
                            ])
                          ],
                        ),
                      ),
                    )
                  ]),
            )
          ],
        ));
  }

  Widget showselectedTiming() {
    List<Timing> timingList = ShowAvailableTiming.selectedtimting;
    return Container(
      width: 155,
      height: 20,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: timingList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 20),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.red,
                  ),
                  width: 125,
                  height: 10,
                  child: Center(
                    child: Text(
                      timingList[index].from + " - " + timingList[index].to,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}
