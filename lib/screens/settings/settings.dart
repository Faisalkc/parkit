import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    _riminderNotifi=true;
    _promoNotifi=true;
    updateSettings();
    super.initState();
  }
void updateSettings()async
{
  SharedPreferences mypref=await SharedPreferences.getInstance();
  setState(() {
    if (mypref.getBool('promotions')!=null) {
       _promoNotifi=mypref.getBool('promotions');
    }
    else{

      _promoNotifi=true;
      promotionNotifications();
    }
    
    
  });
}

  bool _riminderNotifi;
  bool _promoNotifi;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:ListView(
       
       children: <Widget>[
         Padding(
           padding: EdgeInsets.only(left: 10),
           child: Align(child: InkResponse(child: Icon(Icons.arrow_back_ios),onTap: (){Navigator.of(context).pop(false);},),alignment: Alignment.topLeft,),
         ),
         _notofications()
       ],
     )
     ,
    );
  }
  Widget _notofications()
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListTile(
      title: Text('Notifications'),
      dense: true,
    ),
        ListTile(
      title: Text(' Reminders'),
      trailing: CupertinoSwitch(
        // activeColor: Colors.black87,
        value: _riminderNotifi,
        onChanged: (val)
        {
          setState(() {
            _riminderNotifi=val;
          });
        },
      ),
    ) ,
     ListTile(
      title: Text('News & Updates'),
      trailing: CupertinoSwitch(
        // activeColor: Colors.black87,
        value: _promoNotifi,
        onChanged: (val)
        {
          setState(() {
            _promoNotifi=val;
            SharedPreferences.getInstance().then((mypref){mypref.setBool('promotions', val);
            promotionNotifications();
            });
            

          });
        },
      ),
    )
      ],
    );
  }
   void promotionNotifications()async
 {
  SharedPreferences myPref=await SharedPreferences.getInstance();
  bool pormo= myPref.getBool('promotions')??true;
  {
    pormo?_firebaseMessaging.subscribeToTopic('promotions'):_firebaseMessaging.unsubscribeFromTopic('promotions');
  }
 } 
 @override
  void dispose() {
    super.dispose();
  }
 
}