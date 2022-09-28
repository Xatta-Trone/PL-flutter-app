import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

final AuthController authController = Get.find<AuthController>();

class _SearchState extends State<Search> {
  List<Department> departments = List<Department>.empty(growable: true);
  List<Course> courses = List<Course>.empty(growable: true);
  List<Course> backupCourses = List<Course>.empty(growable: true);
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
  bool _isInitiallyLoaded = false;

  // bottom sheet values
  Department? selectedDepartment;
  Course? selectedCourse;
  KeyValueModel? selectedLevelTerm;
  KeyValueModel? selectedContentType;

  bool detailSearchSelected = false;

  void setCoursesFromLevelTerm() {
    // if (selectedLevelTerm == null) {
    //   setState(() {
    //     courses.clear();
    //     courses.addAll(backupCourses);
    //   });
    // } else {
    //   if (kDebugMode) {
    //     print(selectedLevelTerm?.value);
    //   }
    //   Iterable<Course> filteredCourses = courses.where((element) {
    //     if (kDebugMode) {
    //       print(element.levelterm.slug == selectedLevelTerm?.key);
    //     }
    //     return element.levelterm.slug == selectedLevelTerm?.key;
    //   });

    //   if (kDebugMode) {
    //     print(filteredCourses);
    //   }
    //   setState(() {
    //     courses.clear();
    //     courses.addAll(filteredCourses);
    //   });
    // }
  }

  void clearSelection() {
    setState(() {
      selectedDepartment = null;
      selectedCourse = null;
      selectedLevelTerm = null;
      selectedContentType = null;
      detailSearchSelected = false;
      _isInitiallyLoaded = false;
    });
  }

  void setDetailSearchActive({bool state = true}) {
    setState(() {
      detailSearchSelected = state;
    });
  }

  void clearSearch() {
    setState(() {
      searchResult.clear();
      _hasMore = false;
      _isLoading = false;
      _isInitiallyLoaded = false;
    });
  }

//  debounce
  Timer? debounce;

  void handleSearchDebounce(String query) {
    if (debounce != null) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 900), () {
      // not call the search method
      search();
      if (kDebugMode) {
        print(query);
      }
    });
  }

  Map<String, String> getQueryParams({bool isLoadingMore = false}) {
    return {
      'q': queryString.text,
      'page': (isLoadingMore ? _page + 1 : 1).toString(),
      'per_page': _pageSize.toString(),
      'dept': selectedDepartment?.slug ?? '',
      'l_t': selectedLevelTerm?.key ?? '',
      'course_id': (selectedCourse?.id ?? '').toString(),
      'course_slug': (selectedCourse?.slug ?? '').toString(),
      'course_title': (selectedCourse?.courseName ?? '').toString(),
      'content_type': selectedContentType?.key ?? '',
    };
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
      _isInitiallyLoaded = false;
    });

    try {
      var response =
          await Api().dio.get('/search', queryParameters: getQueryParams());

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

// to set the initial progress indicator
          _isInitiallyLoaded = true;

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

      setState(() {
        _isInitiallyLoaded = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });

      Globals.saveSearchActivity(getQueryParams());
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
      var response = await Api()
          .dio
          .get('/search', queryParameters: getQueryParams(isLoadingMore: true));

      if (response.data != null) {
        if (kDebugMode) {
          // print("count ${response.data}");
        }

        setState(() {
          Iterable<SearchData> searchData =
              (response.data as List).map((x) => SearchData.fromJson(x));

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
          backupCourses.addAll(courseData.data);
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

  IconData getIcon({String materialType = 'post'}) {
    if (materialType == 'software') return FontAwesomeIcons.laptopCode;
    if (materialType == 'book') return FontAwesomeIcons.book;
    return FontAwesomeIcons.folderOpen;
  }

  String getAuthor(SearchData searchItem) {
    if (kDebugMode) {
      print(searchItem.toJson());
    }
    // get course
    if (searchItem.courseId == null) {
      return searchItem.getAuthor();
    }
    String courseSlug = getSingleCourseSlug(searchItem.courseId.toString());
    return searchItem.getAuthor(courseSlug: courseSlug);

    
  }

  String getSingleCourseSlug(String courseId) {
    // return '';
    return courses
        .where((element) => element.id == int.tryParse(courseId))
        .first
        .slug;
  }

  @override
  void initState() {
    getCourses();
    getDept();
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

                              bottomSheet(context);
                            },
                            child: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: FaIcon(
                                FontAwesomeIcons.sliders,
                                color: detailSearchSelected
                                    ? theme.primaryColor.withRed(255)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Double tap on the softwares to see the details',
                      style: theme.textTheme.bodySmall,
                    ),
                    Expanded(
                      child: _isLoading && !_isInitiallyLoaded
                          ? Center(
                              child: CircularProgressIndicator(
                                color: theme.primaryColor,
                              ),
                            )
                          : !_isLoading && !_isInitiallyLoaded
                              ? const Center(
                                  child: Text('Type something to search'),
                                )
                              : !_hasMore && searchResult.isEmpty
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
                                                ),
                                              ),
                                            );
                                          }

                                          return searchResult.isNotEmpty
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
                                                        print(
                                                            searchResult[index]
                                                                .link
                                                                .toString());
                                                        print(getQueryParams()
                                                            .toString());
                                                      }
                                                      Globals.downloadItem(
                                                          model: searchResult[
                                                                  index]
                                                              .toJson(),
                                                          postType:
                                                              searchResult[
                                                                      index]
                                                              .postType
                                                                  .toString(),
                                                          additionalData:
                                                              searchResult[
                                                                      index]
                                                                  .getAuthor());
                                                    },
                                                    onDoubleTap: () {
                                                      if (kDebugMode) {
                                                        print('double tap');
                                                        // print(searchResult[index]
                                                        //     .description
                                                        //     .toString());
                                                      }

                                                      return showInfoDialog(
                                                          index);
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
                                                        child: Center(
                                                          child: FaIcon(
                                                            getIcon(
                                                              materialType:
                                                                  searchResult[
                                                                          index]
                                                                      .postType
                                                                      .toString(),
                                                            ),
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
                                                          searchResult[index]
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
                                                        getAuthor(searchResult[
                                                            index]),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const Center(
                                                  child:
                                                      Text('No result found'));
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

  void showInfoDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        title: Text(searchResult[index].name),
        children: [
          Html(
            data: searchResult[index].description,
            onLinkTap: (url, context, attributes, element) {
              if (kDebugMode) {
                print(url);
              }
              Globals.launchURL(url ?? '');
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Detailed search',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButtonFormField(
                        value: selectedDepartment,
                        hint: const Text('Department'),
                        isExpanded: true,
                        items: departments.map<DropdownMenuItem<Department>>(
                            (Department value) {
                          return DropdownMenuItem<Department>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                        onChanged: (Department? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedDepartment = value;
                            setDetailSearchActive(state: true);
                          });

                          if (kDebugMode) {
                            print(value?.slug);
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: selectedLevelTerm,
                        hint: const Text('Level Term'),
                        isExpanded: true,
                        items: levelTerms.map<DropdownMenuItem<KeyValueModel>>(
                            (KeyValueModel value) {
                          return DropdownMenuItem<KeyValueModel>(
                            value: value,
                            child: Text(value.value),
                          );
                        }).toList(),
                        onChanged: (KeyValueModel? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedLevelTerm = value;
                            setDetailSearchActive(state: true);
                            setCoursesFromLevelTerm();
                          });

                          if (kDebugMode) {
                            print(value?.key);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: DropdownSearch<Course>(
                        selectedItem: selectedCourse,
                        itemAsString: (Course c) => c.itemAsString(),
                        popupProps: const PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 5.0),
                            decoration: InputDecoration(
                                filled: true,
                                // border: InputBorder.,
                                labelText: 'Search course....'),
                          ),
                        ),
                        items: courses,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            label: Text('Course'),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedCourse = value;
                            setDetailSearchActive(state: true);
                          });

                          if (kDebugMode) {
                            print(value?.slug);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: selectedContentType,
                        hint: const Text('Material type'),
                        isExpanded: true,
                        items: contentType.map<DropdownMenuItem<KeyValueModel>>(
                            (KeyValueModel value) {
                          return DropdownMenuItem<KeyValueModel>(
                            value: value,
                            child: Text(value.value),
                          );
                        }).toList(),
                        onChanged: (KeyValueModel? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedContentType = value;
                            setDetailSearchActive(state: true);
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
                        setState(() {
                          setDetailSearchActive(state: true);
                          search();
                          FocusScope.of(context).unfocus();
                          Get.back();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(40.0),
                      ),
                      child: const Text('Search'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('clear clicked');
                        }
                        setState(() {
                          // detailSearchSelected = false;
                          setDetailSearchActive(state: true);
                          clearSelection();
                          clearSearch();
                          setCoursesFromLevelTerm();
                          // FocusScope.of(context).unfocus();
                          Get.back();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.grey,
                        minimumSize: const Size.fromHeight(40.0),
                      ),
                      child: const Text('Clear'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('close clicked');
                        }
                        setState(() {
                          // detailSearchSelected = false;
                          // setDetailSearchActive(state: false);
                          // clearSelection();
                          Get.back();
                          FocusScope.of(context).unfocus();
                        });
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(40.0),
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Close'),
                    )
                  ],
                ),
              );
            },
          );
        });
  }
}
