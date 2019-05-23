import 'base_model.dart';
class BookingModel extends BaseModel
{
  bool _status;
  String reason,type;
  String date;
  String uid,spotid;
  List<String> time=[];
  Map<String,dynamic> _query={};
  BookingModel.fromfirebase(snapshot)
  {
    var data=snapshot;
    this._status=data['status'];
    if(!_status)
    {
      this.reason=data['message'];
      this.type=data['type'];
    }
  }
 bool get bookingstatus=>_status;
  BookingModel.forbooking(this.date, this.spotid,this.uid,this.time)
  {
    _query.addAll({
      'uid':uid,
      'spotid':spotid,
      'date':date,
      
    });
    String val="";
    for (var i = 0; i < time.length-1; i++) 
    {
      String _temp=time[i]+':00,';
      
      val=val+_temp;
    }
    val=val+time[time.length-1]+':00';
    _query.addAll({
      'times':val
    });

  }
   Map<String,dynamic> get queryurl=>_query;
}