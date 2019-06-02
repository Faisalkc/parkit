import 'base_model.dart';

class SearchModel {
  String parkingKey, parkingSPotName, imageurl,parkinglocation;
}

class SearchResult extends BaseModel {
  List<SearchModel> result = [];
  SearchResult();
}
