import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolocal/model/task.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String tableName = 'todo_table';
  String columnId = 'id';
  String columnTitle = 'title';
  String columnDescription = 'description';
  String taskDuration = 'duration';
  String statusBool = 'status';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    // ignore: prefer_conditional_assignment
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo_database.db');

    var database = await openDatabase(path, version: 2, onCreate: _createTable);

    return database;
  }

  void _createTable(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT, $columnDescription TEXT, $taskDuration TEXT, $statusBool INTEGER)');
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final db = await database;
    final result = await db.rawQuery('SELECT * FROM $tableName');
    return result;
  }

  Future insertData(Task task) async {
    final db = await database;
    var result = await db.insert(tableName, task.toJson());
    return result;
  }

  Future updateStatus(int id, int statusVal) async {
    final db = await database;
    var result = await db.rawQuery(
        'UPDATE $tableName SET $statusBool = $statusVal where $id = $columnId');
    return result;
  }
}
