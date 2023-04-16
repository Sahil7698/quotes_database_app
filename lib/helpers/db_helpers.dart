import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/quotes_model.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();

  Database? db;

  Future<void> initDB() async {
    var directory = await getDatabasesPath();
    String path = join(directory, "sample.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int ver) async {
        String txt =
            "CREATE TABLE IF NOT EXISTS tbl_text(Quote TEXT NOT NULL);";
        String bg =
            "CREATE TABLE IF NOT EXISTS tbl_background(Image BLOB NOT NULL);";
        String fav =
            "CREATE TABLE IF NOT EXISTS tbl_fav(Image STRING NOT NULL,Quote TEXT NOT NULL,Family TEXT NOT NULL);";

        await db.execute(txt);
        await db.execute(bg);
        await db.execute(fav);
      },
    );
  }

  Future<int> insertText({required Quotes quotes}) async {
    await initDB();

    String query = "INSERT INTO tbl_text(Quote) VALUES(?);";
    List args = [quotes.Quotes_Text];

    return await db!
        .rawInsert(query, args); // return on integer => inserted record's id
  }

  Future<int> insertFavorite({required Fav fav}) async {
    await initDB();

    String query =
        "INSERT INTO tbl_favorite(Image, Quote, Family) VALUES(?, ?, ?);";
    List args = [fav.Image, fav.Quotes_Text, fav.Family];

    return await db!
        .rawInsert(query, args); // return on integer => inserted record's id
  }

  Future<int> insertBackground({required Background background}) async {
    await initDB();

    String query = "INSERT INTO tbl_background(Image) VALUES(?);";
    List args = [background.Image];

    return await db!
        .rawInsert(query, args); // return on integer => inserted record's id
  }

  //Fetch All Data
  Future<List<Background>> fetchAllBg() async {
    await initDB();

    String query = "SELECT * FROM tbl_background;";

    List<Map<String, dynamic>> allRecords = await db!.rawQuery(query);

    List<Background> allQuotes =
        allRecords.map((e) => Background.fromMap(data: e)).toList();

    return allQuotes;
  }

  Future<List<Quotes>> fetchAllQuotes() async {
    await initDB();

    String query = "SELECT * FROM tbl_text;";

    List<Map<String, dynamic>> allRecords = await db!.rawQuery(query);

    List<Quotes> allQuotes =
        allRecords.map((e) => Quotes.fromMap(data: e)).toList();

    return allQuotes;
  }

  Future<List<Fav>> fetchAllFav() async {
    await initDB();

    String query = "SELECT * FROM tbl_favorite;";

    List<Map<String, dynamic>> allRecords = await db!.rawQuery(query);

    List<Fav> allFav = allRecords.map((e) => Fav.fromMap(data: e)).toList();

    return allFav;
  }
}
