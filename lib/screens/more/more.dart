import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/routes/routeconst.dart';

class More extends StatelessWidget {
  const More({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          divider,
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.message,
              color: iconColor,
            ),
            title: const Text('Contact PL Tutorials'),
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
            title: const Text('Follow PL Tutorials'),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              color: iconColor,
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
          divider,
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.star,
              color: iconColor,
            ),
            title: const Text('Rate the app'),
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
          divider,
          const SizedBox(
            height: 15.0,
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
                      Globals.launchURL(
                          'https://github.com/Xatta-Trone');
                    },
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
