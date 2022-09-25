import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/404/404.dart';
import 'package:plandroid/screens/appinfo/appinfo.dart';
import 'package:plandroid/screens/auth/ChangePassword.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:plandroid/screens/auth/Register.dart';
import 'package:plandroid/screens/auth/requestPassword.dart';
import 'package:plandroid/screens/books/books.dart';
import 'package:plandroid/screens/dashboard/dashboard.dart';
import 'package:plandroid/screens/departments/courses.dart';
import 'package:plandroid/screens/departments/departments.dart';
import 'package:plandroid/screens/departments/levelterms.dart';
import 'package:plandroid/screens/departments/posts.dart';
import 'package:plandroid/screens/devices/devices.dart';
import 'package:plandroid/screens/home.dart';
import 'package:plandroid/screens/more/contact.dart';
import 'package:plandroid/screens/more/more.dart';
import 'package:plandroid/screens/more/reportBug.dart';
import 'package:plandroid/screens/profile/activity.dart';
import 'package:plandroid/screens/profile/changeCurrentPassword.dart';
import 'package:plandroid/screens/profile/device.dart';
import 'package:plandroid/screens/profile/profile.dart';
import 'package:plandroid/screens/search/search.dart';
import 'package:plandroid/screens/settings/settings.dart';
import 'package:plandroid/screens/softwares/softwares.dart';

appRoutes() => [
      GetPage(
        name: homePage,
        page: () => Home(),
        // transition: Transition.leftToRightWithFade,
        // transitionDuration: Duration(milliseconds: 500),
      ),
      GetPage(
        name: booksPage,
        page: () => const Books(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: softwaresPage,
        page: () => const Softwares(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: departmentsPage,
        page: () => const Departments(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: "$levelTermsPage/:department",
        page: () => const LevelTerms(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: "$coursesPage/:department/:levelTerm",
        page: () => const Courses(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: "$postsPage/:department/:levelTerm/:course",
        page: () => const Post(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: profilePage,
        page: () => const Profile(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: userDevices,
        page: () => const UserDevices(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: userActivity,
        page: () => const UserActivitiesPage(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: searchPage,
        page: () => const Search(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: settingsPage,
        page: () => const Settings(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: notFoundPage,
        page: () => const Unknown404(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: dashboardPage,
        page: () => const Dashboard(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: appInfo,
        page: () => const AppInfo(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: login,
        page: () => const Login(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: register,
        page: () => const Register(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: requestPassword,
        page: () => const RequestPassword(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: changePassword,
        page: () => const ChangePassword(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: changeCurrentPassword,
        page: () => const ChangeCurrentPassword(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: more,
        page: () => const More(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: contact,
        page: () => const ContactPage(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: reportBug,
        page: () => const ReportBugPage(),
        middlewares: [MyMiddelware()],
      ),
      GetPage(
        name: userListedDevices,
        page: () => const UserListedDevices(),
        middlewares: [MyMiddelware()],
      ),
    ];

unknownRoute() => GetPage(
      name: notFoundPage,
      page: () => const Unknown404(),
    );

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    if (kDebugMode) {
      print(page?.name);
    }
    return super.onPageCalled(page);
  }
}


class AuthGuard extends GetMiddleware {
//   Get the auth service
  final AuthController authController = Get.find<AuthController>();

//   The default is 0 but you can update it to any number. Please ensure you match the priority based
//   on the number of guards you have.
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Navigate to login if client is not authenticated other wise continue
    // if (authController.isAuthenticated) return RouteSettings(name: AppLinks.LOGIN);
    // return RouteSettings(name: AppLinks.DASHBOARD);
  }
}
