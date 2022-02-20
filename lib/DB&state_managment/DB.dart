import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLogic extends ChangeNotifier{
  Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initialiseDB();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialiseDB() async {
// Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Task.db');
    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Notes (id INTEGER PRIMARY KEY, date TEXT, note TEXT)');
        });
    return database;
  }
  insertDB(String date, String note) async {
    //bngeb database
    var dbClient = await db;
    // Insert some records in a transaction
    await dbClient.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO Notes (date, note) VALUES(?, ?)',
          [date, note]);
      print("$id *****************************************");// berag3 id bta3 el row el dgeg
    });
  }

  List<Map> list=[];
  getData() async {
    var dbClient = await db;
// Get the records
    list = await dbClient.rawQuery('SELECT * FROM Notes');
    print(list);
    notifyListeners();
  }
  deleteOneRow(int id)async{
// Delete a record
    var dbClient = await db;
    await dbClient
        .rawDelete('DELETE FROM Notes WHERE id = ?', [id]);
    // assert(count == 1);//berag3 3dd el stor el atmas7t

  }
  getSingleData() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM Notes where id=?", [1]);
    print(result);
  }
  deleteAll()async{
    var dbClient = await db;
    await dbClient.delete("Notes");//delete all row
  }
  update(String date, String note, int id) async {
    // Update some record
    var dbClient = await db;
    int count = await dbClient.rawUpdate(
        'UPDATE Notes SET date = ?, note = ? WHERE id = ? ',
        [date, note, id]);
    print('updated: $count');//berag3 0(filed) or 1(done)
    // notifyListeners();
  }
}