import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DB {
  static Database _db;
  static String _dbName = 'main.db';

  static Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDB();
    return _db;
  }

  static Future<Database> _initDB() async {
    final dbDirectory = await getDatabasesPath();
    final dbPath = path.join(dbDirectory, _dbName);
    return await openDatabase(
      dbPath,
      singleInstance: true,
      version: 2,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE contacts("
            "id INTEGER PRIMARY KEY,"
            "name TEXT,"
            "wifi TEXT,"
            "ip TEXT,"
            "port INTEGER"
            ")");
        await db.execute("CREATE TABLE calls("
            "id INTEGER PRIMARY KEY,"
            "type INTEGER,"
            "contact_id INTEGER,"
            "date_time TEXT,"
            "duration INTEGER"
            ")");
        await db.execute("CREATE TABLE messages("
            "id INTEGER PRIMARY KEY,"
            "contact_id INTEGER,"
            "from_me INTEGER,"
            "message TEXT,"
            "date_time TEXT"
            ")");
      },
    );
  }
}
