import 'package:parkit/Bloc/base.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/user_model.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc extends BaseBloc<ParkingModel> {
  Observable<ParkingModel> get location => fetcher.stream;
  fetchlocation(String parkingKey) async {
    ParkingModel parkit = await repository.getParkingDetails(parkingKey);
    UserModel user= await repository.getCustomerDetails(parkit.userid);
    parkit.customerName=user.displayName;
    fetcher.sink.add(parkit);
  }
}

final parkitlocationbloc = LocationBloc();
