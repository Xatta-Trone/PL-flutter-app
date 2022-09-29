import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/controller/BottomNavigationBarController.dart';
import 'package:plandroid/controller/DashboardController.dart';
import 'package:plandroid/controller/ThemeController.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/books/books.dart';
import 'package:plandroid/screens/dashboard/dashboard.dart';
import 'package:plandroid/screens/departments/departments.dart';
import 'package:plandroid/screens/more/more.dart';
import 'package:plandroid/screens/profile/profile.dart';
import 'package:plandroid/screens/softwares/softwares.dart';
import 'package:upgrader/upgrader.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    
    DateTime _lastExitTime = DateTime.now();
    
    final BottomNavigationBarController botNavController =
        Get.put(BottomNavigationBarController());

    final DashboardController dashboardController =
        Get.put(DashboardController());

    final AuthController authController = Get.put(AuthController());
    ThemeController themeController = Get.find<ThemeController>();

    ThemeData themeData = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastExitTime) >=
            const Duration(seconds: 2)) {
          _lastExitTime = DateTime.now();
          var snack = const SnackBar(
            content: Text("Press the back button again to exist the app"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: UpgradeAlert(
            child: Obx(
              () => IndexedStack(
                index: botNavController.tabIndex.value,
                children: [
                  const Dashboard(),
                  const Departments(),
                  const Books(),
                  const Softwares(),
                  const Profile(),
                  More(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: botNavController.tabIndex.value,
              onTap: botNavController.changeTabIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              // selectedItemColor: themeData.primaryColor,
              // unselectedItemColor: themeData.unselectedWidgetColor,
              type: BottomNavigationBarType.fixed,
              // backgroundColor: themeData.backgroundColor,
              items: const [
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.house,
                    size: iconSize,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.list,
                    size: iconSize,
                  ),
                  label: 'Department',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.book,
                    size: iconSize,
                  ),
                  label: 'Books',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.laptopCode,
                    size: iconSize,
                  ),
                  label: 'Softwares',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.userLarge,
                    size: iconSize,
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.barcode,
                    size: iconSize,
                  ),
                  label: 'More',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'search',
            onPressed: () {
              if (kDebugMode) {
                print('search clicked');
              }
              Get.toNamed(searchPage);
            },
            child: const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: iconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
