import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parkit/model/available_model.dart';
import 'package:parkit/model/booking_model.dart';
import 'package:parkit/model/history_model.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/model/payment_model.dart';
import 'package:parkit/model/user_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'favoritesDB.dart';

class FirebaseApiProvider {
  final notesReference = FirebaseDatabase.instance.reference().child("parkit");
  final userReference = FirebaseDatabase.instance.reference().child("user");
  final spotdocReference =
      FirebaseDatabase.instance.reference().child("spotdocuments");
  Future<FirebaseUser> get user => FirebaseAuth.instance.currentUser();
}

class FirebaseStorageApi extends FirebaseApiProvider {
  StorageReference firebaseStorageRef;
  StorageUploadTask task;
  Future<String> uploadImage(File _image) async {
    String _uploadedImageUrl;
    String imageUrl =
        'spot/parkingspot/${DateTime.now().toString()}_parkingSpot.jpg';
    firebaseStorageRef = FirebaseStorage.instance.ref().child(imageUrl);
    task = firebaseStorageRef.putFile(_image);
    await task.onComplete.then((va) async {
      _uploadedImageUrl = await va.ref.getDownloadURL();
    }).catchError((onError) => _uploadedImageUrl = null);
    return _uploadedImageUrl;
  }

  Future<String> uploadProfilePic(File _image, String uid) async {
    String _uploadedImageUrl;
    String imageUrl = 'user/displayimages/$uid.jpg';
    firebaseStorageRef = FirebaseStorage.instance.ref().child(imageUrl);
    task = firebaseStorageRef.putFile(_image);
    await task.onComplete.then((va) async {
      _uploadedImageUrl = await va.ref.getDownloadURL();
      FirebaseDatabaseApi().updateProfilePicInDb(_uploadedImageUrl, uid);
    }).catchError((onError) => _uploadedImageUrl = null);
    return _uploadedImageUrl;
  }

  Future<List<String>> uploaduserGovIdDoc(List<File> _forUpload) async {
    List<String> uploadedlist = [];

    for (var i = 0; i < _forUpload.length; i++) {
      final user = await FirebaseAuth.instance.currentUser();
      if (_forUpload[i] != null) {
        String url =
            "user/${user.uid}/docimage$i${DateTime.now().toString()}.jpg";
        firebaseStorageRef = FirebaseStorage.instance.ref().child(url);

        task = firebaseStorageRef.putFile(_forUpload[i]);
        await task.onComplete.then((va) async {
          uploadedlist.add(await va.ref.getDownloadURL());
        });
      }
    }
    return uploadedlist;
  }

  Future<List<String>> uploadPlotDoc(
    List<File> _forUpload,
  ) async {
    List<String> uploadedlist = [];
    String uid =
        await FirebaseAuth.instance.currentUser().then((_user) => _user.uid);

    for (var i = 0; i < _forUpload.length; i++) {
      if (_forUpload[i] != null) {
        String url = "user/$uid/iamge$i${DateTime.now().toString()}.jpg";
        firebaseStorageRef = FirebaseStorage.instance.ref().child(url);

        task = firebaseStorageRef.putFile(_forUpload[i]);
        await task.onComplete.then((va) async {
          uploadedlist.add(await va.ref.getDownloadURL());
        });
      }
    }
    return uploadedlist;
  }
}

class FirebaseDatabaseApi extends FirebaseApiProvider {
  createParkingSpot(ParkingModel model) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    await notesReference.push().set({
      'userid': _user.uid,
      'availability': null,
      'spotname': model.spotname,
      'description': model.description,
      'latitude': model.location.latLng.latitude,
      'longitude': model.location.latLng.longitude,
      'city': model.location.city,
      'address': model.location.address1,
      'images': model.image,
      'price': 0,
      'vote': 0,
      'popularity': 0,
      'status': 0,
      'document': model.documentId
    }).then((_) {
      // ...
    });
  }

  Future<Map<String, ParkingModel>> getParkitUseLocation(
      LatLng _customerLoc) async {
    Map<String, ParkingModel> _parkingList = {};
    notesReference
        .orderByChild('document')
        .equalTo('-LdsBStigwLfEDtmIOfk')
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(key);
        print(values);
        _parkingList[key] = ParkingModel.fromFirebase(values);
      });
    });

    return _parkingList;
  }
  updateBalance(String userUid)
  {
    userReference.child(userUid).child('mainbalance').once().then((snapshotofCurrent){
    print(snapshotofCurrent.value);
    history.setCurrentBalance(snapshotofCurrent.value*1.0);
    });
  }
  Future<Map<String, ParkingModel>> getavailableParking(
      LatLng customerLocation) async {
    Map<String, ParkingModel> _parkingList = {};
    await notesReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        try {
          if (values['availability'] != null) {
            print(key);
            _parkingList[key] = ParkingModel.fromFirebase(values);
          }
        } catch (e) {}
      });
    });
    return _parkingList;
  }

  Future<void> updateFCM(String tocken) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      userReference.child('${user.uid}').child('fcm').set(tocken);
    } catch (e) {
      userReference.child('guests').child('fcm').set(tocken);
    }
  }

  Future<UserModel> searchCustomerDetails(String _uid) async {
    UserModel user = UserModel.fromSearching();
    await userReference
        .orderByKey()
        .startAt(_uid)
        .endAt(_uid)
        .once()
        .then((data) {
      print(data.value);
      if (data.value != null) {
        Map<dynamic, dynamic> _userdetails = data.value;
        _userdetails.forEach((key, val) {
          if (val['displayname'] != null) {
            user.displayName = val['displayname'];
          } else {
            user.displayName = 'loading';
          }
          if (val['displayPic'] != null) {
            user.photoUrl = val['displayPic'];
          }
        });
      }
    });
    return user;
  }

  Future<bool> createCustomerGovDoc(GovId _idToUpload) async {
    FirebaseUser uid = await FirebaseAuth.instance.currentUser();
    final data = {
      'status': 0,
      'fullname': _idToUpload.fullName,
      'DOB': _idToUpload.dateOfBith,
      'images': _idToUpload.documentImagesAdress,
      'uploaded': DateTime.now().toLocal().toString()
    };
    final upload = {
      uid.uid: {'doc': data}
    };
    final location = FirebaseDatabase.instance.reference().child("user");
    await location.set(upload);
    return true;
  }

  Future<String> createParkingSpotDoc(List<File> _fileToUpload) async {
    FirebaseUser uid = await FirebaseAuth.instance.currentUser();
    List<String> _upload =
        await FirebaseStorageApi().uploadPlotDoc(_fileToUpload);
    final data = {
      'user': uid.uid,
      'images': _upload,
      'uploaded': DateTime.now().toLocal().toString()
    };
    final location = spotdocReference.push();
    await location.set(data);
    return location.key;
  }

  addPaymentMethod(String accountNumber, String bankName, String holder,
      paymentMethods type) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    switch (type) {
      case paymentMethods.Bank:
        {
          final location = FirebaseDatabase.instance
              .reference()
              .child("user/${user.uid}/paymentmethods");
          final data = {
            'type': 'bank',
            'number': accountNumber,
            'accountholder': holder
          };
          location.push().set(data);
        }

        break;
      case paymentMethods.CreditCard:
        {
          final location = FirebaseDatabase.instance
              .reference()
              .child("user/${user.uid}/paymentmethods");
          final data = {
            'type': 'cc',
            'number': accountNumber,
            'accountholder': holder
          };
          location.push().set(data);
        }

        break;
      default:
    }
  }

  Future<List<PaymentModel>> getPaymentMethods() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<PaymentModel> _availablePayments = [];
    await userReference
        .child(user.uid)
        .child('paymentmethods')
        .once()
        .then((data) {
      try {
        Map<dynamic, dynamic> _paymentMethods = data.value;
        _paymentMethods.forEach((key, val) {
          switch (val['type'].toString()) {
            case 'cc':
              _availablePayments.add(PaymentModel.cc(
                  key: key, name: val['accountholder'], number: val['number']));
              break;
            case 'bank':
              _availablePayments.add(PaymentModel.bank(
                  key: key, name: val['accountholder'], number: val['number']));
              break;
            case 'paypal':
              print('paypal Found');
              break;
            default:
              print('Something else found');
          }
        });
      } catch (e) {}
    });

    return _availablePayments;
  }

  Future<ParkingModel> searchByParkingKey(String parkingKey) async {
    ParkingModel _model;
    DataSnapshot _snapshot =
        await notesReference.orderByKey().equalTo(parkingKey).once();
    Map<dynamic, dynamic> _result = _snapshot.value;

    _result.forEach((key, val) async {
      _model = ParkingModel.fromFirebase(val);
      _model.parkingkey = key.toString();
      UserModel _cus = await searchCustomerDetails(_model.userid);
      _model.customerName = _cus.displayName;

      _model.isMyFav = await favoritesDb.alreadyExist(key.toString());
    });
    return _model;
  }

  updateProfilePicInDb(String _img, String _uid) async {
    await userReference.child('$_uid').update({'displayPic': _img});
  }

  updateProfileName(String _name, String _uid) async {
    await userReference.child('$_uid').update({'displayname': _name});
  }

  getUserHistory(String _name, String _uid) async {
    await userReference.child('$_uid').update({'displayname': _name});
  }

  addToHistory(String _name, String _uid) async {
    await userReference.child('$_uid').update({'History': _name});
  }



  Future<bool> removeFromFavorites(String _name, String _uid) async {
    try {
      await userReference
          .child('$_uid')
          .child('favorites')
          .update({_name: null});
      print('$_uid added to fav  $_name');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, ParkingModel>> getFavorites() async {
    Map<String, ParkingModel> _parkingList = {};
    final user = await FirebaseAuth.instance.currentUser();
    await userReference
        .child('${user.uid}')
        .child('favorites')
        .orderByKey()
        .once()
        .then((data) {
      if (data.value != null) {
        Map<dynamic, dynamic> _resultset = data.value;
        _resultset.forEach((key, val) async {
          print(key);
          await searchByParkingKey(key).then((_p) {
            print(_p.userid);
            _parkingList[key] = _p;
          });
        });
      }
    });
    return _parkingList;
  }

  Future<Map<String, ParkingModel>> getMyparkingSpots() async {
    Map<String, ParkingModel> _myParking = {};
    final user = await FirebaseAuth.instance.currentUser();
    await notesReference
        .orderByChild('userid')
        .startAt(user.uid)
        .endAt(user.uid)
        .once()
        .then((data) {
      if (data.value != null) {
        Map<dynamic, dynamic> _resultset = data.value;
        _resultset.forEach((key, val) {
          ParkingModel _mypark = ParkingModel.fromFirebase(val);
          _mypark.parkingkey = key;
          _myParking[key] = _mypark;
        });
      }
    });
    return _myParking;
  }

  Future<BookingModel> bookaSlot(String parkingkey, String onDate,
      List<String> times, String userid) async {
        final booking=BookingModel.forbooking(onDate, parkingkey, userid, times);
    final response =await CloudFunctions.instance.getHttpsCallable( functionName:'spotbkooing',).call(
      booking.queryurl
    );
    print('data:');
    print(response.data);
    return BookingModel.fromfirebase(response.data);
  }

  Future<bool> addAvailability(String patkingID, AvailableModel _model) async {
    //  await notesReference.child(patkingID).child('availability').child(_model.availabletoJson().keys.toList()[0]).set(_model.availabletoJson().values.toSet();
    return await notesReference
        .child(patkingID)
        .child('availability')
        .update(_model.availabletoJson())
        .then((_) => true)
        .catchError((onError) => false);
  }
}
