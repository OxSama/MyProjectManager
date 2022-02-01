// ignore_for_file: prefer_const_constructors

// import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myprojectmanager/controllers/project_controller.dart';
import 'package:myprojectmanager/controllers/task_controller.dart';
import 'package:myprojectmanager/models/project.dart';
import 'package:myprojectmanager/services/notifications_services.dart';
import 'package:myprojectmanager/services/theme_services.dart';
import 'package:intl/intl.dart';
import 'package:myprojectmanager/ui/home_page.dart';
import 'package:myprojectmanager/ui/profile.dart';
import 'package:myprojectmanager/ui/theme.dart';
import 'package:myprojectmanager/ui/widgets/button.dart';
import 'package:myprojectmanager/ui/widgets/input_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // ignore: prefer_typing_uninitialized_variables
  // DateTime _selectedDate = DateTime.now();
  bool isUserPro = false;
  TextEditingController _projectNameController = TextEditingController();
  final _projectController = Get.put(ProjectController());
  var notifyHelper = NotifyHelper();
  @override
  void initState() {
    super.initState();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    // notifyHelper.scheduledNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          _addTaskBar(),
          // _addDateBar(),
          SizedBox(height: 10),
          _showTabs(),
        ],
      ),
    );
  }

  /// app Bar method
  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode
                ? "Activated Light Theme"
                : "Activated Dark Theme",
          );
          // notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 25,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          child: CircleAvatar(
            // backgroundImage: AssetImage("images/profile.png"),
            backgroundColor: context.theme.primaryColorLight,
            child: Icon(
              Icons.person,
              color: context.theme.primaryColor,
            ),
          ),
          onTap: () {
            Get.to(() => ProfilePage());
          },
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _showTabs() {
    return Expanded(
      child: Container(
        // height: 50,
        padding: EdgeInsets.all(2),
        child: DefaultTabController(
          length: 2,
          child: Container(
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        "Add Project",
                        style: subHeadingStyle.copyWith(
                          color: primaryClr,
                          fontSize: 15,
                        ),
                      ),
                      icon: Icon(
                        Icons.create_outlined,
                        color: primaryClr,
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Projects",
                        style: subHeadingStyle.copyWith(
                          color: primaryClr,
                          fontSize: 15,
                        ),
                      ),
                      icon: Icon(
                        Icons.checklist_outlined,
                        color: primaryClr,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _addProject(),
                      _viewProjects(),
                    ],
                  ),
                ),
              ],
              // title: Text('Tabs Demo'),
            ),
          ),
        ),
      ),
    );
    // );
  }

  _addProject() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add Project'.toUpperCase(),
                  style: titleStyle.copyWith(fontSize: 25, color: primaryClr),
                ),
              ),
              SizedBox(height: 10),
              MyInputField(
                title: "Project Name",
                hint: "Project Name",
                controller: _projectNameController,
              ),
              SizedBox(height: 50),
              MyButton(
                label: "Add",
                onTap: () {
                  _validateProject();
                  // Get.to(() => LoginPage());
                },
                width: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // _showBottomSheet(BuildContext context, Task task) {
  //   Get.bottomSheet(Container(
  //     padding: const EdgeInsets.only(top: 4),
  //     height: task.isCompleted == 1
  //         ? MediaQuery.of(context).size.height * 0.24
  //         : MediaQuery.of(context).size.height * 0.32,
  //     color: Get.isDarkMode ? darkGreyClr : Colors.white,
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 6,
  //           width: 120,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
  //           ),
  //         ),
  //         Spacer(),
  //         task.isCompleted == 1
  //             ? Container()
  //             : _bottomSheetButton(
  //                 label: "Task Completed",
  //                 onTap: () {
  //                   _taskController.markTaskCompleted(task.id!);

  //                   Get.back();
  //                 },
  //                 clr: primaryClr,
  //                 context: context,
  //               ),
  //         _bottomSheetButton(
  //           label: "Delete Task",
  //           onTap: () {
  //             _taskController.delete(task);
  //             _taskController.getTasks();
  //             Get.back();
  //           },
  //           clr: Colors.red[300]!,
  //           context: context,
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         _bottomSheetButton(
  //           label: "Close",
  //           onTap: () {
  //             Get.back();
  //           },
  //           clr: Colors.red[300]!,
  //           isClose: true,
  //           context: context,
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //       ],
  //     ),
  //   ));
  // }

  // _bottomSheetButton(
  //     {required String label,
  //     required Function()? onTap,
  //     required Color clr,
  //     bool isClose = false,
  //     required BuildContext context}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 4),
  //       height: 55,
  //       width: MediaQuery.of(context).size.width * 0.9,
  //       decoration: BoxDecoration(
  //         border: Border.all(
  //           width: 2,
  //           color: isClose == true
  //               ? Get.isDarkMode
  //                   ? Colors.grey[600]!
  //                   : Colors.grey[300]!
  //               : clr,
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //         color: isClose == true ? Colors.transparent : clr,
  //       ),
  //       child: Center(
  //         child: Text(
  //           label,
  //           style:
  //               isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _addDateBar() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 20, left: 20),
  //     child: DatePicker(
  //       DateTime.now(),
  //       height: 100,
  //       width: 80,
  //       initialSelectedDate: DateTime.now(),
  //       selectionColor: primaryClr,
  //       selectedTextColor: Colors.white,
  //       dateTextStyle: GoogleFonts.lato(
  //           textStyle: TextStyle(
  //               fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
  //       dayTextStyle: GoogleFonts.lato(
  //           textStyle: TextStyle(
  //               fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
  //       monthTextStyle: GoogleFonts.lato(
  //           textStyle: TextStyle(
  //               fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
  //       onDateChange: (date) {
  //         setState(() {
  //           _selectedDate = date;
  //         });
  //       },
  //     ),
  //   );
  // }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMEd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                ),
              ],
            ),
          ),
          // MyButton(
          //     label: "+ Add Task",
          //     onTap: () async {
          //       await Get.to(() => AddTaskPage());
          //       _taskController.getTasks();
          //     }
          //     // Get.to(AddTaskPage())
          //     ),
        ],
      ),
    );
  }

  _viewProjects() {
    _listUserProject();
    // inspect(_projectController.projectList.length);
    // inspect(_projectController.projectList[1].owner);
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _projectController.usersProjectList.length,
          itemBuilder: (_, index) {
            // print(_taskController.taskList.length);
            Project project = _projectController.usersProjectList[index];
            // inspect(task.toJson());
            if (_projectController.usersProjectList.isNotEmpty) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // _showBottomSheet(context, task);
                            set(project.id!);
                            Get.to(() => HomePage());
                          },
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 2,
                              bottom: 2,
                            ),
                            margin: EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 2,
                              bottom: 2,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: thirdClr,
                              width: 2,
                            )),
                            width: 300,
                            child: Center(
                              child: Text(
                                project.name!.toUpperCase(),
                                style: subTitleStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.all(10),
                child: Center(
                  child: Text("No Project Created yet"),
                ),
              );
            }
          },
        );
      }),
    );
  }

  set(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("project", id);
  }

  _listUserProject() {
    check();
  }

  check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? i = prefs.getInt("user");
    // inspect("object $i");
    _projectController.getUserProject(i!);
    // inspect(_projectController.projectList);
  }

  _validateProject() {
    if (_projectNameController.text.isNotEmpty) {
      _addProjectToDB();
    } else {
      Get.snackbar(
        "Required",
        "All field are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _addProjectToDB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // inspect(prefs.getInt("user"));
    int? project = await _projectController.addProject(
      project: Project(
        name: _projectNameController.text.trim(),
        owner: prefs.getInt("user"),
      ),
    );
    // inspect("created project with id $project");
    setState(() {
      _projectNameController.text = '';
    });
  }
}
