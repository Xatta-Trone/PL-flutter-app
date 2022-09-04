import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plandroid/controller/DashboardController.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    return SafeArea(
      child: Center(
        child: Container(
          child: Obx(
            () => Text('${dashboardController.tabIndex.value} Dashboard'),
          ),
        ),
      ),
    );
  }
}
