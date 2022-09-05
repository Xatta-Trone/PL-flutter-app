import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/models/Quote.dart';
import 'package:platform_device_id/platform_device_id.dart';

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

  Future<String?> getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');
    print('Running on ${androidInfo.toMap()}');
    print(
        'Running on Android ${androidInfo.version.sdkInt} on ${androidInfo.model}');

    String? deviceId = await PlatformDeviceId.getDeviceId;

    print("devide id ${deviceId}");
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
