import 'package:flutter_login_signup_sqflite_app/model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _db;

  static const String DB_Name = "login.db";
  static const int DB_Version = 1;
  static const String Table_User = 'user';

  static const String User_Id = 'user_id';
  static const String UserName = 'user_name';
  static const String Email = 'email';
  static const String Password = 'password';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: DB_Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $Table_User (
        $User_Id INTEGER PRIMARY KEY AUTOINCREMENT,
        $UserName TEXT NOT NULL,
        $Email TEXT NOT NULL,
        $Password TEXT NOT NULL
      )
    ''');
  }

  Future<UserModel> saveUser(UserModel user) async {
    var dbClient = await db;
    user.UserId = await dbClient!.insert(Table_User, user.toMap());
    return user;
  }

  Future<UserModel?> getLoginUser(String userName, String password) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery(
        'SELECT * FROM $Table_User WHERE $UserName = ? AND $Password = ?',
        [userName, password]);

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }

    return null;
  }

  Future<UserModel?> getUserByUserName(String userName) async {
    var dbClient = await db;
    var res = await dbClient!
        .rawQuery('SELECT * FROM $Table_User WHERE $UserName = ?', [userName]);

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }

    return null;
  }
}
