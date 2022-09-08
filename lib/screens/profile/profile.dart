import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.chartColumn,
                        color: iconColor,
                      ),
                      title: const Text('Activity history'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('change password');
                        }
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.list,
                        color: iconColor,
                      ),
                      title: const Text('Login history'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('change password');
                        }
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.message,
                        color: iconColor,
                      ),
                      title: const Text('Contact us'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('change password');
                        }
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: iconColor,
                      ),
                      title: const Text('Follow us'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('follow us');
                        }
                        Globals.launchURL(
                            "https://www.facebook.com/thepltutorials");
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.laptop,
                        color: iconColor,
                      ),
                      title: const Text('Visit website'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () async {
                        if (kDebugMode) {
                          print('Visit website');
                        }
                        Globals.launchURL("https://pl-tutorials.com/");
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.android,
                        color: iconColor,
                      ),
                      title: const Text('App Info'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('App info');
                        }
                        Get.toNamed(appInfo);
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.bug,
                        color: iconColor,
                      ),
                      title: const Text('Report a bug'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('change password');
                        }
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.rotate,
                        color: iconColor,
                      ),
                      title: const Text('Check for updates'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: iconColor,
                        size: iconSize,
                      ),
                      onTap: () async {
                        final info = await PackageInfo.fromPlatform();
                        if (kDebugMode) {
                          print(
                              'https://play.google.com/store/apps/details?id=${info.packageName}');
                        }
                        Globals.launchURL(
                            "https://play.google.com/store/apps/details?id=${info.packageName}");
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
