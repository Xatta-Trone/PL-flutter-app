
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/auth/Login.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Obx(
        () => !authController.isLoggedIn.value
            ? const Login()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: screenSize.height * 0.3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 2,
                            offset: const Offset(2, 4), // Shadow position
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              maxRadius: 43,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                maxRadius: 40,
                                child: Text(
                                  authController.user.value?.user.userLetter ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "#${authController.user.value?.user.studentId ?? ''}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                     
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.signature,
                        color: iconColor,
                      ),
                      title: Text(
                        authController.user.value?.user.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.envelope,
                        color: iconColor,
                      ),
                      title: Text(
                        authController.user.value?.user.email ?? '',
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.calendarDays,
                        color: iconColor,
                      ),
                      title: Text(
                        authController.getCreateAt(),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                    divider,
                    ListTile(
                        leading: const FaIcon(
                          FontAwesomeIcons.rightFromBracket,
                          color: iconColor,
                        ),
                        title: const Text('Logout'),
                        trailing: const FaIcon(
                          FontAwesomeIcons.chevronRight,
                          color: iconColor,
                          size: iconSize,
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                // backgroundColor: Colors.grey[900],
                                title: const Text('Are you sure!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Navigator.of(context).pop();
                                      Get.back();
                                    },
                                    child: const Text('NO'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      authController.logout();
                                    },
                                    child: const Text('YES'),
                                  )
                                ],
                              );
                            },
                          );
                        }),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.lock,
                        color: iconColor,
                      ),
                      title: const Text('Change password'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('change password');
                        }
                        Get.toNamed(changeCurrentPassword);
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.chartColumn,
                        color: iconColor,
                      ),
                      title: const Text('Activity'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        Get.toNamed(userActivity);
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.houseLaptop,
                        color: iconColor,
                      ),
                      title: const Text('Devices'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('devices clicked');
                        }
                        Get.toNamed(userDevices);
                      },
                    ),
                    divider,
                    const ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.info,
                        color: iconColor,
                      ),
                      title: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Text(
                          'Please refrain from sharing your account with others. Such activity may lead to permanent account suspension. The website constantly monitors all activities to prevent account sharing. You can see your activities from the Activity section.',
                          textScaleFactor: 0.85,
                          softWrap: true,
                          style: TextStyle(color: Colors.cyan)
                        ),
                      ),
                      trailing:  FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.transparent,
                        size: iconSize,
                      ),
                    ),
                    divider,
                   
                    
                  ],
                ),
              ),
      ),
    );
  }
}
