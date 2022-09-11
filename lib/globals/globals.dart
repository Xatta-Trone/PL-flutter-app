import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:url_launcher/url_launcher.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

AuthController _authController = Get.find<AuthController>();

class Globals {
  static Future<dynamic> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  String formatText(String text) {
    return text.replaceAll('_', ' ').toTitleCase();
  }

  static postActivity(
      {String activity = 'downloaded',
      int causer_id = 0,
      String label = '',
      int model_id = 0,
      String model_type = 'post'}) {
    Api().dio.post('/submit-activity', data: {
      'activity': activity,
      'causer_id': causer_id,
      'label': label,
      'model_id': model_id,
      'model_type': model_type,
    });
  }

  static downloadItem(dynamic model, String postType) {
    // launchURL(url);
    if (kDebugMode) {
      print(_authController.isLoggedIn);
      print(model);
      print(model['id']);
    }

    // process data

    int causer_id = _authController.isLoggedIn.value
        ? _authController.user.value?.user.id ?? 0
        : 0;
    String label = model['name'];
    int model_id = model['id'];
    String url = model['link'];
    String model_type = postType;

    // launch url
    launchURL(url);

    // save activity
    postActivity(
        activity: 'downloaded',
        causer_id: causer_id,
        label: label,
        model_id: model_id,
        model_type: model_type);
  }
}
