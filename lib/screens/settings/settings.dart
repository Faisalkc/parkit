import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parkit/resources/firebase_pushnotification.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
    _promoNotifi=mypref.getBool('promotions')??true;
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
            firebasePushNotification.promotionNotifications();
            });
            

          });
        },
      ),
    )
      ],
    );
  }
}