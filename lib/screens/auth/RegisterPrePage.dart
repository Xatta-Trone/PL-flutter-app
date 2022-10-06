import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/routes/routeconst.dart';

class RegisterPrePage extends StatefulWidget {
  const RegisterPrePage({super.key});

  @override
  State<RegisterPrePage> createState() => _RegisterPrePageState();
}

class _RegisterPrePageState extends State<RegisterPrePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  'Choose your category',
                  style: theme.textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            divider,
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    Get.toNamed(register);
                  },
                  child: Center(
                      child: Text(
                    'Current undergrad student',
                    style: theme.textTheme.headline5,
                  ))),
            ),
            divider,
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    Get.to(() => AlumniWidget(
                          txtTheme: theme.textTheme,
                        ));
                  },
                  child: Center(
                      child: Text(
                    'Alumni/ foreign student',
                    style: theme.textTheme.headline5,
                  ))),
            ),
            divider,
            Expanded(
              flex: 1,
              child: InkWell(
                  onTap: () {
                    Get.to(() => OutsiderWidget(
                          txtTheme: theme.textTheme,
                        ));
                  },
                  child: Center(
                      child: Text(
                    'Non-buetian',
                    style: theme.textTheme.headline5,
                  ))),
            ),
          ],
        ),
      ),
    );
  }
}

class OutsiderWidget extends StatelessWidget {
  const OutsiderWidget({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StudentMsg(
            txtTheme: txtTheme,
            text:
                'Sorry, This website is only for the undergrad students of BUET. \n However, the books section is open for all. \n Thank you for your understanding.\n🙇‍♂️',
          ),
        ),
      ),
    );
  }
}

class AlumniWidget extends StatelessWidget {
  const AlumniWidget({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StudentMsg(
                txtTheme: txtTheme,
                text:
                    'Please send a message to our FB page with your student id and email address. ',
              ),
              const SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (kDebugMode) {
                    print('follow us');
                  }
                  Globals.launchURL("https://www.facebook.com/thepltutorials");
                },
                child: const Text(
                  'Go to FB page',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StudentMsg extends StatelessWidget {
  const StudentMsg({
    Key? key,
    required this.txtTheme,
    required this.text,
  }) : super(key: key);

  final TextTheme txtTheme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: txtTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
