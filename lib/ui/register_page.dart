// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectmanager/controllers/user_controller.dart';
import 'package:myprojectmanager/models/user.dart';
import 'package:myprojectmanager/ui/login_page.dart';
import 'package:myprojectmanager/ui/theme.dart';
import 'package:myprojectmanager/ui/widgets/button.dart';
import 'package:myprojectmanager/ui/widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final UserController _userController = Get.put(UserController());
  TextEditingController _nameController = TextEditingController();
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
                  'REGISTER'.toUpperCase(),
                  style: titleStyle.copyWith(fontSize: 25, color: primaryClr),
                ),
              ),
              SizedBox(height: 10),

              MyInputField(
                title: "Name",
                hint: "Like Mohammed Taj",
                controller: _nameController,
              ),
              SizedBox(height: 10),

              MyInputField(
                title: "Username",
                hint: "Like hello@user etc",
                controller: _usernameController,
              ),
              SizedBox(height: 10),
              MyInputField(
                title: "Password",
                hint: "",
                controller: _passwordController,
              ),
              SizedBox(height: 50),
              // ignore: deprecated_member_use
              MyButton(
                label: "SIGN UP",
                onTap: () {
                  _validateFields();
                  Get.to(() => LoginPage());
                },
                width: size.width,
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '''Already have an account?''',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(LoginPage()),
                    child: Text(
                      'Sign in',
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

  _validateFields() {
    if (_passwordController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _usernameController.text.isEmpty) {
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
      if (_passwordController.text.isNotEmpty ||
          _nameController.text.isNotEmpty ||
          _usernameController.text.isNotEmpty) {
        _addUser(User(
          name: _nameController.text,
          username: _usernameController.text,
          password: _passwordController.text,
        ));
        _passwordController.text = '';
        _nameController.text = '';
        _usernameController.text = '';
      }
    }
  }

  _addUser(User user) async {
    int id = await _userController.addUser(
        user: User(
      name: _nameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    ));
    inspect(id);
  }
}
