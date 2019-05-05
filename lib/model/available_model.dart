import 'package:parkit/model/base_model.dart';
import 'spot_date_model.dart';
class AvailableModel extends BaseModel
{ bool suspended;
SpotDate soptDates;
  
  AvailableModel.forFirebase(this.soptDates)
  {
    this.suspended=false;

  }

Map<dynamic,dynamic> availabletoJson()
{
   return
   {
     "suspended":suspended,
     "dates":dates(),
     
   };
 }
Map<dynamic,dynamic> dates()
{
  return  soptDates.availableDates;
}
}