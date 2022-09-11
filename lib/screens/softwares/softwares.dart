import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/models/Books.dart';
import 'package:plandroid/screens/auth/Login.dart';

class Softwares extends StatefulWidget {
  const Softwares({Key? key}) : super(key: key);

  @override
  State<Softwares> createState() => _SoftwaresState();
}

final AuthController authController = Get.find<AuthController>();

class _SoftwaresState extends State<Softwares> {
  List<Book> books = List<Book>.empty(growable: true);
  static const _pageSize = 50;
  int _page = 1;
  TextEditingController queryString = TextEditingController();
  final scrollController = ScrollController();
  bool _hasMore = false;
  int _totalCount = 0;
  bool _isLoading = false;

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

  Future<void> searchBooks({bool isSearching = true}) async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Api().dio.get('/softwares', queryParameters: {
        'query': queryString.text,
        'page': 1,
        'limit': _pageSize,
        'ascending': 0,
        'byColumn': 0,
      });

      if (response.data != null) {
        if (kDebugMode) {
          print("count ${response.data}");
        }

        setState(() {
          if (isSearching) {
            books.clear();
          }

          if (scrollController.hasClients) {
            scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut);
          }

          BooksList booksList = BooksList.fromJson(response.data);
          // set total count
          // if (_totalCount != 0) {
          //   _totalCount = booksList.count;
          // }

          // set the books data
          books.addAll(booksList.data);

          //  set the data's
          // _page++;

          // is last page
          if (booksList.data.length < _pageSize) {
            _hasMore = false;
          } else {
            _hasMore = true;
          }

          if (kDebugMode) {
            print(books.toList());
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
    // searchBooks(isSearching: false);
    if (kDebugMode) {
      print('Loadmore called');
    }
    if (!_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Api().dio.get('/softwares', queryParameters: {
        'query': queryString.text,
        'page': _page + 1,
        'limit': _pageSize,
        'ascending': 0,
        'byColumn': 0,
      });

      if (response.data != null) {
        if (kDebugMode) {
          // print("count ${response.data}");
        }

        setState(() {
          BooksList booksList = BooksList.fromJson(response.data);
          // set total count
          // if (_totalCount != 0) {
          //   _totalCount = booksList.count;
          // }

          // print(booksList.data);

          // set the books data
          books.addAll(booksList.data);

          //  set the data's
          _page++;

          // is last page
          if (booksList.data.length < _pageSize) {
            _hasMore = false;
          } else {
            _hasMore = true;
          }

          if (kDebugMode) {
            print(books.toList());
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

  Future<void> _refreshData() async {
    setState(() {
      queryString.text = '';
      _page = 1;
      _hasMore = true;
      _isLoading = false;
      searchBooks();
    });
  }

  @override
  void initState() {
    authController.isLoggedIn.listen((value) {
      print("logged in value $value");
      if (value) {
        searchBooks();
      }
    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (kDebugMode) {
          print('reaced end');
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
                              left: 15.0, top: 15.0, right: 25.0, bottom: 15.0),
                          filled: true,
                          fillColor: Colors.white,
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
                          ? const Center(
                              child: Text('No data found'),
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
                                    print("index $index");
                                  }
                                  // check if it is the last item
                                  if (index == books.length) {
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

                                  return books.isNotEmpty
                                      ? Card(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (kDebugMode) {
                                                print(books[index]
                                                    .link
                                                    .toString());
                                              }
                                              Globals.downloadItem(
                                                  books[index].toJson(),
                                                  'software');
                                            },
                                            child: ListTile(
                                              leading: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.white70),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: const Center(
                                                  child: FaIcon(
                                                    FontAwesomeIcons.laptopCode,
                                                    color: Colors.cyan,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Text(
                                                  books[index].name.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              subtitle: Text(
                                                  books[index].author ??
                                                      'No author'),
                                              // trailing: Container(
                                              //   decoration: const BoxDecoration(color: Colors.white70),
                                              //   width: MediaQuery.of(context).size.width * 0.1,
                                              //   child: const Center(
                                              //     child: FaIcon(
                                              //       FontAwesomeIcons.download,
                                              //       size: 28.0,
                                              //     ),
                                              //   ),
                                              // ),
                                            ),
                                          ),
                                        )
                                      : const Center(
                                          child: Text('No software found'));
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
