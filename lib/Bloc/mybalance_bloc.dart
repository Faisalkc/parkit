import 'package:parkit/model/balance_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'base.dart';

class CurrentBalanceBloc extends BaseBloc<Balance> {
  Observable<Balance> get mybalance => fetcher.stream;
  getmybalance() async {
    Balance his = Balance();
   try {
     
      HttpsCallableResult result=await CloudFunctions.instance.getHttpsCallable(functionName: 'mainbalance',).call( );
       if(result.data['status'])
       {
          his.mainbalance=double.parse(result.data['mainbalance'].toString());
       }
       
   } catch (e) {
     print(e);
   }
   
    
    fetcher.sink.add(his);
  }

}
final mybalancebloc=CurrentBalanceBloc();