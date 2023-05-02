import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _dismissText = false;

  void getDismissTextStatus() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    var value = preference.getBool('_dismissText');

    if (value != null) {
      setState(() {
        _dismissText = value;
      });
    }
  }

  void setDismissTextStatus() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    preference.setBool('_dismissText', true);

    setState(() {
      _dismissText = true;
    });
  }

  @override
  void initState() {
    getDismissTextStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    ThemeData theme = Theme.of(context);

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
                        color: theme.primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.1),
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
                                backgroundColor: theme.primaryColor,
                                maxRadius: 40,
                                child: Text(
                                  authController.user.value?.user.userLetter ??
                                      '',
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
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
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,
                    if (_dismissText == false) ...[
                      Dismissible(
                        key: UniqueKey(),
                        onDismissed: (DismissDirection direction) {
                          setDismissTextStatus();
                          if (kDebugMode) {
                            print(direction);
                          }
                        },
                        child: ListTile(
                          trailing: const SizedBox(
                            height: double.infinity,
                            child: Icon(
                              FontAwesomeIcons.arrowRightLong,
                            ),
                          ),
                          leading: const SizedBox(
                            height: double.infinity,
                            child: Icon(
                              FontAwesomeIcons.arrowLeftLong,
                            ),
                          ),
                          title: Text(
                            'Please refrain from sharing your account with others. Such activity may lead to permanent account suspension. The website constantly monitors all activities to prevent account sharing. You can see your activities from the Activity section.',
                            textScaleFactor: 0.8,
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: Colors.redAccent),
                          ),
                        ),
                      )
                    ],
                    divider,
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.signature,
                      ),
                      title: Text(
                        authController.user.value?.user.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    divider,
                    ListTile(
                      leading: const Icon(
                        FontAwesomeIcons.envelope,
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
                        FontAwesomeIcons.circlePlus,
                      ),
                      title: const Text('Contribute materials'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('contribute');
                        }
                        Get.toNamed(contribute);
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.chartColumn,
                      ),
                      title: const Text('Activity log'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
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
                      ),
                      title: const Text('Device log'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
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
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.laptopFile,
                      ),
                      title: const Text('Saved devices'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: iconSize,
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print('saved devices');
                        }
                        Get.toNamed(userListedDevices);
                      },
                    ),
                    divider,
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.lock,
                      ),
                      title: const Text('Change password'),
                      trailing: const FaIcon(
                        FontAwesomeIcons.chevronRight,
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
                        leading: const Icon(
                          FontAwesomeIcons.rightFromBracket,
                        ),
                        title: const Text('Logout'),
                        trailing: const FaIcon(
                          FontAwesomeIcons.chevronRight,
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
                                    child: const Text(
                                      'NO',
                                    ),
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
                  ],
                ),
              ),
      ),
    );
  }
}
