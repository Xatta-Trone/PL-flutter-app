import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: const Color(0xfff6f8fa),
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
      // initialBinding: InitialBindings(),
    );
  }
}
