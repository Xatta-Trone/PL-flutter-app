import 'package:dio/dio.dart';
import 'package:plandroid/api/UAInterceptor.dart';
import 'package:plandroid/api/apiVersionInterceptor.dart';
import 'package:plandroid/api/authInterceptor.dart';
import 'package:plandroid/constants/const.dart';

class Api {
  final dio = createDio();
  final tokenDio = Dio(BaseOptions(baseUrl: apiUrl));

  Api._internal();

  static final _singleton = Api._internal();

  factory Api() => _singleton;



  static Dio createDio() {
    var dio = Dio(BaseOptions(
        baseUrl: apiUrl, headers: {'Accept': 'application/json'}
            // responseType: ResponseType.json
            // receiveTimeout: 15000, // 15 seconds
            // connectTimeout: 15000,
            // sendTimeout: 15000,
            ));

    dio.interceptors.addAll({
      AuthInterceptor(),
      UAInterceptor(),
      ApiVersionInterceptor(),
    });
    return dio;
  }

  
}
