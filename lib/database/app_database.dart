import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite/database/tables/book_table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite/models/book.dart';

class AppDatabase {
  static Database? _database;
  static AppDatabase? _appDatabase;

  AppDatabase._createInstance();

  // constructor
  factory AppDatabase(){
    _appDatabase ??= AppDatabase._createInstance();
    return _appDatabase!;
  }

  // create app database
  void _createBookTable(Database db, int version) async {
    String sql = """CREATE TABLE ${BookTable.tableName}(
      ${BookTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${BookTable.name} Text,
      ${BookTable.author} Text
    )""";
    db.execute(sql);
  }

  // initialize database book table
  Future<Database> handleBookTable() async {
    // get database path directory
    Directory directory = await getApplicationDocumentsDirectory();
    // create path
    String path = '${directory.path}sb_database';
    // open database
    var database = await openDatabase(path, version: 1, onCreate: _createBookTable);

    return database;
  }

  // verify if database was create
  Future<Database> get database async {
    _database ??= await handleBookTable();

    return _database!;
  }

  // save books
  Future<int> insertBook(Book obj) async {
    // database request
    Database db = await database;
    var response = await db.insert(BookTable.tableName, obj.toMap());
    // return result as response
    return response;
  }

  // get books
  Future<List<dynamic>> getAllBooks() async {
    Database db = await database;
    String sql = "SELECT * FROM ${BookTable.tableName}";
    List list = await db.rawQuery(sql);
    return list;
  }

  // remove book
  Future<int> deleteBookById(int id) async {
    Database db = await database;
    var result = await db.delete(BookTable.tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // edit book
  Future<int> updateBook(Book obj) async {
    Database db = await database;
    var result = await db.update(BookTable.tableName, obj.toMap(), where: "id = ?", whereArgs: [obj.id]);
    return result;
  }
}
