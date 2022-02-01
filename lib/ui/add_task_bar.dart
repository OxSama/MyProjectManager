import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myprojectmanager/controllers/task_controller.dart';
import 'package:myprojectmanager/controllers/user_controller.dart';
import 'package:myprojectmanager/models/task.dart';
import 'package:myprojectmanager/ui/profile.dart';
import 'package:myprojectmanager/ui/theme.dart';
import 'package:myprojectmanager/ui/widgets/button.dart';
import 'package:myprojectmanager/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final UserController _userController = Get.put(UserController());
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  int _selectedRemind = 5;
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  String _selectedRepeat = "None";
  int _selectedColor = 0;
  String _selectedUser = "This user";
  List<int> userIdList = [];
  List<String> userNameList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add Task',
                  style: headingStyle,
                ),
                MyInputField(
                  title: 'Title',
                  hint: 'Enter your title',
                  controller: _titleController,
                ),
                MyInputField(
                  title: 'Note',
                  hint: 'Enter your note',
                  controller: _noteController,
                ),
                MyInputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      print('object');
                      _getDateFromUser();
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: "Start Date",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: MyInputField(
                        title: "End Date",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: const Icon(Icons.access_time_rounded),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  title: "Remind",
                  hint: "$_selectedRemind minuts early",
                  widget: DropdownButton(
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    items:
                        remindList.map<DropdownMenuItem<String>>((int? value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: "Repeat",
                  hint: "$_selectedRepeat",
                  widget: DropdownButton(
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                  ),
                ),
                MyInputField(
                  title: "User",
                  hint: "$_selectedUser",
                  widget: DropdownButton(
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedUser = newValue!;
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(
                      height: 0,
                    ),
                    items: userNameList
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPallete(),
                    MyButton(label: "Create Task", onTap: () => _validateDate())
                  ],
                ),
              ],
            ),
          )),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      print('object');
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
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

  _addTaskToDB() async {
    print('inside add task');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
        user: getUserId() ?? prefs.getInt("user"),
        project: prefs.getInt("project"),
      ),
    );
    inspect(value);
    print("my id is $value");
  }

  getUserId() {
    int counter = 0;
    for (var user in userNameList) {
      if (_selectedUser == user) {
        return counter;
      }
      counter++;
    }
    return null;
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : yellowClr,
                    child: _selectedColor == index
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _appBar(BuildContext context) {
    getUserData();
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
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
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  void getUserData() {
    setUser();
  }

  void setUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // inspect(_userController.getUser(id: preferences.getInt("user")));
    if (preferences.containsKey("user") && userIdList.length == 0 ||
        userNameList.length == 0) {
      _userController.getallUsers();
      inspect(_userController.UsersList);
      for (var user in _userController.UsersList) {
        userIdList.add(user.id!);
        userNameList.add(user.name!);
      }
      inspect(userIdList);
      inspect(userNameList);
      setState(() {
        userIdList;
        userNameList;
      });
    }
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2025));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        // print(_selectedDate);
      });
    } else {
      print('its null or somthing is wrong');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime == null) {
      print('Time Canceled');
    } else if (isStartTime == true) {
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final format = DateFormat.jm();
      String _formatedTime = format.format(dt).toString();
      // String _formatedTime = pickedTime.format(context).toString();
      // inspect(_formatedTime);
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      final now = DateTime.now();
      final dt = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      final format = DateFormat.jm();
      String _formatedTime = format.format(dt).toString();
      // String _formatedTime = pickedTime.format(context).toString();
      // print(_endTime);
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
