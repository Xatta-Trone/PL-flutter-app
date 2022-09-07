import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/models/Quote.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/sharedPrefConstants.dart';

class DashboardController extends GetxController {
  final quote = Rxn<Quote>();

  Future<void> getQuote() async {
    try {
      var response = await Api().dio.get('/quote');

      print('=========== set current quote ================');
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      if (response.data != null) {
        // update state
        quote.value = Quote.fromJson(response.data);
        // save data
        preferences.setString(quoteKey, jsonEncode(quote.value));
      }

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

  String greetingText() {
    var hour = DateTime.now().hour;
    String text = 'Welcome';

    if (hour <= 12) {
      text = "Good Morning";
    } else if ((hour > 12) && (hour <= 16)) {
      text = "Good Afternoon";
    } else if ((hour > 16) && (hour < 20)) {
      text = "Good Evening";
    } else {
      text = "Good Night";
    }
    return "$text !!";
  }

  String getHello() {
    var list = [
      'Hello !',
      'Hola !',
      'Bonjour !',
      'Salve !',
      'Nǐn hǎo !',
      'Asalaam-alaikum !',
      'Konnichiwa !',
      'Anyoung haseyo !',
      'Zdravstvuyte !'
    ];
    return (list..shuffle()).first;
  }

  Future<void> getCurrentQuote() async {
    print('=========== get current quote ================');
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? quoteData = preferences.getString(quoteKey);

    if (quoteData != null) {
      Map<String, dynamic> jsonQuoteData = jsonDecode(quoteData);
      quote.value = Quote.fromJson(jsonQuoteData);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getQuote();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
