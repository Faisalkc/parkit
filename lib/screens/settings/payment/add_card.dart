import 'package:flutter/material.dart';
import 'package:parkit/resources/repository.dart';

class AddCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddCardView();
  }
}

class AddCardView extends StatefulWidget {
  @override
  _AddCardViewState createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  GlobalKey<ScaffoldState> _scafold = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController _cardnumber,_cvv,_expiry,zipcode;
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 04),
      lastDate: DateTime(2030)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
       selectedDate = picked; 
      });
    }
  }
  @override
  void initState() {
   _cardnumber=TextEditingController();
   _cvv=TextEditingController();
   _expiry=TextEditingController();
   zipcode=TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafold,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
_scafold.currentState.showSnackBar(SnackBar(content: Text('Please Wait'),));
          await repository.addCCPayment(_cardnumber.text, _cvv.text, _expiry.text);
          _scafold.currentState.removeCurrentSnackBar();
          _scafold.currentState.showSnackBar(SnackBar(content: Text('Done'),));
        },
        child: Icon(Icons.arrow_forward_ios),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Card "),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: <Widget>[
            TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.credit_card), labelText: "Card Number"),onChanged: (acc){

            },controller: _cardnumber,
            keyboardType: TextInputType.number,
            ),
            Row(
              children: <Widget>[
                Flexible(child: TextField(decoration: InputDecoration(hintText: "MM/YY"),onChanged: (mm){

            },controller: _expiry, keyboardType: TextInputType.number,)),
                SizedBox(width: 40),
                Flexible(child: TextField(decoration: InputDecoration(hintText: "CVV"),onChanged: (cvv){

            },controller: _cvv, keyboardType: TextInputType.number,)),
              ],
            ),
            TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.confirmation_number), labelText: "Zip Code"),onChanged: (acc){

            },controller: zipcode, keyboardType: TextInputType.number,),
          ],
        ),
      ),
    );
  }
}
