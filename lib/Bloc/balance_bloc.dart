import 'package:parkit/Bloc/base.dart';
import 'package:parkit/model/history_model.dart';
import 'package:rxdart/rxdart.dart';

class BalanceBloc extends BaseBloc<Transaction> {
  Observable<Transaction> get txnstream => fetcher.stream;


  getmyTxnHistory() async {
    Transaction his = await repository.getMyTxnHistory();
    fetcher.sink.add(his);
  }

}


final transactions = BalanceBloc();
