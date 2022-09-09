import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/routes/routes.dart';
import 'package:plandroid/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: Colors.grey[200],
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        // ignore: prefer_const_constructors
        // elevatedButtonTheme: ElevatedButtonThemeData()
        
      ),
      initialRoute: homePage,
      getPages: appRoutes(),
      unknownRoute: unknownRoute(),
    );
  }
}
