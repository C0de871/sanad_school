import 'dart:developer';

import 'package:path/path.dart';
import 'package:sanad_school/core/databases/local_database/tables/subject_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/type_question_table.dart';
import 'package:sanad_school/core/databases/local_database/tables/type_table.dart';
import 'package:sqflite/sqflite.dart';

import 'tables/bridge_tables/tag_question_table.dart';
import 'tables/lesson_table.dart';
import 'tables/question_table.dart';
import 'tables/tag_table.dart';
import 'tables/student_table.dart';
import 'tables/bridge_tables/question_groups_table.dart';

class SqlDB {
  static Database? _db;
  static final SqlDB _instance = SqlDB._internal();

  factory SqlDB() {
    return _instance;
  }
  SqlDB._internal();

  Future<Database?> get db async {
    _db ??= await initialDb();
    return _db;
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'sanad_school.db');
    Database myDb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 6,
      onUpgrade: _onUpgrade,
    );
    return myDb;
  }

  deleteDB() async {
    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'sanad_school.db');
    await deleteDatabase(path);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    Batch batch = db.batch();

    batch.execute(TypeTable.createTableQuery);
    batch.execute(StudentTable.createTableQuery);
    batch.execute(SubjectTable.createTableQuery);
    batch.execute(LessonTable.createTableQuery);
    batch.execute(QuestionGroupsTable.createTableQuery);
    batch.execute(TypeQuestionTable.createTableQuery);
    batch.execute(QuestionTable.createTableQuery);
    batch.execute(TagTable.createTableQuery);
    batch.execute(TagQuestionTable.createTableQuery);
    batch.commit();
    log("upgrade database ================");
  }

  _onCreate(Database db, int version) async {
    log("create database ================");
    _createTables(db);
  }

  _createTables(Database db) {
    Batch batch = db.batch();
    batch.execute(TypeTable.createTableQuery);
    batch.execute(StudentTable.createTableQuery);
    batch.execute(SubjectTable.createTableQuery);
    batch.execute(LessonTable.createTableQuery);
    batch.execute(QuestionGroupsTable.createTableQuery);
    batch.execute(TypeQuestionTable.createTableQuery);
    batch.execute(QuestionTable.createTableQuery);
    batch.execute(TagTable.createTableQuery);
    batch.execute(TagQuestionTable.createTableQuery);
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

  Future<List<Map<String, dynamic>>> readData(String table) async {
    Database? myDB = await db;
    List<Map<String, dynamic>> response = await myDB!.query(table);
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
