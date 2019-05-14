import 'package:parkit/Bloc/base.dart';
import 'package:parkit/model/favorites.dart';
import 'package:rxdart/rxdart.dart';
class MyFavFavoritesBloc extends BaseBloc<FavoritesModel>
{
    Observable<FavoritesModel> get getmyfavlist => fetcher.stream;
    myfavlistbloc()async
    {
      FavoritesModel fav=await repository.getMyFavorites();
      fav==null?fetcher.sink.addError('No Favorites found') :fetcher.sink.add(fav);
    }
}
final myfavlistbloc = MyFavFavoritesBloc();
