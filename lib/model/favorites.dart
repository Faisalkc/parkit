import 'base_model.dart';
class FavoritesModel extends BaseModel 
{
  String parkingKey ;
  bool isMyfav;
  int id;
  String image,desc,spotname;
  FavoritesModel({this.parkingKey,this.isMyfav});
  FavoritesModel.favlist({this.id,this.spotname,this.parkingKey,this.desc,this.image});
  static List<FavoritesModel> favlistavailable=[];
}