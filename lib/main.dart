import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myprojectmanager/services/theme_services.dart';
import 'package:myprojectmanager/ui/home_page.dart';
import 'package:myprojectmanager/ui/register_page.dart';
import 'package:myprojectmanager/ui/theme.dart';
import 'package:get/get.dart';
import 'package:myprojectmanager/db/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await DBHelper.initDb();
  runApp(const MyApp());
}

// void async; initPackages() async {
// WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Project Manager',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: RegisterPage(),
    );
  }
}
