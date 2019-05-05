import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkit/model/user_model.dart';
import 'package:parkit/screens/auth/ProfilePage.dart';
import 'package:parkit/screens/auth/otp_page.dart';

class IncompleteStepts extends StatefulWidget {
  AsyncSnapshot<UserModel> snapshot;
  IncompleteStepts({this.snapshot});
  @override
  _IncompleteSteptsState createState() => _IncompleteSteptsState();
}

class _IncompleteSteptsState extends State<IncompleteStepts> {
  TextStyle _heading = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  TextStyle _subHeating = TextStyle();
  bool _emailCon=false;
  bool _mobCon=false;String mobNum;
  Widget emailConfirmation()
  {
    return _emailCon? ListTile(
      title: Text(
       widget.snapshot.data.email
      ),
      trailing: RaisedButton(onPressed: (){
        FirebaseAuth.instance.currentUser().then((user)=>user.sendEmailVerification());
      },child: Text('Send',style: TextStyle(color: Colors.white  ),),color: Colors.green,),
    ):Container();
  }
    Widget mobileConfirmation()
  {
    return _mobCon? ListTile(
      title: TextField(
        onChanged: (mobile)
        {
            setState(() {
              mobNum=mobile;
            });
        },
      decoration: InputDecoration(hintText: 'eg: +971 00000'),
       keyboardType: TextInputType.phone,
      ),
      trailing: RaisedButton(onPressed: (){
        if (mobNum!=null) 
        {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>OtpPage(phoneNumber: mobNum,)));
        }
      },child: Text('Send',style: TextStyle(color: Colors.white  ),),color: Colors.green,),
    ):Container();
  }
  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      child: Text(
                        'What\'s left',
                        style: _heading,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                   !widget.snapshot.data.isVerified? ListTile(
                      title: Text(
                        'Email Confirmation',
                        style: _subHeating,
                      ),
                      onTap: () {
                        setState(() {
                          _emailCon=!_emailCon;
                        });
                      },
                      trailing: _emailCon?RotatedBox(child: Icon(Icons.arrow_forward_ios),quarterTurns: 45,):Icon(Icons.arrow_forward_ios),
                    ):Container(  ),
                    emailConfirmation(),
                    !widget.snapshot.data.isVerified?Divider():Container(),
                    widget.snapshot.data.mobile==null?ListTile(
                      
                      title: Text(
                        'Mobile Confirmation',
                        style: _subHeating,
                      ),
                      onTap: () {
                        setState(() {
                          _mobCon=!_mobCon;
                        });
                      },
                      trailing: Icon(Icons.arrow_forward_ios),
                    ):Container(),
                    mobileConfirmation(),
                    widget.snapshot.data.mobile==null?Divider():Container(),
                    
                    ListTile(
                      title: Text(
                        'Payment Method',
                        style: _subHeating,
                      ),
                      onTap: () {},
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                    Divider(),
                    widget.snapshot.data.photoUrl==null?ListTile(
                      subtitle: Text('Optional'),
                      title: Text(
                        'Profile Photo',
                        style: _subHeating,
                      ),
                      onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProfilePage(
                                                      snapshot: widget
                                                          .snapshot)));
                                    },
                      trailing: Icon(Icons.arrow_forward_ios),
                    ):Container(),
                    widget.snapshot.data.photoUrl==null?Divider():Container(),  

                    SizedBox(
                      height: 20,
                    ),

                     Align(
                      child: Text(
                        'Completed',
                        style: _heading,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                   widget.snapshot.data.isVerified? ListTile(
                      title: Text(
                        'Email Confirmation',
                        style: _subHeating,
                      ),
                      
                      trailing: Icon(Icons.mail),
                    ):Container(  ),
                    widget.snapshot.data.isVerified?Divider():Container(),
                    widget.snapshot.data.mobile!=null?ListTile(
                      
                      title: Text(
                        'Mobile Confirmation',
                        style: _subHeating,
                      ),
                      trailing: Icon(Icons.phone),
                    ):Container(),
                   
                    widget.snapshot.data.mobile!=null?Divider():Container(),
                    
                    ListTile(
                      title: Text(
                        'Payment Method',
                        style: _subHeating,
                      ),
                      trailing: Icon(Icons.credit_card),
                    ),
                    Divider(),
                    widget.snapshot.data.photoUrl!=null?ListTile(
                      subtitle: Text('Optional'),
                      title: Text(
                        'Profile Photo',
                        style: _subHeating,
                      ),

                      trailing: Icon(Icons.account_circle),
                    ):Container(),
                    widget.snapshot.data.photoUrl!=null?Divider():Container(),  

                    SizedBox(
                      height: 20,
                    ),

                    Text('*Please complete all the steps to list a parking')
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
