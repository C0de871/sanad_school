import 'dart:developer';

import 'package:path/path.dart';
import 'package:rive/rive.dart';
import 'package:sanad_school/core/databases/local_database/tables/bridge_tables/type_subject_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/city_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/type_question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/type_table.dart';
import 'package:sqflite/sqflite.dart';

import 'tables/bridge_tables/tag_question_table.dart';
import 'tables/lesson_table.dart';
import 'tables/photo_table.dart';
import 'tables/question_table.dart';
import 'tables/tag_table.dart';
import 'tables/user_table.dart';

class SqlDB {
  static Database? _db;
  static final SqlDB _instance = SqlDB._internal();

  factory SqlDB() {
    return _instance;
  }
  SqlDB._internal();

  Future<Database?> get db async {
    _db ??= await initalDB();
    return _db;
  }

  Future<Database> initalDB() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'notes.db');
    Database notesDB = await openDatabase(path, onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return notesDB;
  }

  deleteDB() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'notes.db');
    await deleteDatabase(path);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    log("upgrade database ================");
  }

  _onCreate(Database db, int version) async {
    log("create database ================");
    _createTables(db);
  }

  _createTables(Database db) {
    Batch batch = db.batch();
    batch.execute(UserTable.createTableQuery);
    batch.execute(TypeTable.createTableQuery);
    batch.execute(TypeQuestionTable.createTableQuery);
    batch.execute(QuestionTable.createTableQuery);
    batch.execute(PhotoTable.createTableQuery);
    batch.execute(LessonTable.createTableQuery);
    batch.execute(TagTable.createTableQuery);
    batch.execute(TagQuestionTable.createTableQuery);
    batch.execute(CityTable.createTableQuery);
    batch.execute(SubjectTable.createTableQuery);
    batch.execute(TypeSubjectTable.createTableQuery);
    batch.commit();
  }

  Future<List<Map>> sqlReadData(String sql) async {
    Database? myDB = await db;
    List<Map> response = await myDB!.rawQuery(sql);
    return response;
  }

  Future<int> sqlInsertData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawInsert(sql);
    return response;
  }

  Future<int> sqlUpdataData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawUpdate(sql);
    return response;
  }

  Future<int> sqlDeleteData(String sql) async {
    Database? myDB = await db;
    int response = await myDB!.rawDelete(sql);
    return response;
  }

  Future<List<Map>> readData(String table) async {
    Database? myDB = await db;
    List<Map> response = await myDB!.query(table);
    return response;
  }

  Future<int> insertData(String table, Map<String, Object?> values) async {
    Database? myDB = await db;
    int response = await myDB!.insert(table, values);
    return response;
  }

  Future<int> updataData(String table, Map<String, Object?> values, String? myWhere) async {
    Database? myDB = await db;
    int response = await myDB!.update(table, values, where: myWhere);
    return response;
  }

  Future<int> deleteData(String table, String? myWhere) async {
    Database? myDB = await db;
    int response = await myDB!.delete(
      table,
      where: myWhere,
    );
    return response;
  }
}
