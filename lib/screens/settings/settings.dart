import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _riminderNotifi=true;
  bool _promoNotifi=true;
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
        activeColor: Colors.black87,
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
        activeColor: Colors.black87,
        value: _promoNotifi,
        onChanged: (val)
        {
          setState(() {
            _promoNotifi=val;
          });
        },
      ),
    )
      ],
    );
  }
}