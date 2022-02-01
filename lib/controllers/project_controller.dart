// import 'dart:developer';

import 'package:get/get.dart';
import 'package:myprojectmanager/db/db_helper.dart';
import 'package:myprojectmanager/models/project.dart';

class ProjectController extends GetxController {
  var projectList = <Project>[].obs;
  var usersProjectList = <Project>[].obs;
  @override
  void onReady() {
    getProjects();
    super.onReady();
  }

  Future<int> addProject({Project? project}) async {
    return await DBHelper.insertProject(project);
  }

  void getProjects() async {
    List<Map<String, dynamic>> projects = await DBHelper.queryProjects();
    projectList
        .assignAll(projects.map((data) => Project.fromJson(data)).toList());
  }

  getUserProject(int user) async {
    List<Map<String, dynamic>> projects =
        await DBHelper.queryUsersProjects(user);
    // inspect(projects);
    usersProjectList
        .assignAll(projects.map((data) => Project.fromJson(data)).toList());
    // inspect(projectsL
  }

  // Future<User> Login(
  //     {required String username, required String password}) async {
  //   return await DBHelper.getLogin(username, password);
  // }
}
