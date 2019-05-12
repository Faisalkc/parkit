import 'dart:io';
import 'package:app_intro/app_intro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkit/model/location_model.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/user_model.dart';
import 'package:parkit/resources/repository.dart';

class ListingProcess extends StatefulWidget {
  @override
  _ListingProcessState createState() => _ListingProcessState();
}

class _ListingProcessState extends State<ListingProcess> {
  TextEditingController _controllera,_controllerb,_controllerc,_controllerd,_controllere,_controllerf;
  final _bagroundColor=Color.fromRGBO(53, 53, 53, 1);
  final _textColor=Colors.white;
  DateTime selectedDate = DateTime(1996,07,11);
  List<bool> _steps;
  String _parkingSpotName, _adress, _city, _description;
  String _acctHolder,_acctNumber,_creditCard,_acctBank,_fullname;
  List<File> _images,_idProof,_govId;
  @override
  void initState() {
    _controllera=TextEditingController();
     _controllerb=TextEditingController();
      _controllerc=TextEditingController();
       _controllerd=TextEditingController();
       _controllere=TextEditingController();
       _controllerf=TextEditingController();
    _images = [null, null, null];
    _govId=[null,null];
        _idProof = [null, null, null];
    _steps = [false, false, false,false,false,false,false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_steps[0]
        ? enterGovtIdDetails(context)
        : !_steps[1]
            ? enterTheNameScreen()
            : !_steps[2] ? enterAddressDetails() : !_steps[3]?locateme() :!_steps[4]?imageSelection():!_steps[5]?idProofSelection():!_steps[6]?enterAccountDetails()  : _termsAndConditions() ;
  }

  Widget enterTheNameScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            size: 38,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: _bagroundColor,
        elevation: 0,
      ),
      backgroundColor: _bagroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'ParKIT',
                style: TextStyle(
                    fontSize: 30,
                    color: _textColor,
                    fontFamily: 'OpenSansRegular'),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              cursorColor: _textColor,
              style: TextStyle(color: _textColor),
              onChanged: (val) {
                setState(() {
                  _parkingSpotName = val;
                });
              },
              decoration: InputDecoration(
                labelText: "Parking Spot Name",
                
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _textColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _textColor)),
                labelStyle: TextStyle(color: _textColor, fontSize: 16),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .74,
                  child: Text(
                    "Give a name for your parking spot",
                    style: TextStyle(
                        fontSize: 18,
                        color: _textColor,
                        fontFamily: 'OpenSansRegular'),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: FloatingActionButton(
                backgroundColor: _textColor,
                elevation: 0.1,
                onPressed: _parkingSpotName != null
                    ? _parkingSpotName != ''
                        ? () {
                            setState(() {
                              _steps[1] = true;
                            });
                          }
                        : null
                    : null,
                child: Icon(
                  Icons.navigate_next,
                  size: 32,
                  color: _bagroundColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget enterAddressDetails() {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              size: 38,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: _bagroundColor,
          elevation: 0,
        ),
        backgroundColor: _bagroundColor,
        body: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Location?',
                    style: TextStyle(
                        fontSize: 30,
                        color: _textColor,
                        fontFamily: 'OpenSansRegular'),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: TextEditingController(text: _adress),
                  onChanged: (_val) {
                    setState(() {
                      _adress = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "ADDRESS",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: TextEditingController(text: _city),
                  onChanged: (_val) {
                    setState(() {
                      _city = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "CITY",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),
              
              SizedBox(
                height: 22,
              ),
              
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: FloatingActionButton(
                    backgroundColor: _textColor,
                    elevation: 0.1,
                    onPressed: _city != null &&
                            _city != '' &&
                            _adress != null &&
                            _adress != ''
                        ? () {
                            setState(() {
                              _steps[2] = true;
                            });
                          }
                        : null,
                    child: Icon(
                      Icons.navigate_next,
                      size: 32,
                      color: _bagroundColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

 Widget enterAccountDetails() {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              size: 38,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: _bagroundColor,
          elevation: 0,
        ),
        backgroundColor: _bagroundColor,
        body: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Account Details?',
                    style: TextStyle(
                        fontSize: 30,
                        color: _textColor,
                        fontFamily: 'OpenSansRegular'),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: _controllera,
                  onChanged: (_val) {
                    setState(() {
                      _acctHolder = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Account Holder",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: _controllerb,
                  onChanged: (_val) {
                    setState(() {
                      _acctNumber = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Account Number",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: _controllerc,
                  keyboardType: TextInputType.number,
                  onChanged: (_val) {
                    setState(() {
                      _creditCard = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Credit Card Number",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),
               
               Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: _controllerd,
                  onChanged: (_val) {
                    setState(() {
                      _acctBank = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Bank Name",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),
               
              
              SizedBox(
                height: 22,
              ),
              
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: FloatingActionButton(
                    backgroundColor: _textColor,
                    elevation: 0.1,
                    onPressed: _acctNumber != null &&
                            _acctNumber != '' &&
                            _acctBank != null &&
                            _acctBank != '' &&
                            _acctHolder != null &&
                            _acctHolder != ''&&
                            _creditCard != null &&
                            _creditCard != ''
                        ? () {
                            setState(() {
                              _steps[6] = true;
                            });
                          }
                        : null,
                    child: Icon(
                      Icons.navigate_next,
                      size: 32,
                      color: _bagroundColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

Widget enterGovtIdDetails(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              size: 38,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: _bagroundColor,
          elevation: 0,
        ),
        backgroundColor: _bagroundColor,
        body: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Personal Information?',
                    style: TextStyle(
                        fontSize: 30,
                        color: _textColor,
                        fontFamily: 'OpenSansRegular'),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: _controllerf,
                  onChanged: (_val) {
                    setState(() {
                      _fullname = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),

          SizedBox(
            height: 12,
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              onTap: () {
               
                _selectDate(context);
              },
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Date of Birth: ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'OpenSansRegular'),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .90,
            height: 1.6,
            color: Colors.white,
          ),  SizedBox(
            height: 12,
          ),
  
               Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _govId[0] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getGovIdImage(0);
                        },
                      )
                    : Image.file(
                        _govId[0],
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _govId[1] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getGovIdImage(1);
                        },
                      )
                    : Image.file(
                        _govId[1],
                        fit: BoxFit.cover,
                      ),
              ),
              
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Container(
                  width: MediaQuery.of(context).size.width * .74,
                  child: Text(
                    "* Upload both the side of your ID card  ",
                    style: TextStyle(
                        fontSize: 13,
                        color: _textColor,
                        fontFamily: 'OpenSansRegular'),
                  ),
                ),
              
              SizedBox(
                height: 22,
              ),
              
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 20),
                  child: FloatingActionButton(
                    backgroundColor: _textColor,
                    elevation: 0.1,
                    onPressed: _govId[0] != null &&
                           
                            _govId[1] != null &&
                            _fullname != '' &&
                            _fullname != null 
                           
                        ? () {
                            setState(() {
                              _steps[0] = true;
                            });
                          }
                        : null,
                    child: Icon(
                      Icons.navigate_next,
                      size: 32,
                      color: _bagroundColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget imageSelection() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            size: 38,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: _bagroundColor,
        elevation: 0,
      ),
      backgroundColor: _bagroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Images?',
                style: TextStyle(
                    fontSize: 30,
                    color: _textColor,
                    fontFamily: 'OpenSansRegular'),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _images[0] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getImage(0);
                        },
                      )
                    : Image.file(
                        _images[0],
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _images[1] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getImage(1);
                        },
                      )
                    : Image.file(
                        _images[1],
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _images[2] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getImage(2);
                        },
                      )
                    : Image.file(
                        _images[2],
                        fit: BoxFit.cover,
                      ),
              )
            ],
          ),
          SizedBox(
            height: 22,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .74,
                  child: Text(
                    "* select atleast one image",
                    style: TextStyle(
                        fontSize: 13,
                        color: _textColor,
                        fontFamily: 'OpenSansRegular'),
                  ),
                ),
              ],
            ),
          ),
          Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  
                  cursorColor: _textColor,
              style: TextStyle(color: _textColor),
                  controller: _controllere,
                  onChanged: (_val) {
                    setState(() {
                      _description = _val;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Tell something about your spot",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _textColor)),
                    labelStyle: TextStyle(color: _textColor, fontSize: 16),
                  ),
                ),
              ),
              SizedBox
            (height: 15,),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: FloatingActionButton(
                backgroundColor: _textColor,
                elevation: 0.1,
                onPressed: _images[0] != null ||
                        _images[1] != null ||
                        _images[2] != null
                    ? () {
                        setState(() {
                          _steps[4] = true;
                        });
                      }
                    : null,
                child: Icon(
                  Icons.navigate_next,
                  size: 32,
                  color: _bagroundColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

Widget idProofSelection() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            size: 38,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: _bagroundColor,
        elevation: 0,
      ),
      backgroundColor: _bagroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Proof of Ownership?',
                style: TextStyle(
                    fontSize: 30,
                    color: _textColor,
                    fontFamily: 'OpenSansRegular'),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _idProof[0] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getIdImage(0);
                        },
                      )
                    : Image.file(
                        _idProof[0],
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _idProof[1] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getIdImage(1);
                        },
                      )
                    : Image.file(
                        _idProof[1],
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: _textColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 1, spreadRadius: 2)
                    ]),
                width: 70,
                height: 70,
                child: _idProof[2] == null
                    ? InkResponse(
                        child: Center(
                          child: Icon(Icons.camera_alt),
                        ),
                        onTap: () {
                          getIdImage(2);
                        },
                      )
                    : Image.file(
                        _idProof[2],
                        fit: BoxFit.cover,
                      ),
              )
            ],
          ),
          SizedBox(
            height: 22,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * .74,
                  child: Text(
                    "*Upload the documents that prove you are the owner of it.",
                    style: TextStyle(
                        fontSize: 13,
                        color: _textColor,
                        fontFamily: 'OpenSansRegular'),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: FloatingActionButton(
                backgroundColor: _textColor,
                elevation: 0.1,
                onPressed: _idProof[0] != null ||
                        _idProof[1] != null ||
                        _idProof[2] != null
                    ? () {
                        setState(() {
                          _steps[5] = true;
                        });
                      }
                    : null,
                child: Icon(
                  Icons.navigate_next,
                  size: 32,
                  color: _bagroundColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
      GoogleMapController controller;
      Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
        MarkerId selectedMarker=MarkerId('user');
        LatLng _selectedLocation;
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }
Widget locateme(){
      return Scaffold(
        bottomNavigationBar: BottomAppBar(child: Container(height: 50,child: RaisedButton(child: Text('Next'),onPressed:  _selectedLocation==null?null:(){setState(() {
          _steps[3]=true;
        });},),)),
      body: Stack(
        children: <Widget>[
          GoogleMap(
          onTap: (loca)
          {
            print(loca.toString());
            setState(() {
              _selectedLocation=loca;
              markers={
              selectedMarker:Marker(markerId: selectedMarker,
              position: loca)
            };
            });
          },
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                
                target: LatLng(-33.852, 151.211),
                zoom: 14.0,
              ),
              markers: Set<Marker>.of(markers.values),
            )
          ,
          SafeArea(
            child: Padding(
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.black),borderRadius: BorderRadius.circular(10),color: Colors.black),
      width: MediaQuery.of(context).size.width-10,
      height: MediaQuery.of(context).size.width*0.14,
      padding: EdgeInsets.all(10),
      child: Center(child: Text(_selectedLocation==null?'Please tap on map':'${_selectedLocation.longitude}:${_selectedLocation.latitude}',style: TextStyle(color: Colors.white,fontSize: 15),),),
    ),
    padding: EdgeInsets.all(10),
    ),
          )

        ],
      )
    );
}
  Future getImage(int i) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _images[i] = image;
    });
  }
    Future getIdImage(int i) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _idProof[i] = image;
    });
  }
   Future getGovIdImage(int i) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _govId[i] = image;
    });
  }

_termsAndConditions()
{
  List<Slide> slides= [
    new Slide('ParkIT','Your parking spot will be displayed after verifying it from our team','assets/icons/prkit_icon.png'),
  ];
  return SingleButtonIntro(slides, btnName=='Submit'?createParking:btnName=='Done'?()=>Navigator.of(context).pop(false):null, btnName, (){});
}
String btnName='Submit';
void createParking()async
{
  setState(() {
    btnName='Uploading..';
  });
  await repository.uplodGovDoc  (GovId.toUpload(documentImagesForUpload: _govId,fullName: _fullname,dateOfBith: selectedDate.toString()))  ;
  repository.addBankPayment(_acctNumber, _acctBank, _acctHolder);
  repository.addCCPayment(_creditCard, _acctBank, _acctHolder);
  final parking=ParkingModel(spotname: _parkingSpotName,location:LocationModel(_selectedLocation, _adress, _city),description: _description, imageToupload:_images);
  await repository.createParkingSpot(parking,_idProof);
  setState(() {
    btnName='Done';
  });

}

  Future<Null> _selectDate(BuildContext context) async {
    print('hello');
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1990),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

}
