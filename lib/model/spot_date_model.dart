import 'base_model.dart';
class SpotDate extends BaseModel
{
  int fromHH,fromMM,toHH,toMM;
  int uintervel=30;
  Map<dynamic,dynamic> availableDates={};
  SpotDate(String date,this.fromHH,this.fromMM,this.toHH,this.toMM)
  {
    Map<dynamic,dynamic> _time={};
    do
    {

      String _availabletiming='$fromHH:$fromMM';
      print('$fromHH:$fromMM');
      _time[_availabletiming]=true;
      fromMM=fromMM==00?30:00;
      fromHH=fromMM==00?fromHH+1:fromHH;
      if(fromHH==24)
      {
        break;
      }
      

          print(fromHH );
    }
    while (fromHH!=toHH || fromMM!=toMM);
    _time['$fromHH:$fromMM']=true;
    availableDates[date]=_time;

  }

}