import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkit/model/user_model.dart';

enum paymentMethods { Bank, CreditCard, Paypal }

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
            "user/${user.uid}/docimage${i}${DateTime.now().toString()}.jpg";
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

  Future<Map<String, ParkingModel>> getavailableParking(
      LatLng customerLocation) async {
    Map<String, ParkingModel> _parkingList = {};
    await notesReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(values);
        _parkingList[key] = ParkingModel.fromFirebase(values);
      });
    });
    return _parkingList;
  }

 Future<UserModel> searchCustomerDetails(String _uid) async{
    UserModel user=UserModel.fromSearching();
    await userReference.orderByKey().startAt(_uid).endAt(_uid).once().then((data){
      print(data.value);
    if(data.value!=null)
    {
        Map<dynamic,dynamic> _userdetails= data.value;
      _userdetails.forEach((key,val)
      {
        
        if(val['displayname']!=null)
        {
          user.displayName=val['displayname'];
        }
        else
        {
          user.displayName='loading';
        }
        if(val['displayPic']!=null)
        {
          user.photoUrl=val['displayPic'];
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

  addPaymentMethod(
      String accountNumber, String bankName, String holder, type) async {
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

  Future<ParkingModel> searchByParkingKey(String parkingKey) async {
    ParkingModel _model;
    DataSnapshot _snapshot =
        await notesReference.orderByKey().equalTo(parkingKey).once();
    Map<dynamic, dynamic> _result = _snapshot.value;
    print(_snapshot.value);
    
    _result.forEach((key, val)async {
      _model = ParkingModel.fromFirebase(val);
      UserModel _cus=await searchCustomerDetails('kovXs1uS0LPaWinWFIuIwL5Q2ap2');
     _model.customerName='fasial';
    });
    return _model;
  }

  updateProfilePicInDb(String _img, String _uid) async {
    await userReference.child('$_uid').set({'displayPic': _img});
  }

  updateProfileName(String _name, String _uid) async {
    await userReference.child('$_uid').set({'displayname': _name});
  }
}
