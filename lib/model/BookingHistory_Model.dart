import 'base_model.dart';
class BookingHistoryModel extends BaseModel 
{
  String parkingKey ;
  int id;
  String image,desc,spotname;
  BookingHistoryModel({this.parkingKey});
  BookingHistoryModel.db({this.id,this.spotname,this.parkingKey,this.desc,this.image});
  BookingHistoryModel.book({this.spotname,this.parkingKey,this.desc,this.image});
  static List<BookingHistoryModel> historylistavailable=[];
  addToHistory()
  {
    
  }
}