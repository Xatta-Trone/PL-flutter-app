import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/models/UserDevicesData.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserDevices extends StatefulWidget {
  const UserDevices({Key? key}) : super(key: key);

  @override
  State<UserDevices> createState() => _UserDevicesState();
}

final AuthController authController = Get.find<AuthController>();

class _UserDevicesState extends State<UserDevices> {
  List<UserDevice> devices = List<UserDevice>.empty(growable: true);
  static const _pageSize = 50;
  int _page = 1;
  final scrollController = ScrollController();
  bool _hasMore = false;
  bool _isLoading = false;
  String fingerprint = '';

  Future<void> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    setState(() {
      if (deviceId != null) {
        fingerprint = deviceId;
      }
    });
  }

  IconData getIcon({String deviceString = 'none'}) {
    if (deviceString.toLowerCase().contains('firefox')) {
      return FontAwesomeIcons.firefoxBrowser;
    }
    if (deviceString.toLowerCase().contains('android')) {
      return FontAwesomeIcons.android;
    }
    if (deviceString.toLowerCase().contains('chrome')) {
      return FontAwesomeIcons.chrome;
    }
    if (deviceString.toLowerCase().contains('safari')) {
      return FontAwesomeIcons.safari;
    }
    if (deviceString.toLowerCase().contains('edg') ||
        deviceString.toLowerCase().contains('edge') ||
        deviceString.toLowerCase().contains('edga')) {
      return FontAwesomeIcons.edge;
    }

    return FontAwesomeIcons.windows;
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

  String _isCurrentDevice(String deviceFingerprint) {
    return fingerprint == deviceFingerprint ? 'This device' : '';
  }

  Future<void> searchDevices({bool isSearching = true}) async {
    if (kDebugMode) {
      print('user devices search  called');
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
          .get('/user-logins', queryParameters: getQueryParams());

      if (response.data != null) {
        if (kDebugMode) {
          // print("count ${response.data}");
        }

        setState(() {
          if (isSearching) {
            devices.clear();
            if (scrollController.hasClients) {
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut);
            }
          }

          UserDevicesData deviceData = UserDevicesData.fromJson(response.data);

          // set the books data
          devices.addAll(deviceData.data);

          //  set the data's
          _page++;

          if (deviceData.data.length < _pageSize) {
            _hasMore = false;
          } else {
            _hasMore = true;
            // _page++;
          }

          if (kDebugMode) {
            print('page size');
            print(deviceData.data.length);
            print(deviceData.data.length < _pageSize);
            print(_hasMore);
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _loadMore() async {
    // searchDevices(isSearching: false);
    if (kDebugMode) {
      print('Loadmore called');
    }
    if (!_hasMore) {
      return;
    }

    searchDevices(isSearching: false);
  }

  Future<void> _refreshData() async {
    setState(() {
      _page = 1;
      _hasMore = true;
      _isLoading = false;
      searchDevices();
    });
  }

  @override
  void initState() {
    authController.isLoggedIn.listen((value) {
      if (kDebugMode) {
        print("logged in value from devices $value");
      }
      if (value) {
        searchDevices();
      } else {}
    });

    searchDevices();
    getDeviceId();

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
              : Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Device list',
                      style: theme.textTheme.titleLarge,
                    ),
                    Text(
                      'Double tap to see the details.',
                      style: theme.textTheme.subtitle2
                          ?.copyWith(color: Colors.grey),
                    ),
                    Expanded(
                      child: !_hasMore && devices.isEmpty
                          ? const Center(
                              child: Text('No data found'),
                            )
                          : RefreshIndicator(
                              onRefresh: () {
                                return _refreshData();
                              },
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: devices.length + 1,
                                itemBuilder: (context, index) {
                                  if (kDebugMode) {
                                    // print("index $index");
                                  }
                                  // check if it is the last item
                                  if (index == devices.length) {
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

                                    return const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }

                                  if (devices.isNotEmpty) {
                                    return GestureDetector(
                                      onDoubleTap: () {
                                        if (kDebugMode) {
                                          print('tapped');
                                        }

                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Device detail',
                                                ),
                                                content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "IP Address :: \n ${devices[index].userIp.toString()}",
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        "Device :: \n ${devices[index].device.toString()}",
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        "Location :: \n ${devices[index].location.toString()}",
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      if (devices[index]
                                                              .fingerprint !=
                                                          '') ...[
                                                        Text(
                                                          "Device ID :: \n ${devices[index].fingerprint.toString()}",
                                                          textAlign:
                                                              TextAlign.left,
                                                        )
                                                      ],
                                                      Text(
                                                        "Last active :: \n ${devices[index].updatedAt.toUtc()}",
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ]),
                                              );
                                            });
                                      },
                                      child: Container(
                                        color: Colors.white,
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
                                                  deviceString: devices[index]
                                                      .device
                                                      .toString(),
                                                ),
                                                color: Colors.white,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                          title: RichText(
                                            text: TextSpan(
                                              text: devices[index]
                                                  .userIp
                                                  .toString(),
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: [
                                                const TextSpan(text: '  '),
                                                TextSpan(
                                                  text: _isCurrentDevice(
                                                      devices[index]
                                                          .fingerprint
                                                          .toString()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Text(
                                            devices[index].location,
                                          ),
                                          trailing: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white70),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: Text(timeago.format(
                                                devices[index].updatedAt,
                                                locale: 'en_short')),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                        child: Text('No device data found'));
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
