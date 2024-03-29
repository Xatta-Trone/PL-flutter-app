// ignore: file_names
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/models/CountData.dart';
import 'package:plandroid/models/Quote.dart';
import 'package:plandroid/models/TestimonialData.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/sharedPrefConstants.dart';

class DashboardController extends GetxController {
  final quote = Rxn<Quote>();
  final countData = Rxn<CountData>();
  final RxList<Testimonial> testimonials = RxList<Testimonial>();
  // ignore: non_constant_identifier_names
  final RxString UA = RxString('');
  final RxString levelTermString = RxString('');

  Future<void> getQuote() async {
    try {
      var response = await Api().dio.get('/quote');

      if (kDebugMode) {
        print('=========== set current quote ================');
      }
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      if (response.data != null) {
        // update state
        quote.value = Quote.fromJson(response.data);
        // save data
        preferences.setString(quoteKey, jsonEncode(quote.value));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void getPinnedLevelTerm() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    var levelTerm = preference.get(levelTermPinKey);

    if (levelTerm != null) {
      levelTermString.value = levelTerm.toString();
    }
  }

  Future<void> initUserAgentState() async {
    String userAgent;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      userAgent = await FlutterUserAgent.getPropertyAsync('userAgent');
      await FlutterUserAgent.init();

      if (kDebugMode) {
        print(
            ''' user agent $userAgent \n package ${FlutterUserAgent.getProperty('packageUserAgent')}''');
      }

      UA.value = FlutterUserAgent.getProperty('packageUserAgent');
    } on PlatformException {
      userAgent = '<error>';
    }
  }

  Future<void> getTestimonials() async {
    try {
      var response = await Api().dio.get('/testimonials');

      if (kDebugMode) {
        print('=========== set current testimonials ================');
      }
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      if (response.data != null) {
        // update state
        TestimonialData testimonialData =
            TestimonialData.fromJson(response.data);

        testimonials.addAll(testimonialData.data);

        // save data
        preferences.setString(testimonialsKey, jsonEncode(testimonialData));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getCountData() async {
    try {
      var response = await Api().dio.get('/count-data');

      if (kDebugMode) {
        print('=========== set current coun data ================');
      }
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      if (response.data != null) {
        // update state
        countData.value = CountData.fromJson(response.data);

        // save data
        preferences.setString(countKey, jsonEncode(countData));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<String?> getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (kDebugMode) {
      print('Running on ${androidInfo.model}');
      print('Running on ${androidInfo.toMap()}');
      print(
          'Running on Android ${androidInfo.version.sdkInt} on ${androidInfo.model}');
    }

    String? deviceId = await PlatformDeviceId.getDeviceId;

    if (kDebugMode) {
      print("device id ${deviceId}");
    }
    return null;
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
    return text;
  }

  String getHello() {
    var list = [
      'Hello!',
      'Hola!',
      'Bonjour!',
      'Salve!',
      'Nǐn hǎo!',
      'Asalaam-alaikum!',
      'Konnichiwa!',
      'Anyoung haseyo!',
      'Zdravstvuyte!'
    ];
    return (list..shuffle()).first;
  }

  Color randomColor() {
    var list = [
      const Color(0xff58C9A5),
      const Color(0xff8885EC),
      const Color(0xff379BF4),
      // const Color(0xff5352ed),
      // const Color(0xff58C9A5),
      // const Color(0xff1abc9c),
      // const Color(0xffe67e22),
      const Color(0xffe74c3c),
      // const Color(0xff9b59b6),
      // const Color(0xff3498db),
      const Color(0xff1e90ff),
      // const Color(0xffff6348),
      const Color(0xffc56cf0),
      Colors.redAccent
    ];
    return Colors.cyan;
    // return (list..shuffle()).first;
  }

  Future<void> autoLoadData() async {
    if (kDebugMode) {
      print('=========== get current quote ================');
    }
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? quoteData = preferences.getString(quoteKey);

    if (quoteData != null) {
      Map<String, dynamic> jsonQuoteData = jsonDecode(quoteData);
      quote.value = Quote.fromJson(jsonQuoteData);
    }

    if (kDebugMode) {
      print('=========== get current count data ================');
    }
    String? count = preferences.getString(countKey);

    if (count != null) {
      Map<String, dynamic> jsonCountData = jsonDecode(count);
      countData.value = CountData.fromJson(jsonCountData);
    }

    if (kDebugMode) {
      print('=========== get current testimonial data ================');
    }
    String? testimonial = preferences.getString(testimonialsKey);

    if (testimonial != null) {
      Map<String, dynamic> jsonTestimonialData = jsonDecode(testimonial);

      TestimonialData testimonialData =
          TestimonialData.fromJson(jsonTestimonialData);

      testimonials.clear();
      testimonials.addAll(testimonialData.data);
    }
  }

  @override
  void onInit() {
    autoLoadData();
    getTestimonials();
    getQuote();
    getCountData();
    // initUserAgentState();
    getPinnedLevelTerm();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
