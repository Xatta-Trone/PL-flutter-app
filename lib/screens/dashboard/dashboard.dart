import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/DashboardController.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Row(
                children: [
                  const Text(
                    '> ',
                    style: animatedText,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        dashboardController.getHello().toString(),
                        textStyle: animatedText,
                        speed: animatedTextDuration,
                      ),
                      TyperAnimatedText(
                        dashboardController.greetingText().toString(),
                        textStyle: animatedText,
                        speed: animatedTextDuration,
                      ),
                      TyperAnimatedText(
                        'How are you doing !!!',
                        textStyle: animatedText,
                        speed: animatedTextDuration,
                      ),
                      TyperAnimatedText(
                        'PL Tutorials',
                        textStyle: animatedText,
                        speed: animatedTextDuration,
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 100),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SvgPicture.asset(
                  "assets/images/hello3.svg",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: dashboardController.quote.value != null
                    ? Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(2, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15.0),
                    child: Column(
                      children: [
                        Text(
                          dashboardController.quote.value?.data.quote ?? '',
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "- ${dashboardController.quote.value?.data.author ?? ''}",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                      )
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
