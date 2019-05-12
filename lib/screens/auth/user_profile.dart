import 'package:flutter/material.dart';
import 'package:parkit/Bloc/user_bloc.dart';
import 'package:parkit/model/user_model.dart';
import 'package:parkit/resources/repository.dart';
import 'package:parkit/screens/auth/ProfilePage.dart';
import 'package:parkit/screens/auth/auth_page.dart';
import 'package:parkit/screens/auth/diagonal_clipper.dart';
import 'package:parkit/screens/settings/availability.dart';
import 'package:parkit/screens/settings/free_rides.dart';
import 'package:parkit/screens/settings/history.dart';
import 'package:parkit/screens/settings/incompleteScreens.dart';
import 'package:parkit/screens/settings/payment/payment.dart';
import 'package:parkit/screens/settings/settings.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  final double _imageHeight = 256.0;
  bool showOnlyCompleted = false;

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    userblock.fetchUserDetails();
    return StreamBuilder(
      stream: userblock.userdetails,
      builder: (context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot, context);
        } 
        else if (snapshot.hasError) 
        {
           return AuthPage();
        }
        return Container(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }
  Widget buildContent(AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
        children: <Widget>[
          // _buildTimeline(),
          _buildIamge(),
          _buildTopHeader(),
          _buildProfileRow(snapshot),
        _buildBottomPart(snapshot, context),
          // _buildFab(),
        ],
      ),
      _userOptions(snapshot, context)
          ],
        ),
      ),
    );
  }


  Widget _buildIamge() {
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Image.asset(
          'assets/images/background.jpeg',
          fit: BoxFit.cover,
          height: _imageHeight,
          colorBlendMode: BlendMode.srcOver,
          color: new Color.fromARGB(120, 20, 10, 40),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          InkResponse(
              onTap: () => Navigator.of(context).pop(false),
              child: Icon(Icons.clear, size: 32.0, color: Colors.white)),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(
                "Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildProfileRow(AsyncSnapshot<UserModel> _userdetails) {
    return new Padding(
      padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
      child: new Row(
        children: <Widget>[
          InkResponse(
            child: CircleAvatar(
              minRadius: 28.0,
              maxRadius: 28.0,
              backgroundImage: _userdetails.data.photoUrl != null
                  ? NetworkImage(_userdetails.data.photoUrl)
                  : AssetImage('assets/icons/avatar-defalut.png'),
            ),
            onTap: () {
              _goToProfilePage(_userdetails, context);
            },
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkResponse(
                  child: Text(
                    'Hi, ',
                    style: new TextStyle(
                        fontSize: 26.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  onTap: () {},
                ),
                InkResponse(
                  onTap: () {

                    _goToProfilePage(_userdetails, context);
                  },
                  child: Text(
                    _userdetails.data.displayName,  
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPart(
      AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(snapshot),
          
        ],
      ),
    );
  }

  Widget _userOptions(AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            _userHostingOption(snapshot, context),
            _userAccountOption(snapshot, context),
            _userSupportOption(snapshot, context),
            _userPromotionOption(snapshot, context),
            _userLegelOption(snapshot, context)
          ],
        ));
  }


  Widget _userAccountOption(
      AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            AddAvailability()));
            },
            trailing: Icon(Icons.add),
            title: Text('Add Availability'),
          ),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            History()));
            },
            trailing: Icon(Icons.attach_money),
            title: Text('Balance'),
          ),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            PaymentPage()));
            },
            trailing: Icon(Icons.attach_money),
            title: Text('Payment Methods'),
          ),
          Divider(),
          ListTile(
             onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            History()));
            },
            trailing: Icon(Icons.attach_file),
            title: Text('History'),
          ),
          Divider(),
          ListTile(
            onTap: ()=>Navigator.pushNamed(context, '/favorites'),
            trailing: Icon(Icons.notifications),
            title: Text('Favorites'),
          ),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            Settings()));
            },
            trailing: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          Divider(),
        ],
      ),
    );
  }
  Widget _userPromotionOption(
      AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FreeRidesPage()));
            },
            trailing: Icon(Icons.attach_money),
            title: Text('Invite Friend'),
            
          ),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            FreeRidesPage()));
            },
            trailing: Icon(Icons.attach_file),
            title: Text('Invite Host'),
          ),
          
          Divider(),
        ],
      ),
    );
  }

  Widget _userHostingOption(
      AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            onTap: () {
             Navigator.pushNamed(context, '/ListAPark');
            },
            trailing: Icon(Icons.add_box),
            title: Text('List Your Space'),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _userSupportOption(
      AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            onTap: () {
              _goToProfilePage(snapshot, context);
            },
            trailing: Icon(Icons.add_box),
            title: Text('Get help'),
          ),
          Divider(),
          ListTile(
            onTap: () {
              _goToProfilePage(snapshot, context);
            },
            trailing: Icon(Icons.add_box),
            title: Text('Giv us feedback'),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _userLegelOption(
      AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            onTap: () {
            Navigator.of(context)
.push(MaterialPageRoute(builder: (BuildContext context)=>LicensePage()));            },
            trailing: Icon(Icons.assignment),
            title: Text('Terms of Service'),
          ),
          Divider(),
          ListTile(
            onTap: () {
             Repository().logout();
             Navigator.of(context).pop(false);
            },
            trailing: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildMyTasksHeader(AsyncSnapshot<UserModel> snapshot) {
    return snapshot.data.percentage < 1.0
        ? Padding(
            padding: new EdgeInsets.only(left: 64.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'View and Edit Profile',
                  style: TextStyle(
                    fontFamily: 'OpenSansRegular',
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  '${4 - (snapshot.data.percentage ~/ 0.25).toInt()} step left',
                  style: TextStyle(
                    fontFamily: 'OpenSansRegular',
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>IncompleteStepts(snapshot:snapshot ,)));
                  },
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    stepContainerLeft(context, 'red'),
                    stepContainer(context, 'red'),
                    stepContainer(context, 'red'),
                    stepContainerRight(context),
                  ],
                ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        : Container();
  }

  Container stepContainerLeft(BuildContext context, color) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      width: MediaQuery.of(context).size.width * 0.15,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(6.0),
            bottomLeft: const Radius.circular(6.0),
          )),
    );
  }

  Container stepContainer(BuildContext context, color) {
    return Container(
      margin: EdgeInsets.only(left: 8),
      width: MediaQuery.of(context).size.width * 0.15,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
    );
  }

  Container stepContainerRight(
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      width: MediaQuery.of(context).size.width * 0.15,
      height: 60,
      decoration: BoxDecoration(
          color: Color.fromRGBO(218, 218, 218, 1),
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(6.0),
            bottomRight: const Radius.circular(6.0),
          )),
    );
  }

  _goToProfilePage(AsyncSnapshot<UserModel> snapshot, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            ProfilePage(snapshot: snapshot)));
  }
}
