import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plandroid/bindings/Initialbindings.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/controller/ThemeController.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    // Get.changeThemeMode(
    //     themeController.isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeController themeController = Get.put(ThemeController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Obx(
      () => GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          brightness: Brightness.light,
          fontFamily: 'Nunito',
          scaffoldBackgroundColor: const Color(0xfff6f8fa),
          // ignore: prefer_const_constructors
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.cyan,
            unselectedItemColor: Colors.grey[600],
            elevation: 10.0,
          ),
          cardColor: Colors.white,
          // backgroundColor:
          // ignore: prefer_const_constructors
          // elevatedButtonTheme: ElevatedButtonThemeData()
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.cyan,
          fontFamily: 'Nunito',
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[800],
            selectedItemColor: Colors.grey[900],
            unselectedItemColor: Colors.grey[600],
            elevation: 10.0,
          ),
          cardColor: Colors.grey[850],
          scaffoldBackgroundColor: Colors.grey[900],
        ),
        themeMode: themeController.isDarkTheme.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: homePage,
        getPages: appRoutes(),
        unknownRoute: unknownRoute(),
        // initialBinding: InitialBindings(),
      ),
    );
  }
}
