import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/model/payment_model.dart';
import 'package:parkit/resources/firebase_api_provider.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:parkit/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkit/screens/parkingspotDetails.dart';
import 'package:parkit/model/available_model.dart';

class Repository {
  final firebaseStorageApi = FirebaseStorageApi();
  final firebaseDatabase = FirebaseDatabaseApi();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Future<List<String>> uploadImageToFirebase(List<File> _imageList) async {
    List<String> _uploadedList = [];
    for (int i = 0; i < _imageList.length; i++) {
      if (_imageList[i] != null) {
        _uploadedList.add(await firebaseStorageApi.uploadImage(_imageList[i]));
      }
    }
    return _uploadedList;
  }

  createParkingSpot(ParkingModel parking,List<File> _docUpload)async
  {
    parking.image=await firebaseStorageApi.uploadPlotDoc(parking.imageToupload);
    parking.documentId=await firebaseDatabase.createParkingSpotDoc(_docUpload);
     firebaseDatabase.createParkingSpot(parking);
  }
     
     Future<ParkingModel> getParkingDetails(String parkingKey)async
     
     {
        return await  firebaseDatabase.searchByParkingKey(parkingKey);
     }
      
     Future<Map<String,ParkingModel>> getMyParkingList()async
     
     {
        return await  firebaseDatabase.getMyparkingSpots();
     }

  Future<Map<MarkerId, Marker>> getMarkers(
      LatLng customerLocation, BuildContext context) async {
    Map<String, ParkingModel> _listofParkings =
        await FirebaseDatabaseApi().getavailableParking(customerLocation);
    _listofParkings.forEach((key, values) {
      MarkerId markerId = MarkerId(key);
      Marker marker = Marker (
        markerId: markerId,
        icon: BitmapDescriptor.fromAsset('assets/images/mapicon.png'),
        position: values.location.latLng,
        infoWindow: InfoWindow(
          title: values.spotname,
          snippet: 'Ratings:'+values.votes.toString(),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ParkingSpotDetails(parkingSpotKey: key)));
        },
      );
      markers[markerId] = marker;
    });
    return markers;
  }

  Future<UserModel> getUserDetails() async {
    UserModel userModel;

   
    try {
       FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      _user.reload();
        if(_user!=null)
    {
      userModel = UserModel.fromFirebase(
        uid: _user.uid,
        photoUrl: _user.photoUrl,
        mobile: _user.phoneNumber,
        isVerified: _user.isEmailVerified,
        email: _user.email,
        displayName: _user.displayName);
    return userModel;
    }
      print(_user);
      
    } catch (e) {
    }
  
  
    return null;
  }

 Future<UserModel>  getCustomerDetails(String _uid)async
{
   return await  firebaseDatabase.searchCustomerDetails(_uid);
}
  Future<bool> updateDisplayImage(File _image) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    String _imgUrl = await firebaseStorageApi.uploadProfilePic(_image, _user.uid);
    
    UserUpdateInfo _info = UserUpdateInfo();
    _info.photoUrl = _imgUrl;
    await _user.updateProfile(_info);
    return true;
  }
  void logout()
  {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    FacebookLogin().logOut();
  }

Future uplodGovDoc(GovId _id)async
{
  _id.documentImagesAdress=await firebaseStorageApi.uploaduserGovIdDoc(_id.documentImagesForUpload);
  firebaseDatabase.createCustomerGovDoc(_id);
}
addBankPayment(String accountNumber,String bankName,holder)
{
  firebaseDatabase.addPaymentMethod(accountNumber, bankName, holder, paymentMethods.Bank);
}
addCCPayment(String accountNumber,String bankName,holder)
{
  firebaseDatabase.addPaymentMethod(accountNumber, bankName, holder, paymentMethods.CreditCard);
}
Future<bool>  makeAvailability(String _parkingid,AvailableModel _model)async
{
  await firebaseDatabase.addAvailability(_parkingid, _model);
  return true;
}
Future<bool> addToFavorites(String _name) async
{
  final user=await FirebaseAuth.instance.currentUser();
 return await firebaseDatabase.addToFavorites(_name,user.uid);
}
Future<bool> removeFromFavorites(String _name) async
{
  final user=await FirebaseAuth.instance.currentUser();
 return await firebaseDatabase.removeFromFavorites(_name,user.uid);
}
Future<Map<String,ParkingModel>>  getMyFavorites() async
{
  
return await firebaseDatabase.getFavorites();
}
Future<List<PaymentModel>> getMyPaymentMethods()
{
 return firebaseDatabase.getPaymentMethods();
}
bookaSlot(String parkingkey,String onDate,String slot)async
{
  final user=await  FirebaseAuth.instance.currentUser();
 return firebaseDatabase.bookaSlot(parkingkey, onDate, slot, user.uid);
}
}
final repository=Repository();