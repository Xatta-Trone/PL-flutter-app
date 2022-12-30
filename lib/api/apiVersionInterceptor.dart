// ignore: file_names
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';

class ApiVersionInterceptor extends Interceptor {
  ApiVersionInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    

    if (kDebugMode) {
      // print("user agent $userAgent");
    }

    options.headers.addAll({'API-V': 2});
    return handler.next(options);
  }

  // You can also perform some actions in the response or onError.
  @override
  void onResponse(response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
