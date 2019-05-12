import 'package:flutter/material.dart';
import 'package:parkit/model/payment_model.dart';
import 'package:parkit/screens/settings/payment/add_payment_method.dart';
import 'package:parkit/resources/repository.dart';
class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaymentView();
  }
}

class PaymentView extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  List<PaymentModel> _paymentList=[];
  @override
  void initState() {
    repository.getMyPaymentMethods().then((myPayment){
      setState(() {
        _paymentList=myPayment;
      });
    } );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.only(left: 20),
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(vertical: 26),
                child: Text(
                  "Payment Methods",
                  style: TextStyle(color: Colors.grey),
                )),
            
                availablePaymentMethods(),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>AddPaymentMethodPage()));},
                child: Text(
              "Add Payment Method",
              style: TextStyle(color: Colors.blue),
            )),
            Divider(),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Promotions",
                  style: TextStyle(color: Colors.grey),
                )),
            Row(
              children: <Widget>[
                Icon(Icons.card_giftcard),
                SizedBox(
                  width: 10,
                ),
                Text("Rewards"),
                Spacer(),
                Text("1"),
                SizedBox(width: 20,)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {print("Payment Method");},
                child: Text(
              "Add Promo/Gift Code",
              style: TextStyle(color: Colors.blue),
            )),
          ],
        ),
      ),
    );
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