import 'package:shared_preferences/shared_preferences.dart';

import 'base_model.dart';

class Balance extends BaseModel 
{
  double mainbalance=00;
  Balance();
  Balance.withMainbalance({this.mainbalance})
  {
    setCurrentBalance(this.mainbalance);
  }
  Future<double> getCurrentBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('mainbalance') ?? 0;
  }

  setCurrentBalance(double amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('mainbalance', amount);
  }
}
final balance=Balance();