import 'base_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class LocationModel extends BaseModel 
{
  LatLng latLng;
  String address1,city;
  LocationModel(this.latLng,this.address1,this.city); 
  Map<dynamic,dynamic> forFirebase()
  
  {
    return
    {
      'latitude':latLng.latitude,
      'longitude':latLng.longitude,
      'address':address1,
      'city':city

    };
  }
}