

import 'package:firebase_database/firebase_database.dart';
import 'package:parkit/Bloc/base.dart';
import 'package:parkit/model/parking_spot_model.dart';
import 'package:parkit/model/searchModel.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends BaseBloc<SearchResult> {
  Observable<SearchResult> get sreachresult => fetcher.stream;
  
  final parkitNode=FirebaseDatabase.instance.reference().child("parkit");
  search(String search) async {
    SearchResult parkit=SearchResult(); 

    final snapshot=await parkitNode.orderByChild('city').startAt(search).endAt(search+"\uf8ff").once();
    print(snapshot.value);
     if (snapshot.value != null) {
        Map<dynamic, dynamic> _resultset = snapshot.value;
        _resultset.forEach((key, val) {
          ParkingModel _mypark = ParkingModel.fromFirebase(val);
          _mypark.parkingkey = key;
              SearchModel test=SearchModel();
          test.parkingSPotName=_mypark.spotname;
          test.imageurl=_mypark.image[0];
          test.parkingKey=key;
          test.parkinglocation=_mypark.location.city;
           parkit.result.add(test);
        });
      }
    fetcher.sink.add(parkit);
  }
}

final searchbloc = SearchBloc();
