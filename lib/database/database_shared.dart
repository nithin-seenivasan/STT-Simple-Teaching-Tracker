import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_teaching_tracker/database/studentsClass.dart';
import 'package:sqflite/sqflite.dart';

import 'historyClass.dart';

class UserDatabase {
  static String path;
  static final _databaseName = "mydb.db";
  static final _databaseVersion = 1;

  UserDatabase._privateConstructor();
  static final UserDatabase instance = UserDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // LessonsLength in minutes (int)
    await db.execute(
      "CREATE TABLE students(id INTEGER PRIMARY KEY autoincrement, name TEXT, lessontype TEXT, lessonlength INTEGER)",
    );
    // StartTime & FinishTime is mssinceepoch -> contains date as well
    await db.execute(
      "CREATE TABLE lessons(id INTEGER PRIMARY KEY autoincrement, name TEXT,  lessontype TEXT, starttime INTEGER, finishtime INTEGER)",
    );
  }

  static Future getFileData() async {
    return getDatabasesPath().then((s) {
      return path = s;
    });
  }

  //inserts master student data to table (C)
  Future insertStudent(Student student) async {
    Database db = await instance.database;
    return await db.insert("students", student.maptoUserMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  //Adds history data to table (C)
  Future insertLesson(LessonsHistory history) async {
    Database db = await instance.database;
    return await db.insert("lessons", history.maptoUserMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Reads all student data (R)
  Future getStudentsData() async {
    Database db = await instance.database;
    var res = await db.rawQuery("select * from students");
    List list = res.toList().map((c) => Student.fromMap(c)).toList();
    return list;
  }

  // Reads selected student data (R) - based on LessonType
  Future getSelectedStudentsData(String lessonType) async {
    Database db = await instance.database;
    var res = await db
        .rawQuery("select * from students where lessontype = '$lessonType'");
    List list = res.toList().map((c) => Student.fromMap(c)).toList();
    return list;
  }

  // Reads all history data (R)
  Future getAllLessonsHistoryData() async {
    Database db = await instance.database;
    //Query to get all lessons , ordered by datetime
    var lessHist =
        await db.rawQuery("select * from lessons ORDER BY starttime DESC");
    List allList =
        lessHist.toList().map((c) => LessonsHistory.fromMap(c)).toList();
    return allList;
  }

  // Reads selected history data (R) - based on Student Name
  Future getSelectedLessonsHistoryData(String selectedName) async {
    Database db = await instance.database;
    //Query to get all lessons with a specified name, ordered by datetime
    var lessHist = await db.rawQuery(
        "select * from lessons where name = '$selectedName' ORDER BY starttime DESC");
    List selectedlist =
        lessHist.toList().map((c) => LessonsHistory.fromMap(c)).toList();
    return selectedlist;
  }

  /// Update - Students
  Future updateStudent(Student originalStudent, Student modifiedStudent) async {
    Database db = await instance.database;
    return await db.update("students", modifiedStudent.maptoUserMap(),
        where: 'name = ? and lessontype = ?',
        whereArgs: [originalStudent.name, originalStudent.lessontype]);
  }

  /// Update - History
  Future updateLesson(
      LessonsHistory originalHistory, LessonsHistory updatedHistory) async {
    Database db = await instance.database;
    return await db.update("lessons", updatedHistory.maptoUserMap(),
        where: 'starttime = ?', whereArgs: [originalHistory.starttime]);
  }

  /// Delete - Students
  Future deleteStudent(Student student) async {
    Database db = await instance.database;
    return await db.delete("students",
        where: 'name = ? and lessontype = ?',
        whereArgs: [student.name, student.lessontype]);
  }

  /// Delete - History
  Future deleteLesson(LessonsHistory updatedHistory) async {
    Database db = await instance.database;
    return await db.delete("lessons",
        where: 'starttime = ?', whereArgs: [updatedHistory.starttime]);
  }
}
