import 'package:flutter/material.dart';
import 'package:parkit/Bloc/balance_bloc.dart';
import 'package:parkit/model/history_model.dart';

class RecentTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return RecentTransactionsView();
  }
}

class RecentTransactionsView extends StatefulWidget {
  @override
  _RecentTransactionsViewState createState() => _RecentTransactionsViewState();
}

class _RecentTransactionsViewState extends State<RecentTransactionsView> {
  double _balance;
  @override
  void initState() {

    _balance=0.0;
    History().getCurrentBalance().then((amount)=>setState((){
      _balance=amount;
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),  
          backgroundColor: Colors.black,
          title: Text("Activity"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {},
              color: Colors.white,
            )
          ],
        ),
        body: RefreshIndicator(
         
          onRefresh:  (){
            return Future.delayed(Duration(seconds: 2));
          },
          child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Your Balance",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '\$$_balance',
                      style: TextStyle(
                        fontSize: 34,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                     
                      },
                      child: Container(
                          width: double.infinity,
                          height: 60,
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: FractionalOffset.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(4.0)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.attach_money,
                                color: Colors.white,
                                size: 40,
                              ),
                              Text('ADD CASH',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24)),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "pull down for updates",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
              color: Colors.black12,
              child: Text(
                "History",
                style: TextStyle(fontSize: 18, color: Colors.black38),
              ),
            ),
             recendTransations()
            
           
            
          ],
        ),
        ));
  }
  Widget recendTransations()
  {
    transactions.getmyBal();
    return StreamBuilder(
stream: transactions.location,

builder: (BuildContext context,AsyncSnapshot<Transaction> snapshot)
{
  if (snapshot.data.transactions.length>0) {
    
  return  buildContent( snapshot, context);
  }
  else return
  SizedBox();
  
},
    );
  }
    Widget buildContent(AsyncSnapshot<Transaction> snapshot, BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
        var height= MediaQuery
        .of(context)
        .size.height;
        print(height);
    return Container(
      
      height: height,
      margin: EdgeInsets.only(bottom: 10, top: 20),
      child: ListView.builder(
        scrollDirection: Axis.vertical  ,
        itemCount: snapshot.data.transactions.length ,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
             
            
              },
              child: _buildItem(snapshot.data.transactions[index])
          );
        },
      ),
    );
  }

  _buildItem(History snapshot) {
    return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(snapshot.gettxnMethod(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      Text(snapshot.txnAmount.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.green),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(snapshot.gettnxType(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
                      Text(snapshot.gettxnStatus()??'', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
                    ],
                  )
                ],
              ),
            ) ;
  }

}