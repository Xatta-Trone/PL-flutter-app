import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/models/SoftwaresData.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:plandroid/screens/devices/deviceGuard.dart';

class Softwares extends StatefulWidget {
  const Softwares({Key? key}) : super(key: key);

  @override
  State<Softwares> createState() => _SoftwaresState();
}

final AuthController authController = Get.find<AuthController>();

class _SoftwaresState extends State<Softwares> {
  List<Software> books = List<Software>.empty(growable: true);
  static const _pageSize = 50;
  int _page = 1;
  TextEditingController queryString = TextEditingController();
  final scrollController = ScrollController();
  bool _hasMore = false;
  bool _isLoading = false;
  bool _isInitiallyLoaded = false;

//  debounce
  Timer? debounce;

  void handleSearchDebounce(String query) {
    if (debounce != null) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      // not call the search method
      searchBooks();
      if (kDebugMode) {
        print(query);
      }
    });
  }

  Map<String, String> getQueryParams({bool isLoadingMore = false}) {
    return {
      'query': queryString.text,
      'page': _page.toString(),
      'limit': _pageSize.toString(),
      'ascending': 0.toString(),
      'byColumn': 0.toString(),
    };
  }

  Future<void> searchBooks({bool isSearching = true}) async {
    if (kDebugMode) {
      print('softwares search  called');
    }

    if (_isLoading) {
      return;
    }

    // if searching then set page params
    if (isSearching) {
      setState(() {
        _page = 1;
      });
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response =
          await Api().dio.get('/softwares', queryParameters: getQueryParams());

      if (response.data != null) {
        if (kDebugMode) {
          // print("count ${response.data}");
          print('is searching');
          print(isSearching);
        }

        setState(() {
          if (isSearching) {
            books.clear();
            if (scrollController.hasClients) {
              scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut);
            }
          }

          SoftwaresData softwaresData = SoftwaresData.fromJson(response.data);
          // set total count
          // if (_totalCount != 0) {
          //   _totalCount = booksList.count;
          // }

          // set the books data
          books.addAll(softwaresData.data);
          if (!_isInitiallyLoaded) {
            _isInitiallyLoaded = true;
          }

          //  set the data's
          _page++;

          // is last page
          if (softwaresData.data.length < _pageSize) {
            _hasMore = false;
          } else {
            _hasMore = true;
          }

          if (kDebugMode) {
            // print(books.toList());
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
    // searchBooks(isSearching: false);
    if (kDebugMode) {
      print('Loadmore called');
    }
    if (!_hasMore) {
      return;
    }

    searchBooks(isSearching: false);
  }

  Future<void> _refreshData() async {
    setState(() {
      queryString.text = '';
      _page = 1;
      _hasMore = true;
      _isLoading = false;
      _isInitiallyLoaded = false;
      searchBooks();
    });
  }

  @override
  void initState() {
    authController.isLoggedIn.listen((value) {
      if (kDebugMode) {
        print("logged in value from softwares $value");
      }
      if (value) {
        searchBooks();
      }
    });
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
    queryString.dispose();
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
              : !authController.hasCheckedDevice.value
                  ? const DeviceGuardPage()
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              child: TextField(
                                controller: queryString,
                                textInputAction: TextInputAction.search,
                                keyboardType: TextInputType.text,
                                // autofocus: true,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    // setState(() {});
                                    if (kDebugMode) {
                                      print(queryString.text);
                                    }

                                    handleSearchDebounce(value);

                                    // setState(() {});
                                  }
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 15.0,
                                      top: 15.0,
                                      right: 25.0,
                                      bottom: 15.0),
                                  filled: true,
                                  hintText: "Search softwares here....",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: !_hasMore && books.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('No data found'),
                                          ElevatedButton(
                                            onPressed: () => _refreshData(),
                                            child: const Text('Refresh data'),
                                          )
                                        ],
                                      ),
                                    )
                                  : RefreshIndicator(
                                      onRefresh: () {
                                        return _refreshData();
                                      },
                                      child: ListView.builder(
                                        controller: scrollController,
                                        itemCount: books.length + 1,
                                        itemBuilder: (context, index) {
                                          if (kDebugMode) {
                                            // print("index $index");
                                          }
                                          // check if it is the last item
                                          if (index == books.length) {
                                            // check if more data could not be loaded
                                            if (_hasMore == false) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: theme.primaryColor,
                                              )),
                                            );
                                          }

                                          return books.isNotEmpty
                                              ? Container(
                                                  color: theme.cardColor
                                                      .withOpacity(0.6),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 10.0,
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (kDebugMode) {
                                                        print(books[index]
                                                            .link
                                                            .toString());
                                                      }
                                                      Globals.downloadItem(
                                                          model: books[index]
                                                              .toJson(),
                                                          postType: 'software',
                                                          additionalData:
                                                              books[index]
                                                                      .author ??
                                                                  "");
                                                    },
                                                    child: ListTile(
                                                      leading: Container(
                                                        decoration: BoxDecoration(
                                                            color: theme
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7.0)),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.15,
                                                        child: const Center(
                                                          child: FaIcon(
                                                            FontAwesomeIcons
                                                                .laptopCode,
                                                            color: Colors.white,
                                                            size: 30.0,
                                                          ),
                                                        ),
                                                      ),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10.0),
                                                        child: Text(
                                                          books[index]
                                                              .name
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                          books[index].author ??
                                                              books[index]
                                                                  .name
                                                                  .toString()),
                                                    ),
                                                  ),
                                                )
                                              : const Center(
                                                  child: Text(
                                                      'No software found'));
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
