import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/globals/globals.dart';

class Contribute extends StatelessWidget {
  const Contribute({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Help PL grow !!',
              style: theme.textTheme.headline4,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'How to contribute ::',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20.0,
            ),
            const ListTile(
              leading: FaIcon(
                FontAwesomeIcons.diceOne,
                color: iconColor,
              ),
              title: Text(
                  'Upload your materials on Google Drive or a similar service. '),
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.diceTwo,
                color: iconColor,
              ),
              title: Text.rich(
                TextSpan(
                  text: 'Send the Google drive link to our page here.',
                  children: [
                    const TextSpan(text: '  '),
                    TextSpan(
                      text: 'https://www.facebook.com/thepltutorials',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Globals.launchURL(
                              'https://www.facebook.com/thepltutorials');
                        },
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.cyan),
                    ),
                  ],
                ),
              ),
            ),
            const ListTile(
              leading: FaIcon(
                FontAwesomeIcons.diceThree,
                color: iconColor,
              ),
              title: Text(
                  'The contents will be shared on PL Tutorials with credits to your name. '),
            ),
          ]),
        ),
      ),
    );
  }
}
