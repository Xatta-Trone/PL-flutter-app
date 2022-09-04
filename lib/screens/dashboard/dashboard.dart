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
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Get Quote'),
              onPressed: () => {dashboardController.getQuote()},
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Text(
                      dashboardController.quote.value?.data.quote ?? '',
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      dashboardController.quote.value?.data.author ?? '',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
