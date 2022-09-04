import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/DashboardController.dart';
import 'package:plandroid/screens/books/books.dart';
import 'package:plandroid/screens/dashboard/dashboard.dart';
import 'package:plandroid/screens/departments/departments.dart';
import 'package:plandroid/screens/profile/profile.dart';
import 'package:plandroid/screens/search/search.dart';
import 'package:plandroid/screens/settings/settings.dart';
import 'package:plandroid/screens/softwares/softwares.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    return SafeArea(
      child: Scaffold(
          body: Obx(
            () => IndexedStack(
              index: dashboardController.tabIndex.value,
              children: const [
                Dashboard(),
                Departments(),
                Books(),
                Softwares(),
                Profile(),
                Settings(),
              ],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: dashboardController.tabIndex.value,
              onTap: dashboardController.changeTabIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: selectedColor,
              unselectedItemColor: unSelectedColor,
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
                    FontAwesomeIcons.bookOpen,
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
                    FontAwesomeIcons.gear,
                    size: iconSize,
                  ),
                  label: 'Settings',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print('search clicked');
              Get.to(const Search());
            },
            child: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          )),
    );
  }
}
