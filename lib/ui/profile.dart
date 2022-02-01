import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myprojectmanager/controllers/user_controller.dart';
import 'package:myprojectmanager/models/user.dart';
import 'package:myprojectmanager/ui/register_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? Username = "user";
  String? Password = "password";
  String? Name = "name";
  final _userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.theme.primaryColor,
                  context.theme.primaryColorLight
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.5, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: context.theme.primaryColorLight,
                      minRadius: 60.0,
                      child: const CircleAvatar(
                        radius: 50.0,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Colors.red.shade300,
                        minRadius: 35.0,
                        child: Icon(
                          Icons.logout,
                          size: 30.0,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        Get.to(() => RegisterPage());
                        preferences.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  Name!,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Divider(
                color: context.theme.dividerColor,
              ),
              ListTile(
                title: Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  Username!,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  Password!,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _appBar() {
    getUserData();
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.primaryColor,
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
    );
  }

  void getUserData() {
    setUser();
  }

  void setUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // inspect(_userController.getUser(id: preferences.getInt("user")));
    if (preferences.containsKey("user")) {
      _userController.getUser(id: preferences.getInt("user")!);
      setState(() {
        Username = preferences.getString("username");
        Name = preferences.getString("name");
        Password = preferences.getString("userpassword");
      });
    }
  }
}
