import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_model.dart';
import 'location_model.dart';
import 'available_model.dart';
class ParkingModel extends BaseModel 
{

    String description,userid,spotname;
    double votes,popularity,price;
    LocationModel location;
    List<String> image=[];
     List<File> imageToupload;
    int status=0;
    String documentId;
    AvailableModel availability;
    String customerName;
    String parkingkey;
    bool isMyFav=false;
    ParkingModel.fromFirebase(dynamic snapshot)
    {
       this.location= LocationModel(LatLng(double.parse(snapshot['latitude'].toString()), double.parse(snapshot['longitude'].toString())), snapshot['address'], snapshot['city']);
       this.votes=snapshot['vote']*1.0;
       this.status=snapshot['status'];
       List<dynamic> _img=snapshot['images'];
       _img.forEach((val)
       {
         image.add(val);
       });
       this.userid=snapshot['userid'];
       this.spotname=snapshot['spotname'];
       this.description=snapshot['description'];
    try {
        if (snapshot['availability']!=null) 
      {
       

        this.availability=AvailableModel.fromFirebase(snapshot['availability']);
      }
      
    } catch (e) {
    }
        
    }
    ParkingModel({this.spotname,this.description,this.imageToupload,this.location,});

}