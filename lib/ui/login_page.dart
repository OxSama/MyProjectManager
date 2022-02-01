// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myprojectmanager/controllers/user_controller.dart';
import 'package:myprojectmanager/models/user.dart';
import 'package:myprojectmanager/ui/home_page.dart';
import 'package:myprojectmanager/ui/register_page.dart';
import 'package:myprojectmanager/ui/theme.dart';
import 'package:myprojectmanager/ui/widgets/button.dart';
import 'package:myprojectmanager/ui/widgets/input_field.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserController _userController = Get.put(UserController());
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  'LOGIN'.toUpperCase(),
                  style: titleStyle.copyWith(fontSize: 25, color: primaryClr),
                ),
              ),
              SizedBox(height: 20),
              MyInputField(
                title: "Username",
                hint: "Your Username",
                controller: _usernameController,
              ),
              SizedBox(height: 10),
              MyInputField(
                title: "Password",
                hint: "",
                controller: _passwordController,
              ),
              SizedBox(height: 20),
              SizedBox(height: 50),
              MyButton(
                label: "LOGIN",
                onTap: () {
                  _validateLogin();
                },
                width: size.width,
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '''Don't have account?''',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateLogin() {
    inspect(_passwordController.text);
    inspect(_usernameController.text);
    if (_passwordController.text.isEmpty || _usernameController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All field are required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: primaryClr,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.blue[300],
        ),
      );
    } else {
      if (_passwordController.text.isNotEmpty &&
          _usernameController.text.isNotEmpty) {
        login();
        _passwordController.text = '';
        _usernameController.text = '';
      }
    }
  }

  login() async {
    User? user = await _userController.Login(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    if (user.id == 0) {
      _usernameController.text = '';
      _passwordController.text = '';
      Get.snackbar(
        "Wrong Credintials",
        "Check username or password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("user", user.id ?? 0);
      prefs.setString("username", user.username ?? "0");
      prefs.setString("name", user.name ?? "0");
      prefs.setString("userpassword", user.password ?? "0");
      inspect(prefs.get("user"));
      Get.to(() => MainPage());
    }
  }
}
