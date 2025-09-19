import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volei_app/database/db.dart';
import 'package:volei_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SqliteDatabase().open();
  // await SqliteDatabase().delete();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Flutter Demo',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: HomePage());
  }
}
