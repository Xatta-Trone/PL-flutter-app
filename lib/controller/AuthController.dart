import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/constants/sharedPrefConstants.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/models/User.dart';
import 'package:plandroid/models/UserSavedDevices.dart';
import 'package:plandroid/routes/routeconst.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final isLoggedIn = RxBool(false);
  RxBool isInAsyncCall = RxBool(false);
  RxBool isPwdReqSuccess = RxBool(false);
  RxBool isInSavedDevice = RxBool(false);
  RxBool isGuestDevice = RxBool(false);
  RxBool hasCheckedDevice = RxBool(false);
  final user = Rxn<User>();
  final RxString token = ''.obs;
  final Rxn<UserSavedDevices> userDevices = Rxn<UserSavedDevices>();

  String serverValidationErr = '';

  // login text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // change password
  TextEditingController pwdResetEmailController = TextEditingController();
  TextEditingController changePwdController = TextEditingController();
  TextEditingController changePwdConfirmationController =
      TextEditingController();
  TextEditingController pwdCodeController = TextEditingController();

  // register page
  TextEditingController nameController = TextEditingController();
  TextEditingController emailRegisterController = TextEditingController();
  TextEditingController meritPosController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  RxString hallNameController = ''.obs;

  // change current password
  TextEditingController currentPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController newPwdConfirmController = TextEditingController();

  // variables
  RxList<String> halls = (List<String>.of([])).obs;

  void clearValues() {
    emailController.clear();
    passwordController.clear();
    pwdResetEmailController.clear();
    changePwdController.clear();
    changePwdConfirmationController.clear();
    pwdCodeController.clear();
    nameController.clear();
    emailRegisterController.clear();
    meritPosController.clear();
    studentIdController.clear();
    hallNameController.value = '';
    currentPwdController.clear();
    newPwdController.clear();
    newPwdConfirmController.clear();
  }

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
    // ignore: unused_local_variable
    final text = passwordController.value.text;
    // Note: you can do your own custom validation here

    // if (text.length < 2 || text.isEmpty) {
    //   return 'Please enter your password.';
    // }

    // return null if the text is valid
    return null;
  }

  // functions

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

      emailController.clear();
      passwordController.clear();

      if (kDebugMode) {
        print(response.data);
      }
    } on DioError catch (e) {
      setLogoutValues();
      // server sent a res back with err
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response);
        }

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text(
                "${e.response?.statusCode}: ${e.response?.data['message'] ?? 'Something unknown occurred'}"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print(e.message);
        }
        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: const Text("Something unknown occurred"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    } finally {
      isInAsyncCall.value = false;
    }
  }

  Future<void> requestPassword() async {
    // set async call to true
    isInAsyncCall.value = true;

    try {
      var response = await Api().dio.post('/request-password', data: {
        'email': pwdResetEmailController.value.text,
      });

      // isPwdReqSuccess.value = true;

      Get.toNamed(changePassword);

      if (kDebugMode) {
        print(response.data);
      }
    } on DioError catch (e) {
      // server sent a res back with err
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response);
          print(e.response?.data['status']);
        }

        isPwdReqSuccess.value = false;

        String errData = Globals().formatText(
            e.response?.data['message'] ?? 'Something unknown occurred');

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text("${e.response?.statusCode}: $errData"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print(e.message);
        }

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: const Text("Something unknown occurred."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    } finally {
      // async call complete
      isInAsyncCall.value = false;
    }
  }

  Future<void> resetPassword() async {
    // set async call to true
    isInAsyncCall.value = true;

    try {
      var response = await Api().dio.post('/reset-password', data: {
        'email': pwdResetEmailController.value.text,
        'password': changePwdController.value.text,
        'password_confirmation': changePwdConfirmationController.value.text,
        'token': pwdCodeController.value.text
      });

      // cleanup
      pwdResetEmailController.clear();
      changePwdController.clear();
      changePwdConfirmationController.clear();
      pwdCodeController.clear();

      Get.dialog(
        AlertDialog(
          title: const Text('Success !!'),
          content: const Text(
              "Password changed successfully. Now login into your account."),
          actions: [
            TextButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.offAllNamed(homePage);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );

      if (kDebugMode) {
        print(response.data);
      }
    } on DioError catch (e) {
      // server sent a res back with err
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response);
          print(e.response?.data['status']);
        }

        isPwdReqSuccess.value = false;

        String errData = Globals().formatText(
            e.response?.data['message'] ?? 'Something unknown occurred');

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text("${e.response?.statusCode}: $errData"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print(e.message);
        }
        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: const Text("Something unknown occurred"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    } finally {
      // async call complete
      isInAsyncCall.value = false;
    }
  }

  Future<void> changeCurrentPassword() async {
    // set async call to true
    isInAsyncCall.value = true;

    try {
      var response = await Api().dio.post('/reset-user-password', data: {
        'old_password': currentPwdController.value.text,
        'password': newPwdController.value.text,
        'password_confirmation': newPwdConfirmController.value.text,
      });

      Get.dialog(
        AlertDialog(
          title: const Text('Success !!'),
          content: const Text("Password changed successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Get.close(2);
                FocusManager.instance.primaryFocus?.unfocus();
                // cleanup
                currentPwdController.clear();
                newPwdController.clear();
                newPwdConfirmController.clear();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );

      if (kDebugMode) {
        print(response.data);
      }
    } on DioError catch (e) {
      // server sent a res back with err
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response);
          print(e.response?.data['status']);
        }

        isPwdReqSuccess.value = false;

        String errData = Globals().formatText(
            e.response?.data['message'] ?? 'Something unknown occurred');

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text("${e.response?.statusCode}: $errData"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print(e.message);
        }
        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: const Text("Something unknown occurred."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    } finally {
      // async call complete
      isInAsyncCall.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // ignore: unused_local_variable
      var response = await Api().dio.get('/logout');
      // logout user
      setLogoutValues();
    } on DioError catch (e) {
      setLogoutValues();
      // server sent a res back with err
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response);
        }

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text(
                "${e.response?.statusCode}: ${e.response?.data['message'] ?? 'Something unknown occurred'}"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print(e.message);
        }
      }
    }
  }

  Future<void> autoLogin() async {
    if (kDebugMode) {
      print('===========auto login================');
    }
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userData = preferences.getString(userDataKey);

    if (userData != null) {
      Map<String, dynamic> jsonUserData = jsonDecode(userData);
      setLoginValues(jsonUserData);
      // getUserDevices();
    }
  }

  Future<void> getHalls() async {
    try {
      var response = await Api().dio.get('/halls');

      if (response.data != null) {
        // update state
        if (kDebugMode) {
          print(response.data['data']);
        }
        halls.value = List<String>.from(response.data['data']);
        // insert select
        // halls.insert(0, 'Select your hall');
        // return hallList;
        // print(halls);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void setSelectedHall(String hall) {
    hallNameController.value = hall;
  }

  Future<void> register() async {
    isInAsyncCall.value = true;
    try {
      var response = await Api().dio.post('/register', data: {
        'name': nameController.value.text,
        'email': emailRegisterController.value.text,
        'merit_position': meritPosController.value.text,
        'hall_name': hallNameController.value,
        'student_id': studentIdController.value.text,
      });

      clearValues();

      Get.dialog(
        AlertDialog(
          title: const Text('Success !!'),
          content: const Text(
              "Account created successfully. Please check your email (also spam) for the password."),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAllNamed(homePage);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } on DioError catch (e) {
      // server sent a res back with err
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response);
        }

        // check if validation err occurred
        if (e.response?.data['errors'] != null) {
          String combinedMessage = "";
          e.response?.data['errors'].forEach((key, messages) {
            for (var message in messages) {
              combinedMessage = "$combinedMessage- $message\n";
            }
          });

          return Get.dialog(
            AlertDialog(
              title: const Text('Error !!'),
              content: Text("${e.response?.statusCode}: $combinedMessage"),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Okay'),
                )
              ],
            ),
          );
        }

        String errData = Globals().formatText(
            e.response?.data['message'] ?? 'Something unknown occurred');

        // var res = json.decode(e.response?.data['errors']);

        if (kDebugMode) {
          print(e.response?.data['errors']);
          // String combinedMessage = "";

          // e.response?.data['errors'].forEach((key, messages) {
          //   for (var message in messages) {
          //     combinedMessage = combinedMessage + "- $message\n";
          //   }
          // });

          // print(combinedMessage);
        }

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text("${e.response?.statusCode}: $errData"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print(e.message);
        }

        Get.dialog(
          AlertDialog(
            title: const Text('Error !!'),
            content: Text(
                "${e.response?.statusCode}: Something unexpected occurred. ${e.message}"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('Okay'),
              )
            ],
          ),
        );
      }
    } finally {
      isInAsyncCall.value = false;
    }
  }

  void setLoginValues(userData) {
    user.value = User.fromJson(userData);
    isLoggedIn.value = true;
    token.value = user.value!.accessToken;
    getUserDevices();
  }

  Future<void> setLogoutValues() async {
    user.value = null;
    isLoggedIn.value = false;
    token.value = '';
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(userDataKey);
    await preferences.remove(isPrimaryDeviceKey);
    userDevices.value = null;
  }

  Future<void> getUserDevices() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    isInAsyncCall.value = true;
    try {
      var response = await Api().dio.get('/user-devices');

      if (kDebugMode) {
        print('====user devices ===');
        // print(response.data);
      }
      userDevices.value = null;
      userDevices.value = UserSavedDevices.fromMap(response.data);

      if (kDebugMode) {
        print(userDevices.value.toString());
      }

      // check if current device is set
      var currentDevice =
          userDevices.value?.devices.firstWhereOrNull((Device device) {
        return device.fingerprint == deviceId;
      });

      if (currentDevice == null) {
        isInSavedDevice.value = false;
        // check if guest device
        var isGuest = preferences.get(isGuestDeviceKey);
        if (isGuest != null) {
          isGuestDevice.value = true;
          hasCheckedDevice.value = true;
        } else {
          isGuestDevice.value = false;
          hasCheckedDevice.value = false;
        }

        preferences.remove(isPrimaryDeviceKey);
      } else {
        isInSavedDevice.value = true;
        isGuestDevice.value = false;
        hasCheckedDevice.value = true;
        preferences.remove(isGuestDeviceKey);
        preferences.setBool(isPrimaryDeviceKey, true);
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      userDevices.value = null;
    } finally {
      isInAsyncCall.value = false;
    }
  }

  Future<void> setUserDevice() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    String deviceName =
        "Android ${androidInfo.version.sdkInt} on ${androidInfo.model}";
    isInAsyncCall.value = true;

    try {
      // ignore: unused_local_variable
      var response = await Api().dio.post('/user-devices', data: {
        'fingerprint': deviceId,
        'deviceName': deviceName,
        'platform': 'android'
      });

      if (kDebugMode) {
        print('==== set user devices ===');
        // print(response.data);
      }

      getUserDevices();
      // set this is the device that is set
      isInSavedDevice.value = true;
      hasCheckedDevice.value = true;
      isGuestDevice.value = false;
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setBool(isPrimaryDeviceKey, true);
      await preferences.remove(isGuestDeviceKey);

      Get.dialog(
        AlertDialog(
          title: const Text('Success !!'),
          content: const Text("Device added"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      String errData = Globals().formatText(
          e.response?.data['message'] ?? 'Something unknown occurred');

      Get.dialog(
        AlertDialog(
          title: const Text('Error !!'),
          content: Text("${e.response?.statusCode}: $errData"),
          actions: [
            TextButton(
              onPressed: () {
                getUserDevices();
                Get.back();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } finally {
      isInAsyncCall.value = false;
    }
  }

  Future<void> deleteUserDevice({String id = ""}) async {
    if (id == "") return;

    isInAsyncCall.value = true;
    try {
      // ignore: unused_local_variable
      var response = await Api().dio.delete("/user-devices/$id");

      if (kDebugMode) {
        print('====user devices delete ===');
        // print(response.data);
      }

      Get.dialog(
        AlertDialog(
          title: const Text('Success !!'),
          content: const Text("Device removed"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );

      getUserDevices();
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      String errData = Globals().formatText(
          e.response?.data['message'] ?? 'Something unknown occurred');

      Get.dialog(
        AlertDialog(
          title: const Text('Error !!'),
          content: Text("${e.response?.statusCode}: $errData"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  void setAsGuestDevice() async {
    // RxBool isInSavedDevice = RxBool(false);
    // RxBool isGuestDevice = RxBool(true);
    // RxBool hasCheckedDevice = RxBool(false);
    isInAsyncCall.value = true;

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    isGuestDevice.value = true;
    hasCheckedDevice.value = true;
    preferences.setBool(isGuestDeviceKey, true);

    isInAsyncCall.value = false;
  }

  void checkIfGuestDevice() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    var isGuest = preferences.get(isGuestDeviceKey);
    if (isGuest != null) {
      isGuestDevice.value = true;
      hasCheckedDevice.value = true;
    }
  }

  void removeGuestDevice() async {
    isInAsyncCall.value = true;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(isGuestDeviceKey);
    isGuestDevice.value = false;
    hasCheckedDevice.value = isInSavedDevice.value ? true : false;
    isInAsyncCall.value = false;
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
    checkIfGuestDevice();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    pwdResetEmailController.dispose();
    changePwdController.dispose();
    changePwdConfirmationController.dispose();
    pwdCodeController.dispose();
    currentPwdController.dispose();
    newPwdController.dispose();
    newPwdConfirmController.dispose();
    super.dispose();
  }
}
