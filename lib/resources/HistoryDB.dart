import 'package:parkit/model/history_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDB {
  String path;
  Database database;
  HistoryDB() {
    initialsationDB();
  }
  void initialsationDB() async {
    path = join(await getDatabasesPath(), 'his.db');
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS  his (id INTEGER PRIMARY KEY,txnid TEXT, type TEXT, txnmethod TEXT, amount real,txndate TEXT,status TEXT)');
    });
  }

  Future<List<Map<dynamic, dynamic>>> getMyHistory() async {

    return await database.rawQuery('SELECT * FROM his ORDER BY txndate DESC');
  }

  Future<void>addToMyHistory(History data) async {
    await database.transaction((txn) async {
      int id2 = await txn.rawInsert(
          'INSERT INTO his(txnid, type, txnmethod,amount,status,txndate) VALUES(?, ?, ?, ?,?,?)',
          [
            data.txnid,
            data.gettnxType(),
            data.gettxnMethod(),
            data.txnAmount,
            
            data.gettxnStatus(),
            data.txndate.toString()
          ]);
      print('inserted: $id2');
    });
  }

  updateHistory() {}
}

final historyDB = HistoryDB();
