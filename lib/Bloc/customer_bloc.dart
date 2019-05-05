import 'package:parkit/Bloc/base.dart';
import 'package:parkit/model/user_model.dart';
import 'package:rxdart/rxdart.dart';
class CustomerBloc extends BaseBloc<UserModel>
{
    Observable<UserModel> get location => fetcher.stream;
    getCustomerDetails(String uid)async
    {
      UserModel customer=await repository.getCustomerDetails(uid);
      fetcher.sink.add(customer);
    }
}
final parkitcustomerbloc = CustomerBloc();
