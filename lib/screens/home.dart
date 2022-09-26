import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/controller/BottomNavigationBarController.dart';
import 'package:plandroid/controller/DashboardController.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/books/books.dart';
import 'package:plandroid/screens/dashboard/dashboard.dart';
import 'package:plandroid/screens/departments/departments.dart';
import 'package:plandroid/screens/more/more.dart';
import 'package:plandroid/screens/profile/profile.dart';
import 'package:plandroid/screens/search/search.dart';
import 'package:plandroid/screens/settings/settings.dart';
import 'package:plandroid/screens/softwares/softwares.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarController botNavController =
        Get.put(BottomNavigationBarController());

    final DashboardController dashboardController =
        Get.put(DashboardController());

    final AuthController authController = Get.put(AuthController());

    return SafeArea(
      child: Scaffold(
          body: Obx(
            () => IndexedStack(
              index: botNavController.tabIndex.value,
              children: const [
                Dashboard(),
                Departments(),
                Books(),
                Softwares(),
                Profile(),
                More(),
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: botNavController.tabIndex.value,
              onTap: botNavController.changeTabIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.cyan,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              backgroundColor: bottomBgColor,
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
          )),
    );
  }
}
