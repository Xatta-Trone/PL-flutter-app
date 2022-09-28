import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/models/UserActivityData.dart';
import 'package:plandroid/models/UserDevicesData.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserActivitiesPage extends StatefulWidget {
  const UserActivitiesPage({Key? key}) : super(key: key);

  @override
  State<UserActivitiesPage> createState() => _UserActivitiesPageState();
}

final AuthController authController = Get.find<AuthController>();

class _UserActivitiesPageState extends State<UserActivitiesPage> {
  List<UserActivity> activities = List<UserActivity>.empty(growable: true);
  static const _pageSize = 50;
  int _page = 1;
  final scrollController = ScrollController();
  bool _hasMore = false;
  bool _isLoading = false;
  bool _isInitiallyLoaded = false;
  String fingerprint = '';

  IconData getIcon({String deviceString = 'none'}) {
    if (deviceString.toLowerCase().contains('search')) {
      return FontAwesomeIcons.magnifyingGlass;
    }
    if (deviceString.toLowerCase().contains('download')) {
      return FontAwesomeIcons.download;
    }

    return FontAwesomeIcons.chartColumn;
  }

  Map<String, String> getQueryParams({bool isLoadingMore = false}) {
    return {
      'query': '',
      'page': _page.toString(),
      'limit': _pageSize.toString(),
      'ascending': 0.toString(),
      'byColumn': 0.toString(),
    };
  }

  Future<void> searchActivity({bool isSearching = true}) async {
    if (kDebugMode) {
      print('user activity search  called');
    }

    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Api()
          .dio
          .get('/user-activity', queryParameters: getQueryParams());

      if (response.data != null) {
        if (kDebugMode) {
          // print("count ${response.data}");
        }

        setState(() {
          if (isSearching) {
            activities.clear();
            if (scrollController.hasClients) {
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut);
            }
          }

          UserActivityData activityData =
              UserActivityData.fromJson(response.data);

          // set the books data
          activities.addAll(activityData.data);
          if (!_isInitiallyLoaded) {
            _isInitiallyLoaded = true;
          }

          //  set the data's
          _page++;

          if (activityData.data.length < _pageSize) {
            _hasMore = false;
          } else {
            _hasMore = true;
            // _page++;
          }

          if (kDebugMode) {
            print('page size');
            print(activityData.data.length);
            print(activityData.data.length < _pageSize);
            print(_hasMore);
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        _isInitiallyLoaded = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _loadMore() async {
    // searchActivity(isSearching: false);
    if (kDebugMode) {
      print('Loadmore called');
    }
    if (!_hasMore) {
      return;
    }

    searchActivity(isSearching: false);
  }

  Future<void> _refreshData() async {
    setState(() {
      _page = 1;
      _hasMore = true;
      _isLoading = false;
      _isInitiallyLoaded = false;
      searchActivity();
    });
  }

  @override
  void initState() {
    authController.isLoggedIn.listen((value) {
      if (kDebugMode) {
        print("logged in value from devices $value");
      }
      if (value) {
        searchActivity();
      } else {}
    });

    searchActivity();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (kDebugMode) {
          print('reached end');
        }
        _loadMore();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BookController bookController = Get.put(BookController());
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => !authController.isLoggedIn.value
              ? const Login()
              : _isLoading && !_isInitiallyLoaded
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    )
                  : Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Activities',
                      style: theme.textTheme.titleLarge,
                    ),
                   
                    Expanded(
                      child: !_hasMore && activities.isEmpty
                          ? const Center(
                              child: Text('No data found'),
                            )
                          : RefreshIndicator(
                              onRefresh: () {
                                return _refreshData();
                              },
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: activities.length + 1,
                                itemBuilder: (context, index) {
                                  if (kDebugMode) {
                                    // print("index $index");
                                  }
                                  // check if it is the last item
                                  if (index == activities.length) {
                                    // check if more data could not be loaded
                                    if (_hasMore == false) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'End of list',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                        ),
                                      );
                                    }

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                              child: CircularProgressIndicator(
                                            color: theme.primaryColor,
                                          )),
                                    );
                                  }

                                  if (activities.isNotEmpty) {
                                    return Container(
                                          color:
                                              theme.cardColor.withOpacity(0.6),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                      ),
                                      child: ListTile(
                                        leading: Container(
                                          decoration: BoxDecoration(
                                            color: theme.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Center(
                                            child: FaIcon(
                                              getIcon(
                                                deviceString:
                                                    activities[index]
                                                        .activity
                                                        .toString(),
                                              ),
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                        title: Text(activities[index]
                                            .activity
                                            .toString(),),
                                        subtitle: Text(
                                          activities[index].label,
                                        ),
                                            trailing: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Text(timeago.format(
                                              activities[index].createdAt,
                                              locale: 'en_short')),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                        child: Text('No data found'));
                                  }
                                },
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
