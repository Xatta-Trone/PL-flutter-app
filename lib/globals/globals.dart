import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  static String formatLevelTermString(String string) {
    // return string;
    return "Tap to navigate to ${string.split('/')[2].toUpperCase()} ${string.split('/').last.toUpperCase()}";
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

  static downloadItem(
      {dynamic model, String postType = 'post', String additionalData = ''}) {
    // launchURL(url);
    if (kDebugMode) {
      print(_authController.isLoggedIn);
      print(model);
      print(model['id']);
    }

    // process data

    int causerId = _authController.isLoggedIn.value
        ? _authController.user.value?.user.id ?? 0
        : 0;
    String label = model['name'];

    if (additionalData != "") {
      label += "($additionalData)";
    }

    int modelId = model['id'];
    String url = model['link'];
    String modelType = postType;

    // launch url
    launchURL(url);

    // save activity
    postActivity(
        activity: 'downloaded',
        causer_id: causerId,
        label: label,
        model_id: modelId,
        model_type: modelType);
  }

  static String formatSearchString(String search) {
    if (!search.contains('q=')) {
      return search;
    }

    String finalString = 'Searched ';

    List<String> explodedString = search.split(",");

    // get query param
    var query =
        explodedString.firstWhereOrNull((element) => element.contains('q='));
    var dept =
        explodedString.firstWhereOrNull((element) => element.contains('dept='));
    var levelTerm =
        explodedString.firstWhereOrNull((element) => element.contains('l_t='));
    var courseSlug = explodedString
        .firstWhereOrNull((element) => element.contains('course_slug='));
    var courseTitle = explodedString
        .firstWhereOrNull((element) => element.contains('course_title='));
    var contentType = explodedString
        .firstWhereOrNull((element) => element.contains('content_type='));

    if (query != null) {
      var q = getValue(query);
      if (q != '') {
        finalString += "for ${q.toLowerCase()} ";
      }
    }

    // dept/levelterm/course

    var deptStr = dept?.split('=').last ?? '';
    var ltStr = levelTerm?.split('=').last ?? '';
    var courseStr = courseSlug?.split('=').last ?? '';
    var courseTitleStr = courseTitle?.split('=').last ?? '';

    if (deptStr != '' ||
        ltStr != '' ||
        courseStr != '' ||
        courseTitleStr != '') {
      var finalCourseString =
          getDeptString(dept, levelTerm, courseSlug, courseTitle);
      int patternInt = finalCourseString.indexOf('//');

      // if (kDebugMode) {
      //   print('index of //');
      //   print(patternInt);
      // }

      if (patternInt != -1) {
        finalString += "in ${finalCourseString.split('//').first}";
      } else {
        finalString += "in $finalCourseString";
      }

      // finalString += "in $finalCourseString";
    }

    // content type
    if (contentType != null) {
      var contentValue = getValue(contentType);
      if (contentValue != '') {
        finalString += " :: content type: ${contentValue.toLowerCase()}";
      }
    }

    return finalString;
  }

  static String getValue(String str) {
    return (str.split('=')[1]).toUpperCase();
  }

  static String getDeptString(
      String? dept, String? levelTerm, String? course, String? courseTitle) {
    if (dept == null && levelTerm == null && course == null) {
      return "";
    }
    return "${[
      dept?.split('=').last,
      levelTerm?.split('=').last,
      course?.split('=').last,
    ].join('/')}  ${courseTitle?.split('=').last}"
        .toUpperCase();
  }

  static void saveSearchActivity(Map<String, String> querySting) {
    int causerId = _authController.isLoggedIn.value
        ? _authController.user.value?.user.id ?? 0
        : 0;
    String label = '';

    // process string
    querySting.forEach((key, value) {
      label += "$key=$value,";
    });
    label = label.substring(0, label.length - 1);

    if (kDebugMode) {
      print('save search activity');
      print(label);
    }

    postActivity(
      activity: 'searched',
      causer_id: causerId,
      label: label,
      model_id: 0,
      model_type: '',
    );
  }

  static String generateCourseName(String string) {
    if (string == '') return '';
    return "${string.replaceAll(RegExp(r'[^a-zA-Z]'), '')}-${string.replaceAll(RegExp(r'[^0-9]'), '')}"; // 'phy-101'
  }

  static String getRounded(int number) {
    if (number > 1000000000) {
      return "${(number / 1000000000).round().toStringAsFixed(1).toString()}B";
    }
    if (number > 1000000) {
      return "${(number / 1000000).round().toStringAsFixed(1).toString()}M";
    }

    if (number > 1000) {
      return "${(number / 1000).round().toStringAsFixed(1).toString()}K";
    }

    return number.toString();
  }

  static IconData getIcon({String deviceString = 'none'}) {
    if (deviceString.toLowerCase().contains('firefox')) {
      return FontAwesomeIcons.firefoxBrowser;
    }
    if (deviceString.toLowerCase().contains('android')) {
      return FontAwesomeIcons.android;
    }
    if (deviceString.toLowerCase().contains('chrome')) {
      return FontAwesomeIcons.chrome;
    }
    if (deviceString.toLowerCase().contains('safari')) {
      return FontAwesomeIcons.safari;
    }
    if (deviceString.toLowerCase().contains('edg') ||
        deviceString.toLowerCase().contains('edge') ||
        deviceString.toLowerCase().contains('edga')) {
      return FontAwesomeIcons.edge;
    }

    return FontAwesomeIcons.windows;
  }
}
