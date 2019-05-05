import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkit/model/user_model.dart';
import 'package:parkit/resources/repository.dart';
import 'package:parkit/screens/auth/otp_page.dart';

class ProfilePage extends StatefulWidget {
 AsyncSnapshot<UserModel> snapshot;
  ProfilePage({this.snapshot});
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String _customerName, _customerEmail, _customerMobile;
  TextEditingController _displayNameController,
      _emailController,
      _mobileController;
  @override
  void initState() {
    _displayNameController =
        TextEditingController(text: widget.snapshot.data.displayName);
    _emailController = TextEditingController(text: widget.snapshot.data.email);
    _mobileController = TextEditingController(text: widget.snapshot.data.mobile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scafoldKey,
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: new Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                    size: 22.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: new Text('PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          // fontFamily: 'sans-serif-light',
                                          color: Colors.black)),
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new NetworkImage(widget
                                                    .snapshot.data.photoUrl !=
                                                null
                                            ? widget.snapshot.data.photoUrl
                                            : "https://www.joomlack.fr/images/demos/demo2/on-top-of-earth.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: InkResponse(
                                        onTap: () async {
                                          File _image =
                                              await ImagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                          if (_image != null) {
                                            if (await repository
                                                .updateDisplayImage(_image,
                                                    )) {
                                              _scafoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text('Uploaded'),
                                              ));
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Parsonal Information',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      _status
                                          ? _getEditIcon()
                                          : new Container(),
                                    ],
                                  )
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Full Name',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: _displayNameController,
                                      decoration: const InputDecoration(
                                        hintText: "Enter Your Name",
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                      onChanged: (newName) {
                                        setState(() {
                                          _customerName = newName;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Email ID"),
                                      enabled: !_status,
                                      onChanged: (newEmail) {
                                        setState(() {
                                          _customerEmail = newEmail;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          widget.snapshot.data.isVerified
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Please Verify your Email ID',
                                            style: TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      InkResponse(
                                        onTap: () => FirebaseAuth.instance
                                            .currentUser()
                                            .then((user) =>
                                                user.sendEmailVerification())
                                            .then((onValue) => _scafoldKey
                                                    .currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Please check your mail'),
                                                )))
                                            .catchError((onError) => _scafoldKey
                                                    .currentState
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Something went wrong'),
                                                ))),
                                        child: Text(
                                          '  Resend',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Mobile',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                      keyboardType: TextInputType.phone,
                                      controller: _mobileController,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Mobile Number"),
                                      enabled: !_status,
                                      onChanged: (newMobile) {
                                        setState(() {
                                          _customerMobile = newMobile;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'Pin Code',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: new Text(
                                        'State',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter Pin Code"),
                                        enabled: !_status,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: new TextField(
                                      decoration: const InputDecoration(
                                          hintText: "Enter State"),
                                      enabled: !_status,
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              )),
                          !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  await updateFirebase();
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Future<void> updateFirebase() async {
    debugPrint('Started');
    FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
    if (_customerName != null &&
        widget.snapshot.data.displayName != _customerName) {
      UserUpdateInfo _update = UserUpdateInfo();
      _update.displayName = _customerName;
      _currentUser.updateProfile(_update).catchError(
          (onError) => _scafoldKey.currentState.showSnackBar(SnackBar(
                content: Text('Something went wrong ..'),
              )));
    }
    if (_customerEmail != null && widget.snapshot.data.email != _customerEmail) {
      try {
        _customerEmail.trim();
        await _currentUser.reload();
        await _currentUser
            .updateEmail(_customerEmail)
            .then((_) => _currentUser.sendEmailVerification())
            .catchError(
                (onError) => _scafoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Something went wrong ..'),
                    )));
      } catch (e) {
        print(e);
      }
    }
    if (_customerMobile != null && widget.snapshot.data.mobile != _customerMobile) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>OtpPage(phoneNumber: _customerMobile,)));

    }
  }
  
}
