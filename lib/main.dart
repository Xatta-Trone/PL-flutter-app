import 'dart:ffi';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plandroid/bindings/Initialbindings.dart';
import 'package:plandroid/constants/const.dart';
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
    return GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          brightness: Brightness.light,
          fontFamily: 'Nunito',
          scaffoldBackgroundColor: const Color(0xfff6f8fa),
        primaryColorLight: Colors.cyan,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.cyan,
            unselectedItemColor: Colors.grey[600],
            elevation: 10.0,
          ),
          cardColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            fillColor: Colors.white,
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.cyan,
          ),

          dividerColor: Colors.grey[200],

            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.cyan),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.white),
              ),
        ),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
          backgroundColor: Colors.cyan,
        ),

        

          
       
        
         
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.cyan,
          primaryColorLight: Colors.grey,
          fontFamily: 'Nunito',
        
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[800],
            selectedItemColor: Colors.grey[100],
            unselectedItemColor: Colors.grey[600],
            elevation: 10.0,
          ),
          cardColor: Colors.grey[900],
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[800],
          ),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white70,
          ),
          dividerColor: Colors.grey[800],

            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.white),
              ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.white),
          ),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.grey[600]),

          // scaffoldBackgroundColor: Colors.grey[900],
        ),
        themeMode: themeController.isDarkTheme.value
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: homePage,
        getPages: appRoutes(),
        unknownRoute: unknownRoute(),
        // initialBinding: InitialBindings(),
      
    );
  }
}
