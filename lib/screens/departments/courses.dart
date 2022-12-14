import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/models/CourseData.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:plandroid/screens/devices/deviceGuard.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final AuthController authController = Get.find<AuthController>();
  List<Course> courses = List<Course>.empty(growable: true);
  List<AdditionalDatum> posts = List<AdditionalDatum>.empty(growable: true);
  bool _isLoading = false;

  Future<void> getCourses() async {
    if (kDebugMode) {
      print('get courses called');
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await Api().dio.get(
          "/departments/${Get.parameters['department']}/${Get.parameters['levelTerm']}");

      if (response.data != null) {
        CourseData courseData = CourseData.fromJson(response.data);

        if (kDebugMode) {
          print('=========additional data======');
          print(courseData.data.additionalData);
        }

        setState(() {
          courses.clear();
          courses.addAll(courseData.data.course);
          posts.clear();
          posts.addAll(courseData.data.additionalData);
        });

        if (kDebugMode) {
          print('course data data');
          print(courses.toString());
          print(courses.isEmpty);
        }
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }

      if (e.response?.statusCode == 422) {
        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: const Text("422: You do not have permission to access."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.close(2);
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );

        setState(() {
          courses.clear();
          posts.clear();
        });
      } else {
        String errData = Globals().formatText(
            e.response?.data['message'] ?? 'Something unknown occurred');
        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text("${e.response?.statusCode}: $errData"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = false;
      courses.clear();
      posts.clear();
      getCourses();
    });
  }

  @override
  void initState() {
    authController.isLoggedIn.listen((value) {
      if (kDebugMode) {
        print("logged in value in level term $value");
      }
      if (value) {
        getCourses();
      }
    });

    if (authController.isLoggedIn.value) {
      getCourses();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            inAsyncCall: _isLoading,
            opacity: 1.0,
            child: !authController.isLoggedIn.value
                ? const Login()
                : !authController.hasCheckedDevice.value
                    ? const DeviceGuardPage()
                    : RefreshIndicator(
                        onRefresh: () {
                          return _refresh();
                        },
                        child: GestureDetector(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (courses.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: SizedBox(
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        'Courses',
                                        style: theme.textTheme.headline5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],

                              if (courses.isEmpty) ...[
                                Center(
                                  child: Text(
                                    'No course found',
                                    style: theme.textTheme.headline5,
                                  ),
                                )
                              ],

                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: posts.length,
                                  itemBuilder: (ctx, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (kDebugMode) {
                                          print(posts[index].name);
                                        }

                                        Globals.downloadItem(
                                            model: posts[index].toJson(),
                                            postType: 'post',
                                            additionalData:
                                                "${Get.parameters['department']}/${Get.parameters['levelTerm']}");
                                      },
                                      child: Container(
                                        color: theme.cardColor.withOpacity(0.6),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: ListTile(
                                          leading: Container(
                                            decoration: BoxDecoration(
                                                color: theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(7.0)),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Center(
                                              child: Text(
                                                "${Get.parameters['department']}\n${Get.parameters['levelTerm']}"
                                                    .toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          title: Text(posts[index].name),
                                          subtitle: Text(posts[index].name),
                                        ),
                                      ),
                                    );
                                  }),

                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: courses.length,
                                  itemBuilder: (ctx, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (kDebugMode) {
                                          print(courses[index].slug);
                                        }

                                        Get.toNamed(
                                          "$postsPage/${Get.parameters['department']}/${Get.parameters['levelTerm']}/${courses[index].slug.toString()}",
                                        );
                                      },
                                      child: Container(
                                        color: theme.cardColor.withOpacity(0.6),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: ListTile(
                                          leading: Container(
                                            decoration: BoxDecoration(
                                                color: theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(7.0)),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Center(
                                              child: Text(
                                                "${Get.parameters['department']}\n${Get.parameters['levelTerm']}"
                                                    .toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                              Globals.generateCourseName(
                                                  courses[index]
                                                      .slug
                                                      .toUpperCase())),
                                          subtitle:
                                              Text(courses[index].courseName),
                                        ),
                                      ),
                                    );
                                  }),

                              

                              // Expanded(
                              //   child: courses.isEmpty
                              //       ? Center(
                              //           child: Text(
                              //             'No course found',
                              //             style: theme.textTheme.headline5,
                              //           ),
                              //         )
                              //       : ListView.builder(
                              //           itemCount: courses.length,
                              //           itemBuilder: (ctx, index) {
                              //             return InkWell(
                              //               onTap: () {
                              //                 if (kDebugMode) {
                              //                   print(courses[index].slug);
                              //                 }

                              //                 Get.toNamed(
                              //                   "$postsPage/${Get.parameters['department']}/${Get.parameters['levelTerm']}/${courses[index].slug.toString()}",
                              //                 );
                              //               },
                              //               child: Container(
                              //                 color: theme.cardColor
                              //                     .withOpacity(0.6),
                              //                 margin: const EdgeInsets.symmetric(
                              //                     vertical: 10.0),
                              //                 child: ListTile(
                              //                   leading: Container(
                              //                     decoration: BoxDecoration(
                              //                         color: theme.primaryColor,
                              //                         borderRadius:
                              //                             BorderRadius.circular(
                              //                                 7.0)),
                              //                     width: MediaQuery.of(context)
                              //                             .size
                              //                             .width *
                              //                         0.15,
                              //                     child: Center(
                              //                       child: Text(
                              //                         "${Get.parameters['department']}\n${Get.parameters['levelTerm']}"
                              //                             .toUpperCase(),
                              //                         textAlign: TextAlign.center,
                              //                         style: const TextStyle(
                              //                             color: Colors.white,
                              //                             fontWeight:
                              //                                 FontWeight.bold),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   title: Text(
                              //                       Globals.generateCourseName(
                              //                           courses[index]
                              //                               .slug
                              //                               .toUpperCase())),
                              //                   subtitle: Text(
                              //                       courses[index].courseName),
                              //                 ),
                              //               ),
                              //             );
                              //           }),
                              // ),
                              // Expanded(
                              //   child: posts.isEmpty
                              //       ? Center(
                              //           child: Text(
                              //             'No data found',
                              //             style: theme.textTheme.headline5,
                              //           ),
                              //         )
                              //       : ListView.builder(
                              //           itemCount: posts.length,
                              //           itemBuilder: (ctx, index) {
                              //             return InkWell(
                              //               onTap: () {
                              //                 if (kDebugMode) {
                              //                   print(posts[index].name);
                              //                 }

                              //                 Globals.downloadItem(
                              //                     model: posts[index].toJson(),
                              //                     postType: 'post',
                              //                     additionalData:
                              //                         "${Get.parameters['department']}/${Get.parameters['levelTerm']}}");
                              //               },
                              //               child: Container(
                              //                 color: theme.cardColor
                              //                     .withOpacity(0.6),
                              //                 margin: const EdgeInsets.symmetric(
                              //                     vertical: 10.0),
                              //                 child: ListTile(
                              //                   leading: Container(
                              //                     decoration: BoxDecoration(
                              //                         color: theme.primaryColor,
                              //                         borderRadius:
                              //                             BorderRadius.circular(
                              //                                 7.0)),
                              //                     width: MediaQuery.of(context)
                              //                             .size
                              //                             .width *
                              //                         0.15,
                              //                     child: Center(
                              //                       child: Text(
                              //                         Globals.generateCourseName(
                              //                                 Get.parameters[
                              //                                         'course'] ??
                              //                                     '')
                              //                             .replaceAll('-', '\n')
                              //                             .toUpperCase(),
                              //                         textAlign: TextAlign.center,
                              //                         style: const TextStyle(
                              //                             color: Colors.white,
                              //                             fontWeight:
                              //                                 FontWeight.bold),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   title: Text(posts[index].name),
                              //                   subtitle: Text(posts[index].name),
                              //                 ),
                              //               ),
                              //             );
                              //           }),
                              // ),
                            ],
                          ),
                        )),
                      ),
          ),
        ),
      ),
    );
  }
}
