import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/models/Quote.dart';

class DashboardController extends GetxController {
  final quote = Rxn<Quote>();

  Future<void> getQuote() async {
    try {
      var response = await Api().dio.get('/quote');
      // var dio = Dio(BaseOptions(baseUrl: apiUrl));
      // var response = await dio.get('/quote');
      print(response.data['data']);

      quote.value = Quote.fromJson(response.data);
      update();
      print(quote);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
