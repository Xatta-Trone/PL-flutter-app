import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/models/Books.dart';

class BookController extends GetxController {
  TextEditingController queryString = TextEditingController();

  static const _pageSize = 50;
  int _page = 1;
  RxList<Book> books = RxList<Book>.empty();

  final PagingController<int, Book> _pagingController =
      PagingController(firstPageKey: 0);

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

  // $query = request()->input('query', null);
  //       $limit = request()->input('limit', 50);
  //       $page = request()->input('page', 1);
  //       $orderBy = request()->input('orderBy', 'id');
  //       $ascending = request()->input('ascending', 0);
  //       $byColumn = request()->input('byColumn', 1);

  Future<void> searchBooks({bool isSearching = true}) async {
    try {
      var response = await Api().dio.get('/books', queryParameters: {
        'query': queryString.text,
        'page': _page,
        'limit': _pageSize,
        'ascending': 0,
        'byColumn': 0,
      });

      if (response.data != null) {
        if (kDebugMode) {
          print("count ${response.data['count']}");
          if (isSearching) {
            books.clear();
          }
          books.addAll(RxList<Book>.from(
              response.data["data"].map((x) => Book.fromJson(x))));

          print(books.toList());
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await Api().dio.get('/books', queryParameters: {
        'query': queryString,
        'page': _page,
        'limit': _pageSize
      });

      // final isLastPage = newItems.data['data']. < _pageSize;
      // if (isLastPage) {
      //   _pagingController.appendLastPage(newItems);
      // } else {
      //   final nextPageKey = pageKey + newItems.length;
      //   _pagingController.appendPage(newItems, nextPageKey);
      // }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void onInit() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    queryString.dispose();

    super.dispose();
  }
}
