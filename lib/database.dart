import 'package:sqflite/sqflite.dart';

class AppDB {
  // Singleton instance
  static AppDB _instance;

  // Config
  final String dbName = 'tanda_vital.db';

  // Vars
  Database _db;

  // Singleton constructor
  static Future<Database> get db async {
    if (_instance == null) {
      _instance = AppDB();
      await _instance.initializeDb();
    }
    return _instance._db;
  }

  void _initDatabase(Database db, int version) async {
    // Create table
    await db.execute('''CREATE TABLE pasien (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      reg VARCHAR(255) NOT NULL,
      nama VARCHAR(255) NOT NULL,
      umur INT(8) NOT NULL,
      kelamin INTEGER(8) NOT NULL
    )''');
  }

  Future initializeDb() async {
    String path = await getDatabasesPath();
    path = path + dbName;

    // Open db
    this._db = await openDatabase(path, version: 1, onCreate: _initDatabase);
  }
}
