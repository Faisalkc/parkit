import 'base_model.dart';
class SpotDate extends BaseModel
{
  int price;
  int fromHH,toHH;
  Map<String,dynamic> availableDates={};
  SpotDate(String date,this.fromHH,this.toHH,[int price])
  {
    Map<dynamic,dynamic> _time={};
    if (toHH==00) 
    {
      toHH=24;  
    }
   while (fromHH!=toHH+1 )
    {

      String _availabletiming='$fromHH:00';
      print('$fromHH');
      _time[_availabletiming]=true;
      fromHH++;
      if(fromHH==25)
      {
       
        break;
      }
      _time['25:00']=price??25;

        
    }
    availableDates[date]=_time;
    print('added timing');
       print(availableDates);

  }
  SpotDate.fromFirebase(this.fromHH);
}