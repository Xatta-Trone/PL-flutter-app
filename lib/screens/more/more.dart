import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/ThemeController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/routes/routeconst.dart';

class More extends StatelessWidget {
  More({Key? key}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              divider,
              Obx(
                () => ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.moon,
                  ),
                  title: const Text("Dark mode"),
                  trailing: Switch(
                    activeColor: theme.primaryColorLight,
                    
                    onChanged: (value) {
                      themeController.toggleDarkTheme(value: value);
                      if (kDebugMode) {
                        print('theme mode');
                        print(value);
                      }

                      Get.changeThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light);
                    },
                    value: themeController.isDarkTheme.value,
                  ),
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
                    print('Contact PL Tutorials');
                  }

                  Get.toNamed(contribute);
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.message,
                ),
                title: const Text('Contact PL Tutorials'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: iconSize,
                ),
                onTap: () {
                  if (kDebugMode) {
                    print('Contact PL Tutorials');
                  }

                  Get.toNamed(contact);
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.facebook,
                ),
                title: const Text('Follow PL Tutorials'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: iconSize,
                ),
                onTap: () {
                  if (kDebugMode) {
                    print('follow us');
                  }
                  Globals.launchURL("https://www.facebook.com/thepltutorials");
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.facebookMessenger,
                ),
                title: const Text('Send message'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: iconSize,
                ),
                onTap: () {
                  if (kDebugMode) {
                    print('follow us');
                  }
                  Globals.launchURL("https://m.me/thepltutorials");
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.laptop,
                ),
                title: const Text('Visit website'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
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
                  FontAwesomeIcons.youtube,
                ),
                title: const Text('Visit youtube'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: iconSize,
                ),
                onTap: () async {
                  if (kDebugMode) {
                    print('Visit youtube');
                  }
                  Globals.launchURL("https://www.youtube.com/c/PLTutorials");
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.question,
                ),
                title: const Text('Terms & Conditions'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: iconSize,
                ),
                onTap: () async {
                  if (kDebugMode) {
                    print('Visit terms');
                  }
                  Globals.launchURL("$homeUrl/page/terms-and-conditions");
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.userSecret,
                ),
                title: const Text('Privacy policy'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: iconSize,
                ),
                onTap: () async {
                  if (kDebugMode) {
                    print('Visit terms');
                  }
                  Globals.launchURL("$homeUrl/page/privacy-policy");
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.android,
                ),
                title: const Text('App Info'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
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
                ),
                title: const Text('Report a bug'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: iconSize,
                ),
                onTap: () {
                  if (kDebugMode) {
                    print('change password');
                  }
                  Get.toNamed(reportBug);
                },
              ),
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.rotate,
                ),
                title: const Text('Check for updates'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
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
              divider,
              ListTile(
                leading: const FaIcon(
                  FontAwesomeIcons.star,
                ),
                title: const Text('Rate the app'),
                trailing: const FaIcon(
                  FontAwesomeIcons.chevronRight,
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
              divider,
              const SizedBox(
                height: 80.0,
              ),
              const Text(
                '\u00a9 PL Tutorials Team',
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text.rich(
                TextSpan(
                  text: 'Developed and maintained by',
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: 'Xatta-Trone',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Globals.launchURL(
                              'https://www.facebook.com/monzurul.islam1112');
                        },
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.cyan),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: '(Github)',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Globals.launchURL('https://github.com/Xatta-Trone');
                        },
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 80.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
