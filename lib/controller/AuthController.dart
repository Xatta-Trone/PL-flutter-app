import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/models/User.dart';
import 'package:platform_device_id/platform_device_id.dart';

class AuthController extends GetxController {
  final isLoggedIn = RxBool(false);
  final user = Rxn<User>();
  final RxString token = ''.obs;

  Future<String?> getId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;

    print("devide id ${deviceId}");
  }

  Future<void> login() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    String deviceName =
        "Android ${androidInfo.version.sdkInt} on ${androidInfo.model}";

    try {
      var response = await Api().dio.post('/login', data: {
        'email': 'md-monzurul-islam1404143@example.com',
        'password': 'password',
        'fingerprint': deviceId,
        'deviceName': deviceName,
        'platform': 'android'
      });

      user.value = User.fromJson(response.data);
      isLoggedIn.value = true;
      token.value = response.data['access_token'];

      print(response.data);
    } on DioError catch (e) {
      user.value = null;
      isLoggedIn.value = false;
      token.value = '';
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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
