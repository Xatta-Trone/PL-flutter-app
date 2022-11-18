// ignore: file_names
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/routes/routeconst.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();
  AuthController authController = Get.put(AuthController());

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // create a list of the endpoints where you don't need to pass a token.
    final listOfPaths = <String>[];

    if (kDebugMode) {
      print("is logged in ${authController.isLoggedIn}");
      print(authController.token.value.toString());
    }

    // Check if the requested endpoint match in the
    if (listOfPaths.contains(options.path.toString())) {
      // if the endpoint is matched then skip adding the token.
      return handler.next(options);
    }

    // Load your token here and pass to the header
    var token = authController.isLoggedIn.value
        ? authController.token.value.toString()
        : null;

    if (token != null) {
      options.headers.addAll({'Authorization': "Bearer $token"});
    }

    return handler.next(options);
  }

  // You can also perform some actions in the response or onError.
  @override
  void onResponse(response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print("err response=================");
      print(response);
    }
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print("err=================");
      print(err);
      print(err.response?.statusCode);
    }

    if (err.response?.statusCode == 401) {
      authController.setLogoutValues();
      Get.snackbar(
        'Unauthenticated !!',
        'There was an error with the authentication.',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Get.toNamed(homePage);
      return handler.next(err);
    }

    return handler.next(err);
  }
}
