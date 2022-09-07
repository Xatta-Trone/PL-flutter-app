import 'package:url_launcher/url_launcher.dart';

class Globals {
  static Future<dynamic> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
