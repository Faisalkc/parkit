import 'package:parkit/Bloc/base.dart';
import 'package:parkit/model/favorites.dart';
import 'package:rxdart/rxdart.dart';
class FavoritesBloc extends BaseBloc<FavoritesModel>
{
    Observable<FavoritesModel> get location => fetcher.stream;
    ismyfavbloc(String parkingid)async
    {
      FavoritesModel fav=await repository.checkfav(parkingid);
      fetcher.sink.add(fav);
    }
}
final ismyfavbloc = FavoritesBloc();
