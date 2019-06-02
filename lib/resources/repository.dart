import 'dart:async';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/Bloc/favorites_bloc.dart';
import 'package:parkit/model/booking_model.dart';
import 'package:parkit/model/history_model.dart';
import 'package:parkit/model/payment_model.dart';
import 'package:parkit/resources/firebase_api_provider.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:parkit/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkit/screens/parkingspotDetails.dart';
import 'package:parkit/model/available_model.dart';
import 'package:parkit/model/favorites.dart';
import 'favoritesDB.dart';
import 'HistoryDB.dart';

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

  Future<Transaction> getMyTxnHistory() async {
    return Transaction.fromjson(await historyDB.getMyHistory());
  }

  createParkingSpot(ParkingModel parking, List<File> _docUpload) async {
    parking.image =
        await firebaseStorageApi.uploadPlotDoc(parking.imageToupload);
    parking.documentId =
        await firebaseDatabase.createParkingSpotDoc(_docUpload);
    firebaseDatabase.createParkingSpot(parking);
  }

  Future<ParkingModel> getParkingDetails(String parkingKey) async {
    return await firebaseDatabase.searchByParkingKey(parkingKey);
  }

  Future<Map<String, ParkingModel>> getMyParkingList() async {
    return await firebaseDatabase.getMyparkingSpots();
  }

  Future<Map<MarkerId, Marker>> getMarkers(
      LatLng customerLocation, BuildContext context) async {
    Map<String, ParkingModel> _listofParkings =
        await FirebaseDatabaseApi().getavailableParking(customerLocation);
    _listofParkings.forEach((key, values) {
      if (values.availability != null) {
        if (values.availability.availableTiming.length > 0) {
          MarkerId markerId = MarkerId(key);
          Marker marker = Marker(
            markerId: markerId,
            icon: BitmapDescriptor.fromAsset('assets/images/mapicon.png'),
            position: values.location.latLng,
            infoWindow: InfoWindow(
              title: values.spotname,
              snippet: 'Ratings:' + values.votes.toString(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ParkingSpotDetails(parkingSpotKey: key)));
            },
          );
          markers[markerId] = marker;
        }
      }
    });
    return markers;
  }

  Future<UserModel> getUserDetails() async {
    UserModel userModel;

    try {
      FirebaseUser _user = await FirebaseAuth.instance.currentUser();
      _user.reload();
      if (_user != null) {
        userModel = UserModel.fromFirebase(
            uid: _user.uid,
            photoUrl: _user.photoUrl,
            mobile: _user.phoneNumber,
            isVerified: _user.isEmailVerified,
            email: _user.email,
            displayName: _user.displayName);
        return userModel;
      }
    } catch (e) {}

    return null;
  }

  Future<UserModel> getCustomerDetails(String _uid) async {
    return await firebaseDatabase.searchCustomerDetails(_uid);
  }

  Future<bool> updateDisplayImage(File _image) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    String _imgUrl =
        await firebaseStorageApi.uploadProfilePic(_image, _user.uid);

    UserUpdateInfo _info = UserUpdateInfo();
    _info.photoUrl = _imgUrl;
    await _user.updateProfile(_info);
    return true;
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    FacebookLogin().logOut();
  }

  Future uplodGovDoc(GovId _id) async {
    _id.documentImagesAdress = await firebaseStorageApi
        .uploaduserGovIdDoc(_id.documentImagesForUpload);
    firebaseDatabase.createCustomerGovDoc(_id);
  }

  addBankPayment(String accountNumber, String bankName, holder) {
    firebaseDatabase.addPaymentMethod(
        accountNumber, bankName, holder, paymentMethods.Bank);
  }

  addCCPayment(String accountNumber, String bankName, holder) {
    firebaseDatabase.addPaymentMethod(
        accountNumber, bankName, holder, paymentMethods.CreditCard);
  }

  Future<bool> makeAvailability(
      String _parkingid, AvailableModel _model) async {
    return await firebaseDatabase
        .addAvailability(_parkingid, _model)
        .then((val) => true)
        .catchError((onError) => false);
  }

  Future<bool> addToFavorites(ParkingModel data) async {
    favoritesDb.addToFav(data);
    ismyfavbloc.ismyfavbloc(data.parkingkey);
    return true;
  }

  Future<bool> removeFromFavorites(String parkingkey) async {
    ismyfavbloc.ismyfavbloc(parkingkey);
    return await favoritesDb.removeFromFav(parkingkey);
  }

  Future<FavoritesModel> checkfav(String _name) async {
    bool fav = await favoritesDb.alreadyExist(_name);
    return FavoritesModel(parkingKey: _name, isMyfav: fav);
  }

  Future<FavoritesModel> getMyFavorites() async {
    FavoritesModel.favlistavailable.clear();
    List<Map<String, dynamic>> _data = await favoritesDb.getMyFav();
    for (var row in _data) {
      print(row);

      FavoritesModel obj = FavoritesModel.favlist(
          id: row['id'],
          spotname: row['name'],
          parkingKey: row['parkit'],
          desc: row['desc'],
          image: row['img']);
      FavoritesModel.favlistavailable.add(obj);
    }
    return FavoritesModel.favlistavailable.isEmpty
        ? null
        : FavoritesModel.favlistavailable[0];
  }

  Future<List<PaymentModel>> getMyPaymentMethods() {
    return firebaseDatabase.getPaymentMethods();
  }

  Future<BookingModel> bookaSlot(
      String parkingkey, String onDate, List<String> times) async {
    final user = await FirebaseAuth.instance.currentUser();
    return firebaseDatabase.bookaSlot(parkingkey, onDate, times, user.uid);
  }

  updateFCM(String tocken) async {
    firebaseDatabase.updateFCM(tocken);
  }

  Future<void> updateBalance() async {
    final user = await FirebaseAuth.instance.currentUser();
    firebaseDatabase.updateBalance(user.uid);
  }

  updateTransactions() async {
    
    final data = await firebaseDatabase.updatetransacctions();
    HttpsCallable resp =  CloudFunctions.instance.getHttpsCallable(functionName: 'readreciptforTransaction');
    if (data != null) {
      Map<dynamic, dynamic> _transactionsdata = data.value;
      _transactionsdata.forEach((key, val) {
        if (val['read'].toString() == 'n') 
        {
          History his = History.fromFirebase(val, key);
          historyDB.addToMyHistory(his).then((_){
            resp.call(
              {
                'transactionid':key.toString(),
              }
            ).then((res){
              print(res.data);
            }).catchError((onError){
              print
              (onError);
            });
          });

        }
      });
    }
  }
}

final repository = Repository();
