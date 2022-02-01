import 'package:get/get.dart';
import 'package:myprojectmanager/db/db_helper.dart';
import 'package:myprojectmanager/models/user.dart';

class UserController extends GetxController {
  var UsersList = <User>[].obs;
  var loggedUser = <User>[].obs;

  Future<int> addUser({User? user}) async {
    return await DBHelper.insertUser(user);
  }

  Future<User> Login(
      {required String username, required String password}) async {
    return await DBHelper.getLogin(username, password);
  }

  void getUser({required int id}) async {
    User user = await DBHelper.getUser(id);
    // loggedUser.assignAll(user.map((data) => User.fromJson(data)).toList());
  }

  void getallUsers() async {
    List<Map<String, dynamic>> users = await DBHelper.queryUsers();
    UsersList.assignAll(users.map((data) => User.fromJson(data)).toList());
  }
}
