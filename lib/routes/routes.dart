import 'package:get/get.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/404/404.dart';
import 'package:plandroid/screens/appinfo/appinfo.dart';
import 'package:plandroid/screens/auth/ChangePassword.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:plandroid/screens/auth/Register.dart';
import 'package:plandroid/screens/auth/requestPassword.dart';
import 'package:plandroid/screens/books/books.dart';
import 'package:plandroid/screens/dashboard/dashboard.dart';
import 'package:plandroid/screens/departments/departments.dart';
import 'package:plandroid/screens/departments/levelterms.dart';
import 'package:plandroid/screens/home.dart';
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
        name: profilePage,
        page: () => const Profile(),
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
    ];

unknownRoute() => GetPage(
      name: notFoundPage,
      page: () => const Unknown404(),
    );

class MyMiddelware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    print(page?.name);
    return super.onPageCalled(page);
  }
}
