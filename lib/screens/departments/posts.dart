import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/models/PostData.dart';
import 'package:plandroid/screens/auth/Login.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final AuthController authController = Get.find<AuthController>();
  List<ActivePost> posts = List<ActivePost>.empty(growable: true);
  String courseName = 'Materials';
  bool _isLoading = false;

  Future<void> getPosts() async {
    if (kDebugMode) {
      print('get posts called');
    }
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await Api().dio.get(
          "/departments/${Get.parameters['department']}/${Get.parameters['levelTerm']}/${Get.parameters['course']}");

      if (response.data != null) {
        PostData postData = PostData.fromJson(response.data);

        setState(() {
          posts.clear();
          posts.addAll(postData.data.activePosts);
          courseName = postData.data.courseName;
        });

        if (kDebugMode) {
          print('post data');
          print(posts.toString());
          print(posts.isEmpty);
        }
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }

      if (e.response?.statusCode == 422) {
        Get.defaultDialog(
            title: "Error !!",
            middleText: "422: You do not have permission to access.",
            textConfirm: 'Okay',
            onConfirm: () {
              Get.close(2);
            });

        setState(() {
          posts.clear();
        });
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
      posts.clear();
      getPosts();
    });
  }

  @override
  void initState() {
    authController.isLoggedIn.listen((value) {
      if (kDebugMode) {
        print("logged in value in posts $value");
      }
      if (value) {
        getPosts();
      }
    });

    if (authController.isLoggedIn.value) {
      getPosts();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        opacity: 1.0,
        child: !authController.isLoggedIn.value
            ? const Login()
            : SafeArea(
                child: RefreshIndicator(
                onRefresh: () {
                  return _refresh();
                },
                child: GestureDetector(
                    child: Column(
                  children: [
                    if (posts.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          height: 40.0,
                          child: Center(
                            child: Text(
                              courseName,
                              style: theme.textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                    ],
                    Expanded(
                      child: posts.isEmpty
                          ? Center(
                              child: Text(
                                'No data found',
                                style: theme.textTheme.headline5,
                              ),
                            )
                          : ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (ctx, index) {
                                return InkWell(
                                  onTap: () {
                                    if (kDebugMode) {
                                      print(posts[index].name);
                                    }

                                    Globals.downloadItem(
                                        posts[index].toJson(), 'post');
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: ListTile(
                                      leading: Container(
                                        decoration: BoxDecoration(
                                            color: theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Center(
                                          child: Text(
                                            Globals.generateCourseName(
                                                    Get.parameters['course'] ??
                                                        '')
                                                .replaceAll('-', '\n')
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      title: Text(posts[index].name),
                                      subtitle: Text(posts[index].name),
                                    ),
                                  ),
                                );
                              }),
                    ),
                  ],
                )),
              )),
      ),
    );
  }
}
