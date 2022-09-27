import 'package:get/get.dart';
import 'package:plandroid/models/CountData.dart';
import 'package:plandroid/models/Quote.dart';
import 'package:plandroid/models/TestimonialData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/sharedPrefConstants.dart';

class ThemeController extends GetxController {
  final isDarkTheme = RxBool(false);

  void getIsDarkTheme() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    var isDark = preference.getBool(isDarkThemeKey);

    if (isDark != null) {
      isDarkTheme.value = isDark;
    }
  }

  void toggleDarkTheme({bool value = true}) async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    var isDark = preference.getBool(isDarkThemeKey);

    if (isDark != null) {
      isDarkTheme.value = isDark;
      preference.setBool(isDarkThemeKey, !isDarkTheme.value);
      isDarkTheme.value = !isDarkTheme.value;
    } else {
      preference.setBool(isDarkThemeKey, value);
      isDarkTheme.value = value;
    }
  }

  @override
  void onInit() {
    getIsDarkTheme();
    super.onInit();
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}
