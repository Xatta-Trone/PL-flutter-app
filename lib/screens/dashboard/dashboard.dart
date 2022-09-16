import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/controller/DashboardController.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.find<DashboardController>();
    ThemeData theme = Theme.of(context);
    Size mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 30.0,
                ),
                child: Text(
                  '${dashboardController.getHello().toString()} ${dashboardController.greetingText().toString()}',
                  style: theme.textTheme.headline5
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 30.0, top: 5.0),
                child: Text(
                  'How are you doing ?',
                  style:
                      theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SingleDataComponent(
                      mediaQuery: mediaQuery,
                      dashboardController: dashboardController,
                      theme: theme,
                      icon: FontAwesomeIcons.graduationCap,
                      number: dashboardController.countData.value?.data
                              .formatUser() ??
                          '',
                    ),
                    SingleDataComponent(
                      mediaQuery: mediaQuery,
                      dashboardController: dashboardController,
                      theme: theme,
                      icon: FontAwesomeIcons.book,
                      number: dashboardController.countData.value?.data
                              .formatBooks() ??
                          '',
                    ),
                    SingleDataComponent(
                      mediaQuery: mediaQuery,
                      dashboardController: dashboardController,
                      theme: theme,
                      icon: FontAwesomeIcons.laptopCode,
                      number: dashboardController.countData.value?.data
                              .formatSoftwares() ??
                          '',
                    ),
                    SingleDataComponent(
                      mediaQuery: mediaQuery,
                      dashboardController: dashboardController,
                      theme: theme,
                      icon: FontAwesomeIcons.cloudArrowDown,
                      number: dashboardController.countData.value?.data
                              .formatDownloads() ??
                          '',
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),

              InkWell(
                onTap: () {
                  if (kDebugMode) {
                    print('tapped');
                  }
                },
                child: Container(
                  height: mediaQuery.height * 0.1,
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: dashboardController.randomColor(),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(2, 4), // Shadow position
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Double tap on a level term to pin that here',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline6
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),


              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  child: dashboardController.quote.value != null
                      ? Container(
                          decoration: BoxDecoration(
                            color: dashboardController.randomColor(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
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
                              vertical: 15.0,
                              horizontal: 15.0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  dashboardController.quote.value?.data.quote ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
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
              ),
              const SizedBox(
                height: 10.0,
              ),
              Obx(
                () => CarouselSlider(
                  options: CarouselOptions(
                    height: mediaQuery.height * 0.3,
                  ),
                  items: dashboardController.testimonials.map((testimonial) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: mediaQuery.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: dashboardController.randomColor(),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      testimonial.userLetter,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  title: Text(testimonial.name,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  trailing: Text(testimonial.deptBatch,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Text(
                                    testimonial.message,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ));
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleDataComponent extends StatelessWidget {
  const SingleDataComponent({
    Key? key,
    required this.mediaQuery,
    required this.dashboardController,
    required this.theme,
    required this.icon,
    required this.number,
  }) : super(key: key);

  final Size mediaQuery;
  final DashboardController dashboardController;
  final ThemeData theme;
  final IconData icon;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: mediaQuery.width * 0.22,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: dashboardController.randomColor(),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          FaIcon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            number,
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          // Text(
          //   'USERS',
          //   style: theme.textTheme.titleLarge
          //       ?.copyWith(color: Colors.white),
          // ),
        ],
      ),
    );
  }
}
