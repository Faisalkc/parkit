import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocateMe extends StatefulWidget {
  @override
  _LocateMeState createState() => _LocateMeState();
}

class _LocateMeState extends State<LocateMe> {
LatLng _selectedLocation;

  
  @override
  Widget build(BuildContext context) {
    return googleMap();
  }
    GoogleMapController controller;
      Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
        MarkerId selectedMarker=MarkerId('user');
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }
  Widget location()
  {
    return Padding(
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.black),borderRadius: BorderRadius.circular(10),color: Colors.black),
      width: MediaQuery.of(context).size.width-10,
      height: MediaQuery.of(context).size.width*0.14,
      padding: EdgeInsets.all(10),
      child: Center(child: Text(_selectedLocation==null?'Please tap on map':'${_selectedLocation.longitude}:${_selectedLocation.latitude}',style: TextStyle(color: Colors.white,fontSize: 15),),),
    ),
    padding: EdgeInsets.all(10),
    );
  }
  Widget googleMap() {
    return GoogleMap(
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
                zoom: 20.0,
              ),
              markers: Set<Marker>.of(markers.values),
            );
  }

}
