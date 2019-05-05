import 'dart:core';
import 'dart:io';

import 'base_model.dart';

class UserModel extends BaseModel {
  double percentage=0.25;
  String displayName;
  String email;
  String mobile;
  bool isVerified;
  String photoUrl;
  String uid;
  UserModel.fromSearching();
  UserModel({this.displayName, this.email, this.mobile});
  UserModel.fromFirebase(
      {this.uid,
      this.displayName,
      this.email,
      this.mobile,
      this.isVerified,
      this.photoUrl})
    {
      if(isVerified)
      {
        percentage+=.25;
      }
      if(mobile!=null)
      {
          percentage+=.25;
      }
      if(photoUrl!=null)
      {
        percentage+=0.25;
      }

    }
}
class GovId extends BaseModel
{
  List<String> documentImagesAdress;
  List<File> documentImagesForUpload;
  String fullName;
  String dateOfBith;
  GovId.toUpload({this.fullName,this.dateOfBith,this.documentImagesForUpload});
  GovId.fromFirebase({this.fullName,this.dateOfBith,this.documentImagesAdress});

}