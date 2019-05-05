import 'package:parkit/Bloc/base.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc extends BaseBloc<ParkingModel> {
  Observable<ParkingModel> get location => fetcher.stream;
  fetchlocation(String parkingKey) async {
    ParkingModel parkit = await repository.getParkingDetails(parkingKey);
    fetcher.sink.add(parkit);
  }
}

final parkitlocationbloc = LocationBloc();