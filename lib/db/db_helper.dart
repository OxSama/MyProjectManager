import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myprojectmanager/models/project.dart';
import 'package:myprojectmanager/models/task.dart';
import 'package:myprojectmanager/models/user.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tasksTable = "tasks";
  static final String _projectsTable = "projects";
  static final String _usersTable = "users";

  //intialzing method
  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("creating a new one");
          db.execute(
            "CREATE TABLE $_tasksTable("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGERR, "
            "isCompleted INTEGER,project INTEGER, user INTEGER)",
          );
          print("creating users table");
          db.execute(
            "CREATE TABLE $_usersTable("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name STRING, username TEXT, password TEXT)",
          );
          print("creating projects table");
          db.execute(
            "CREATE TABLE $_projectsTable("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name STRING, owner INTEGER)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tasksTable, task!.toJson()) ?? 0;
  }

  static Future<int> insertUser(User? user) async {
    print("insert user function called");
    return await _db?.insert(_usersTable, user!.toJson()) ?? 0;
  }

  static Future<int> insertProject(Project? project) async {
    print("insert project function called");
    return await _db?.insert(_projectsTable, project!.toJson()) ?? 0;
  }

  static Future<User> getLogin(String username, String password) async {
    // var dbClient = await con.db;
    var res = await _db!.rawQuery(
        "SELECT * FROM users WHERE username = '$username' and password = '$password'");

    if (res.length > 0) {
      return User.fromJson(res.first);
    }
    return User(id: 0);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await _db!
        .rawQuery('SELECT * FROM $_tasksTable WHERE user=? and project=? ', [
      prefs.getInt("user"),
      prefs.getInt("project"),
    ]);
  }

  static Future<List<Map<String, dynamic>>> queryUsers() async {
    print("query function called");
    return await _db!.query(_usersTable);
  }

  static Future<List<Map<String, dynamic>>> queryProjects() async {
    print("query function called");
    return await _db!.query(_projectsTable);
  }

  static delete(Task task) async {
    return await _db!.delete(_tasksTable, where: 'id=?', whereArgs: [task.id]);
  }

  static queryUsersProjects(int user) async {
    return await _db!
        .query(_projectsTable, where: 'owner=?', whereArgs: [user]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
    Update tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }

  static getUser(int id) async {
    var res = await _db!.rawQuery("SELECT * FROM users WHERE id=$id");

    if (res.length > 0) {
      return User.fromJson(res.first);
    }
    return User(id: 0);
  }
}
