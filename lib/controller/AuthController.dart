import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/constants/sharedPrefConstants.dart';
import 'package:plandroid/models/User.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final isLoggedIn = RxBool(false);
  RxBool isInAsyncCall = RxBool(false);
  final user = Rxn<User>();
  final RxString token = ''.obs;

  String serverValidationErr = '';

  // login text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // validation

  String? get emailErrorText {
    // at any time, we can get the text from _controller.value.text
    // final text = emailController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    // final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    // if (text.isEmpty) {
    //   return 'Please enter your email.';
    // }

    // if (text.isNotEmpty && emailRegExp.hasMatch(text) == false) {
    //   return 'Please enter a valid email.';
    // }

    if (serverValidationErr.isNotEmpty) {
      return serverValidationErr;
    }

    // return null if the text is valid
    return null;
  }

  String? get passwordErrorText {
    // at any time, we can get the text from _controller.value.text
    final text = passwordController.value.text;
    // Note: you can do your own custom validation here

    // if (text.length < 2 || text.isEmpty) {
    //   return 'Please enter your password.';
    // }

    // return null if the text is valid
    return null;
  }

  // functions

  Future<String?> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    print("devide id ${deviceId}");
    return deviceId;
  }

  Future<void> login() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    String deviceName =
        "Android ${androidInfo.version.sdkInt} on ${androidInfo.model}";
    isInAsyncCall.value = true;

    try {
      var response = await Api().dio.post('/login', data: {
        'email': emailController.value.text,
        'password': passwordController.value.text,
        'fingerprint': deviceId,
        'deviceName': deviceName,
        'platform': 'android'
      });

      // login user
      setLoginValues(response.data);

      // save login data for auto-login later
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString(userDataKey, json.encode(user.value));

      print(response.data);
    } on DioError catch (e) {
      setLogoutValues();
      // server sent a res back with err
      if (e.response != null) {
        print(e.response);
        Get.defaultDialog(
          title: 'Error !!',
          middleText:
              "${e.response?.statusCode}: ${e.response?.data['message'] ?? 'Something unknown occurred'}",
          textConfirm: ('Okay'),
          onConfirm: () => Get.back(),
        );
      } else {
        print(e.message);
      }
    } finally {
      isInAsyncCall.value = false;
    }
  }

  Future<void> logout() async {
    try {
      var response = await Api().dio.get('/logout');
      // logout user
      setLogoutValues();
    } on DioError catch (e) {
      setLogoutValues();
      // server sent a res back with err
      if (e.response != null) {
        print(e.response);
        Get.defaultDialog(
          title: 'Error !!',
          middleText:
              "${e.response?.statusCode}: ${e.response?.data['message'] ?? 'Something unknown occurred'}",
          textConfirm: ('Okay'),
          onConfirm: () => Get.back(),
        );
      } else {
        print(e.message);
      }
    }
  }

  Future<void> autoLogin() async {
    print('===========auto login================');
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userData = preferences.getString(userDataKey);

    if (userData != null) {
      Map<String, dynamic> jsonUserData = jsonDecode(userData);
      setLoginValues(jsonUserData);
    }
  }

  void setLoginValues(userData) {
    user.value = User.fromJson(userData);
    isLoggedIn.value = true;
    token.value = user.value!.accessToken;
  }

  Future<void> setLogoutValues() async {
    user.value = null;
    isLoggedIn.value = false;
    token.value = '';
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(userDataKey);
  }

  String getCreateAt() {
    if (user.value != null) {
      return DateFormat("MMM d, yyyy h:mm a")
          .format(user.value?.user.createdAt ?? DateTime.now());
    }
    return '';
  }

  @override
  void onInit() {
    autoLogin();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
