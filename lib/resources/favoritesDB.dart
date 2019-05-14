import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:parkit/model/parking_spot_model.dart';
class FavoritesDB {
  String path;
   Database database;
  FavoritesDB() {
    initialsationDB();
  }
  void initialsationDB() async {
    path = join( await getDatabasesPath(), 'fav.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      
      await db.execute(
          'CREATE TABLE fav (id INTEGER PRIMARY KEY, name TEXT, parkit TEXT, desc TEXT,img TEXT)');
    });
  }

  deleteDB() async {
    await deleteDatabase(path);
  }
  addToFav(ParkingModel data)async
  {

      await database.transaction((txn) async {
  int id2 = await txn.rawInsert(
      'INSERT INTO fav(name, parkit, desc,img) VALUES(?, ?, ?, ?)',
      [data.spotname, data.parkingkey, data.description,data.image[0]]);
  print('inserted: $id2');
  
});
  }
  Future<bool> removeFromFav(String parkitkey)async
  {
    return await database.rawDelete('delete from fav where parkit=?',[parkitkey])>0?true:false;
  }
  Future<List<Map<dynamic, dynamic>>> getMyFav()async
  {
    return   await database.rawQuery('SELECT * FROM fav');

  }
  Future<bool> alreadyExist(String parkit)async
  {
    print(Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM fav where parkit=?',[parkit])));
     return Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM fav where parkit=?',[parkit]))>0? true:false;
    
  }
}
final  favoritesDb=FavoritesDB();
