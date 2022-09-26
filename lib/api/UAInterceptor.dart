import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';

class UAInterceptor extends Interceptor {
  UAInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String userAgent;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      await FlutterUserAgent.init();

      // if (kDebugMode) {
      //   print(
      //       ''' user agent $userAgent \n package ${FlutterUserAgent.getProperty('packageUserAgent')}''');
      // }

      userAgent = FlutterUserAgent.getProperty('packageUserAgent');
    } on PlatformException {
      userAgent = '<error>';
    }

    if (kDebugMode) {
      // print("user agent $userAgent");
    }

    options.headers.addAll({'User-Agent': userAgent});
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
