import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plandroid/controller/AuthController.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final AuthController authController = Get.find<AuthController>();



    return SafeArea(
      child: Center(
        child: Obx(
          () => Column(
            children: [
              Text(authController.isLoggedIn.value.toString()),
              Text(authController.token.value.toString()),
              Text(authController.user.value?.user.name ?? ''),
              Text(authController.user.value?.user.studentId ?? ''),
              Text(authController.user.value?.user.email ?? ''),
              Text(authController.user.value?.user.createdAt.toString() ?? ''),
              Text(authController.user.value?.user.userLetter ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
