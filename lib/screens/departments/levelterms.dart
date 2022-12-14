import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/constants/sharedPrefConstants.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/controller/DashboardController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/models/LevelTerms.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:plandroid/screens/devices/deviceGuard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelTerms extends StatefulWidget {
  // final String department;

  const LevelTerms({super.key});
  @override
  State<LevelTerms> createState() => _LevelTermsState();
}

class _LevelTermsState extends State<LevelTerms> {
  final AuthController authController = Get.find<AuthController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  List<Levelterm> levelTerms = List<Levelterm>.empty(growable: true);
  bool _isLoading = false;
  String? levelTermK = '';

  void getPinnedLevelTerm() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    var levelTerm = preference.get(levelTermPinKey);

    if (levelTerm != null) {
      setState(() {
        levelTermK =
            "${levelTerm.toString().split("/")[2]}/${levelTerm.toString().split("/").last}";
      });
    }
  }

  void setPinnedLevelTerm(String levelTermSlug) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    // ignore: non_constant_identifier_names
    String LTString =
        "$coursesPage/${Get.parameters['department']}/$levelTermSlug";
    preference.setString(levelTermPinKey, LTString);

    setState(() {
      levelTermK = "${Get.parameters['department']}/$levelTermSlug";
      dashboardController.levelTermString.value = LTString;
    });
    Get.showSnackbar(GetSnackBar(
      message: "$levelTermSlug pinned on homepage",
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> getLevelTerms() async {
    if (kDebugMode) {
      print('get level terms called');
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
  
    try {
      var response =
          await Api().dio.get("/departments/${Get.parameters['department']}");

      if (response.data != null) {
        LevelTermData deptData = LevelTermData.fromJson(response.data);

        // if (kDebugMode) {
        //   print(deptData.data.levelterms.toString());
        // }

        setState(() {
          levelTerms.clear();
          levelTerms.addAll(deptData.data.levelterms);
        });

        getPinnedLevelTerm();

        if (kDebugMode) {
          print('level term data');
          print(levelTerms.toString());
          print(levelTerms.isEmpty);
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
          levelTerms.clear();
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
      levelTerms.clear();
      getLevelTerms();
    });
  }

  @override
  void initState() {
    authController.isLoggedIn.listen((value) {
      if (kDebugMode) {
        print("logged in value in level term $value");
      }
      if (value) {
        getLevelTerms();
      }
    });

    if (authController.isLoggedIn.value) {
      getLevelTerms();
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // ignore: avoid_unnecessary_containers
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            opacity: 1.0,
            inAsyncCall: _isLoading,
            child: !authController.isLoggedIn.value
                ? const Login()
                : !authController.hasCheckedDevice.value
                    ? const DeviceGuardPage()
                    : RefreshIndicator(
                    onRefresh: () {
                      return _refresh();
                    },
                    child: Column(
                      children: [
                        if (levelTerms.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              height: 40.0,
                              child: Center(
                                  child: Text(
                                'Level Terms',
                                style: theme.textTheme.headline5,
                              )),
                            ),
                          ),
                          const Text(
                              'Double tap on a level term to pin on homepage'),
                        ],
                        Expanded(
                          child: levelTerms.isEmpty
                              ? Center(
                                  child: Text(
                                    'No level-term found',
                                    style: theme.textTheme.headline5,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: levelTerms.length,
                                  itemBuilder: (ctx, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (kDebugMode) {
                                          print(levelTerms[index].slug);
                                        }

                                        Get.toNamed(
                                          "$coursesPage/${Get.parameters['department']}/${levelTerms[index].slug.toString()}",
                                        );
                                      },
                                      onDoubleTap: () {
                                        setPinnedLevelTerm(
                                            levelTerms[index].slug);
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
                                                (Get.parameters['department'] ??
                                                        'X')
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          title: Text(levelTerms[index].slug),
                                          subtitle:
                                              Text(levelTerms[index].name),
                                          trailing:
                                              "${Get.parameters['department']}/${levelTerms[index].slug}" ==
                                                      levelTermK
                                                  ? FaIcon(
                                                      FontAwesomeIcons.fire,
                                                      color: theme
                                                          .primaryColorLight,
                                                    )
                                                  : null,
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
