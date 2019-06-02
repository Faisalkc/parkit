import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:parkit/model/balance_model.dart';
import 'package:parkit/model/booking_model.dart';
import 'package:parkit/model/history_model.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/payment_model.dart';
import 'package:parkit/resources/repository.dart';
import 'package:parkit/screens/settings/payment/add_payment_method.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:parkit/Bloc/mybalance_bloc.dart';

class BookingConfirmations extends StatefulWidget {
  ParkingModel parkingkey;
  String onDate;
  List<String> slot;
  int price;
  BookingConfirmations(this.parkingkey, this.onDate, this.slot, this.price);
  @override
  _BookingConfirmationsState createState() => _BookingConfirmationsState();
}

class _BookingConfirmationsState extends State<BookingConfirmations> {
Map<int,int> _slotlist;
    List<PaymentModel> _paymentList=[];
  TextStyle _headingStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  TextStyle _subheadingStyle = TextStyle(fontSize: 12);
  GlobalKey<ScaffoldState> _scafold = GlobalKey<ScaffoldState>();
@override
void initState() {
_slotlist={};
if(widget.slot.length>1)
{
  for (var i = 0; i < widget.slot.length; i++) {
    int duration=0;
    while(int.parse(widget.slot[i])+duration==int.parse(widget.slot[i+duration]))
    {
      duration++;
      if(i+duration>=widget.slot.length)
      {
        break;
      }
    }
  _slotlist.addAll({int.parse(widget.slot[i]):duration});
  i+=duration-1;
  }
}
else if(widget.slot.length>0  )
{
   _slotlist.addAll({int.parse(widget.slot[0]):1});
}

   repository.getMyPaymentMethods().then((myPayment){
      setState(() {
        _paymentList=myPayment;
      });
    } );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mybalancebloc. getmybalance();
    return Scaffold(
      key: _scafold,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.hardEdge,
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: Colors.white,
          child: InkWell(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.green,
                ),
                height: 35,
                width: MediaQuery.of(context).size.width * .70,
                child: Center(
                  child: Text(
                    'Request to book',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            onTap: () async {
              _scafold.currentState.showSnackBar(SnackBar(
                content: Text('Please Wait'),
                duration: Duration(seconds: 2),
              ));
              BookingModel mybooking = await repository.bookaSlot(
                widget.parkingkey.parkingkey,
                widget.onDate,
                widget.slot,
              );
              switch (mybooking.bookingstatus) {
                case true:
                  _onSuccess(context);
                  break;
                case false:
                  _onFail(context, mybooking);
                  break;
                default:
              }
            },
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          ListTile(
            title: Text(widget.parkingkey.spotname),
            subtitle: Text(widget.parkingkey.location.city),
            trailing: CachedNetworkImage(
              imageUrl: widget.parkingkey.image[0],
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Padding(
                child: Text(
                  'Booking Details',
                  style: _headingStyle,
                ),
                padding: EdgeInsets.only(left: 15, top: 8),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                child: Text(
                  'Date: ${widget.onDate}',
                  style: TextStyle(color: Colors.red),
                ),
                padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
              ),
            ],
          ),
          Padding(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _slotlist.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: <Widget>[
                    Text(
                      getTiming(_slotlist.keys.toList()[index],_slotlist.values.toList()[index]),
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                );
              },
            ),
            padding: EdgeInsets.only(left: 15),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                child: Text(
                  'Price/hour',
                  style: _subheadingStyle,
                ),
                padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
              ),
              Padding(
                child: Text(
                  '\$${widget.price}',
                  style: _subheadingStyle,
                ),
                padding: EdgeInsets.only(right: 15, top: 8),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                child: Text(
                  'Hours',
                  style: _subheadingStyle,
                ),
                padding: EdgeInsets.only(
                  left: 15,
                  top: 1,
                ),
              ),
              Padding(
                child: Text(
                  '${widget.slot.length}',
                  style: _subheadingStyle,
                ),
                padding: EdgeInsets.only(right: 15, top: 1),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                child: Text(
                  'Total',
                  style: _headingStyle,
                ),
                padding: EdgeInsets.only(left: 15, top: 8),
              ),
              Padding(
                child: Text(
                  '\$${widget.slot.length * widget.price}',
                  style: _headingStyle,
                ),
                padding: EdgeInsets.only(right: 15, top: 8),
              )
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                child: Text('Wallet'),
                padding: EdgeInsets.only(left: 15, top: 8),
              ),
              Padding(
                child: StreamBuilder(
                  
                  stream: mybalancebloc.mybalance,
                  builder: (context, AsyncSnapshot<Balance> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.mainbalance.toString());
                    } else if (snapshot.hasError) {
                      return Text(snapshot.data.mainbalance.toString());
                    }
                    return Container(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()));
                  },
                ),
                padding: EdgeInsets.only(right: 15, top: 8,bottom: 8),
              ),
             
            ],
          ),
          Divider(),
         GestureDetector(
           child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top: 10,left: 15,bottom: 10),
               child: Row(
               children: <Widget>[
                 Icon(Icons.add_box),
                 SizedBox(width: 5,),
                 Text('Add Payment Method')
               ],
             ),
             ),
             
           ],
         ),
         onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>AddPaymentMethodPage())),
         ),
         Padding(
           padding: EdgeInsets.only(left: 15),
           child: availablePaymentMethods(),
         ),
         Divider(),
         GestureDetector(
           child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top: 10,left: 15,bottom: 10),
               child: Row(
               children: <Widget>[
                 Icon(Icons.card_giftcard ),
                 SizedBox(width: 5,),
                 Text('Add Coupon')
               ],
             ),
             ),
             Icon(Icons.arrow_forward_ios)
           ],
         ),
         onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>AddPaymentMethodPage())),
         ),
         Divider(),
       Row(
         children: <Widget>[
            Expanded(
               
               child: Padding(
                 padding: EdgeInsets.all(10),
                 child: Text('A Terms and Conditions agreement or a Privacy Policy are legally binding agreements between you (the company, the mobile app developer, the website owner, the e-commerce store owner etc.) and users using your website, mobile app, Facebook app etc.'),
               ),
             )
         ],
       )
        ],
      ),
    );
  }

  String getTiming(int fromtime,int duration) {
    return fromtime == 12
        ? '12:00 pm to ${fromtime+duration-12} pm'
        : fromtime > 12
            ? '${fromtime - 12}:00 pm to ${fromtime - 11+duration}:00 pm'
            : fromtime == 11
                ? '$fromtime:00 am to ${duration==1?fromtime +1:fromtime+duration-12}:00 pm'
                : '$fromtime:00 am to ${fromtime + duration}:00 am';
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
            "Balance",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();

            Navigator.of(context).pushNamed('/recent_transations');

          } ,
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
          onPressed: () {
            Navigator.of(context).pop();

            Navigator.of(context).pushNamed('/recent_transations');

          } ,
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
    Widget availablePaymentMethods()
  {
    return Container(
      height: _paymentList.length*30.0,
      child: ListView.builder(
      itemCount: _paymentList.length,
      itemExtent: 30,
      itemBuilder:( BuildContext context,int index)

      {
        switch (_paymentList.toList()[index].type) {
          case paymentMethods.Bank:
          return  Row(
              children: <Widget>[
                Icon(Icons.account_balance),
                SizedBox(
                  width: 10,
                ),
                Text(_paymentList.toList()[index].name),
                Spacer(),
                Text(_paymentList.toList()[index].number),
                SizedBox(width: 20,)
              ],
            );
            
            break;
            case paymentMethods.Paypal:
          return  Row(
              children: <Widget>[
                Icon(Icons.payment),
                SizedBox(
                  width: 10,
                ),
                Text(_paymentList.toList()[index].name),
                Spacer(),
                Text(_paymentList.toList()[index].number),
                SizedBox(width: 20,)
              ],
            );
            
            break;
            case paymentMethods.CreditCard:
          return  Row(
              children: <Widget>[
                Icon(Icons.credit_card),
                SizedBox(
                  width: 10,
                ),
                Text(_paymentList.toList()[index].name),
                Spacer(),
                Text(_paymentList.toList()[index].number),
                SizedBox(width: 20,)
              ],
            );
            
            break;
          default:
        }
      }
    ),
    );
}
}
