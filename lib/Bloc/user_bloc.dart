import 'package:parkit/model/user_model.dart';
import 'base.dart';
import 'package:rxdart/rxdart.dart';
class UserBloc extends BaseBloc<UserModel>
{
  Observable<UserModel> get userdetails=>fetcher.stream;
  fetchUserDetails()async
  {
  UserModel _user=await repository.getUserDetails();
  if(_user!=null)
  {
      fetcher.sink.add(_user);
  }
  else{
    fetcher.sink.addError(Error);
  }
  
  }
}
final userblock =UserBloc();