import 'dart:async';
import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/models/CourseForSearch.dart';
import 'package:plandroid/models/Departments.dart';
import 'package:plandroid/models/KeyValueModel.dart';
import 'package:plandroid/models/Search.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:plandroid/screens/departments/departments.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

final AuthController authController = Get.find<AuthController>();

class _SearchState extends State<Search> {
  List<Department> departments = List<Department>.empty(growable: true);
  List<Course> courses = List<Course>.empty(growable: true);
  List<SearchData> searchResult = List<SearchData>.empty(growable: true);

  List<KeyValueModel> levelTerms = [
    KeyValueModel(key: "1-1", value: "Level 1 Term 1"),
    KeyValueModel(key: "1-2", value: "Level 1 Term 2"),
    KeyValueModel(key: "2-1", value: "Level 2 Term 1"),
    KeyValueModel(key: "2-2", value: "Level 2 Term 2"),
    KeyValueModel(key: "3-1", value: "Level 3 Term 1"),
    KeyValueModel(key: "3-2", value: "Level 3 Term 2"),
    KeyValueModel(key: "4-1", value: "Level 4 Term 1"),
    KeyValueModel(key: "4-2", value: "Level 4 Term 2"),
  ];

  List<KeyValueModel> contentType = [
    KeyValueModel(key: "post", value: "Material"),
    KeyValueModel(key: "software", value: "Software"),
    KeyValueModel(key: "book", value: "Book"),
  ];

  static const _pageSize = 30;
  int _page = 1;
  TextEditingController queryString = TextEditingController();
  final scrollController = ScrollController();
  bool _hasMore = false;
  int _totalCount = 0;
  bool _isLoading = false;

  // bottom sheet values
  Department? selectedDepartment;
  Course? selectedCourse;
  KeyValueModel? selectedLevelTerm;
  KeyValueModel? selectedContentType;

  void clearSelection() {
    setState(() {
      selectedDepartment = null;
      selectedCourse = null;
      selectedLevelTerm = null;
      selectedContentType = null;
    });
  }

//  debounce
  Timer? debounce;

  void handleSearchDebounce(String query) {
    if (debounce != null) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      // not call the search method
      search();
      if (kDebugMode) {
        print(query);
      }
    });
  }

  Future<void> search({bool isSearching = true}) async {
    if (kDebugMode) {
      print('search  called');
    }

    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Api().dio.get('/search', queryParameters: {
        'q': queryString.text,
        'page': 1,
        'per_page': _pageSize,
        'dept': '',
        'l_t': '',
        'course_id': '',
        'content_type': '',
      });

      if (response.data != null) {
        if (kDebugMode) {
          // print("count ${response.data}");
        }

        setState(() {
          if (isSearching) {
            searchResult.clear();
          }

          if (scrollController.hasClients) {
            scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut);
          }

          if (kDebugMode) {
            // print(json.decode(response.data));
          }

          Iterable<SearchData> searchData =
              (response.data as List).map((x) => SearchData.fromJson(x));
          // List<SearchData>.from(
          //     json.decode(response.data).map((x) => SearchData.fromJson(x)));

          // set the  data
          searchResult.addAll(searchData);

          //  set the data's
          // _page++;

          // is last page
          if (searchData.length < _pageSize) {
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _loadMore() async {
    // search(isSearching: false);
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
      var response = await Api().dio.get('/search', queryParameters: {
        'page': _page + 1,
        'q': queryString.text,
        'per_page': _pageSize,
        'dept': '',
        'l_t': '',
        'course_id': '',
        'content_type': '',
      });

      if (response.data != null) {
        if (kDebugMode) {
          // print("count ${response.data}");
        }

        setState(() {
          List<SearchData> searchData = List<SearchData>.from(
              json.decode(response.data).map((x) => SearchData.fromJson(x)));

          // set the data
          searchResult.addAll(searchData);

          //  set the data's
          _page++;

          // is last page
          if (searchData.length < _pageSize) {
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
      search();
    });
  }

  Future<void> getCourses() async {
    try {
      var response = await Api().dio.get('/courses');

      if (response.data != null) {
        // update state
        CourseDataForSearch courseData =
            CourseDataForSearch.fromJson(response.data);
        // save data
        setState(() {
          courses.addAll(courseData.data);
        });

        if (kDebugMode) {
          print("total courses ${courses.length}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {}
  }

  Future<void> getDept() async {
    try {
      var response = await Api().dio.get('/departments');

      if (response.data != null) {
        // update state
        DepartmentData deptData = DepartmentData.fromJson(response.data);
        // save data
        setState(() {
          departments.addAll(deptData.data);
        });

        if (kDebugMode) {
          print("total dept ${departments.length}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {}
  }

  @override
  void initState() {
    getCourses();
    getDept();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            left: 15.0,
                            top: 15.0,
                            right: 25.0,
                            bottom: 15.0,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Search here....",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (kDebugMode) {
                                print(' suffix clicked');
                                // _settingModalBottomSheet(context);
                              }

                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function())
                                              setState) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Text(
                                                'Detailed search',
                                                style:
                                                    TextStyle(fontSize: 20.0),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: DropdownButtonFormField(
                                                  value: selectedDepartment,
                                                  hint:
                                                      const Text('Department'),
                                                  isExpanded: true,
                                                  items: departments.map<
                                                          DropdownMenuItem<
                                                              Department>>(
                                                      (Department value) {
                                                    return DropdownMenuItem<
                                                        Department>(
                                                      value: value,
                                                      child: Text(value.name),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (Department? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedDepartment =
                                                          value;
                                                    });

                                                    if (kDebugMode) {
                                                      print(value?.slug);
                                                    }
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: DropdownButtonFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  value: selectedLevelTerm,
                                                  hint:
                                                      const Text('Level Term'),
                                                  isExpanded: true,
                                                  items: levelTerms.map<
                                                          DropdownMenuItem<
                                                              KeyValueModel>>(
                                                      (KeyValueModel value) {
                                                    return DropdownMenuItem<
                                                        KeyValueModel>(
                                                      value: value,
                                                      child: Text(value.value),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (KeyValueModel? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedLevelTerm = value;
                                                    });

                                                    if (kDebugMode) {
                                                      print(value?.key);
                                                    }
                                                  },
                                                ),
                                              ),
                                              DropdownSearch<Course>(
                                                // ignore: prefer_const_constructors
                                                popupProps: PopupProps.menu(
                                                  showSearchBox: true,
                                                  showSelectedItems: true,
                                                ),
                                                // itemAsString: (Course u) =>
                                                //     u.userAsString(),
                                                items: courses,

                                                // dropdownSearchDecoration:
                                                //     InputDecoration(
                                                //   labelText: "Menu mode",
                                                //   hintText:
                                                //       "country in menu mode",
                                                // ),
                                                onChanged: (value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    selectedCourse = value;
                                                  });

                                                  if (kDebugMode) {
                                                    print(value?.slug);
                                                  }
                                                },
                                                // selectedItem: selectedCourse,
                                              ),
                                              CustomSearchableDropDown(
                                                // initialValue: [],
                                                // showClearButton: true,
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    style: BorderStyle.none,
                                                  ),
                                                ),
                                                label: 'Course',
                                                labelStyle: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        fontSize: 15.0,
                                                        color: Colors.black),
                                                items: courses,
                                                dropDownMenuItems:
                                                    courses.map((Course value) {
                                                  return "${value.courseName} (${Globals.generateCourseName(value.slug).toUpperCase()})";
                                                }).toList(),
                                                onChanged: (value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    selectedCourse = value;
                                                  });

                                                  if (kDebugMode) {
                                                    print(value?.slug);
                                                  }
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: DropdownButtonFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  value: selectedContentType,
                                                  hint: const Text(
                                                      'Material type'),
                                                  isExpanded: true,
                                                  items: contentType.map<
                                                          DropdownMenuItem<
                                                              KeyValueModel>>(
                                                      (KeyValueModel value) {
                                                    return DropdownMenuItem<
                                                        KeyValueModel>(
                                                      value: value,
                                                      child: Text(value.value),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (KeyValueModel? value) {
                                                    // This is called when the user selects an item.
                                                    setState(() {
                                                      selectedContentType =
                                                          value;
                                                    });

                                                    if (kDebugMode) {
                                                      print(value?.key);
                                                    }
                                                  },
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (kDebugMode) {
                                                    print('search clicked');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  minimumSize:
                                                      const Size.fromHeight(
                                                          40.0),
                                                ),
                                                child: const Text('Search'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (kDebugMode) {
                                                    print('clear clicked');
                                                  }
                                                  setState(() {
                                                    clearSelection();
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Colors.grey,
                                                  minimumSize:
                                                      const Size.fromHeight(
                                                          40.0),
                                                ),
                                                child: const Text('Clear'),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  });
                            },
                            child: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: FaIcon(FontAwesomeIcons.sliders),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: !_hasMore && searchResult.isEmpty
                          ? const Center(
                              child: Text('No data found'),
                            )
                          : RefreshIndicator(
                              onRefresh: () {
                                return _refreshData();
                              },
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: searchResult.length + 1,
                                itemBuilder: (context, index) {
                                  if (kDebugMode) {
                                    // print("index $index");
                                  }
                                  // check if it is the last item
                                  if (index == searchResult.length) {
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

                                  return searchResult.isNotEmpty
                                      ? Container(
                                          color: Colors.white,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (kDebugMode) {
                                                print(searchResult[index]
                                                    .link
                                                    .toString());
                                              }
                                              // Globals.downloadItem(
                                              //     searchResult[index].toJson(),
                                              //     'software');
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
                                                  searchResult[index]
                                                      .name
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              subtitle: Text(
                                                  searchResult[index].author ??
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
                                          child: Text('No result found'));
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

// void _settingModalBottomSheet(context) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return Wrap(
//           children: <Widget>[

//             DropdownButton(items: departments. , onChanged: onChanged)


//             ListTile(
//                 leading: const Icon(Icons.music_note),
//                 title: const Text('Music'),
//                 onTap: () => {}),
//             ListTile(
//               leading: const Icon(Icons.videocam),
//               title: const Text('Video'),
//               onTap: () => {},
//             ),
//           ],
//         );
//       });
// }
