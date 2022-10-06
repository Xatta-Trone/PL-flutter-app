import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:platform_device_id/platform_device_id.dart';

class DeviceGuardPage extends StatefulWidget {
  const DeviceGuardPage({super.key});

  @override
  State<DeviceGuardPage> createState() => _DeviceGuardPageState();
}

final AuthController authController = Get.find<AuthController>();

class _DeviceGuardPageState extends State<DeviceGuardPage> {
  String fingerprint = '';

  Future<void> getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    setState(() {
      if (deviceId != null) {
        fingerprint = deviceId;
      }
    });
  }

  String _isCurrentDevice(String deviceFingerprint) {
    return fingerprint == deviceFingerprint ? 'This device' : '';
  }

  @override
  void initState() {
    getDeviceId();

    authController.isLoggedIn.listen((value) {
      if (kDebugMode) {
        print("logged in value from device guard $value");
      }
      if (value) {
        authController.getUserDevices();
      }
    });
    
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
          child: Obx(
        () => ModalProgressHUD(
          inAsyncCall: authController.isInAsyncCall.value,
          opacity: 0.7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Alert !!',
                    style: theme.textTheme.headline4,
                  ),
                  Text(
                    'This is not your primary device!!',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  if (authController.userDevices.value?.devices.length ==
                      int.tryParse(authController
                              .userDevices.value?.maxAllowedDevice
                              .toString() ??
                          "0")) ...[
                    Container(
                      color: theme.cardColor.withOpacity(0.6),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Text(
                        'You have reached your device limit. \n You can delete saved devices to add more.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                    if (authController.userDevices.value != null) ...[
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              authController.userDevices.value?.devices.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: theme.cardColor.withOpacity(0.6),
                              margin: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: ListTile(
                                  isThreeLine: true,
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Center(
                                      child: FaIcon(
                                        Globals.getIcon(
                                          deviceString: authController
                                                  .userDevices
                                                  .value
                                                  ?.devices[index]
                                                  .device
                                                  .toString() ??
                                              "",
                                        ),
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      text: authController.userDevices.value
                                          ?.devices[index].device
                                          .toString(),
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        const TextSpan(text: '  '),
                                        TextSpan(
                                            text:
                                                "(${authController.userDevices.value?.devices[index].ipAddress.toString()})"),
                                        TextSpan(
                                          text: _isCurrentDevice(authController
                                                  .userDevices
                                                  .value
                                                  ?.devices[index]
                                                  .fingerprint
                                                  .toString() ??
                                              ""),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  subtitle: Text(
                                    authController.userDevices.value
                                            ?.devices[index].location
                                            .toString() ??
                                        "",
                                  ),
                                  trailing: IconButton(
                                    icon: const FaIcon(
                                      FontAwesomeIcons.trashCan,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Are you sure to delete this device ?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    authController
                                                        .deleteUserDevice(
                                                            id: authController
                                                                    .userDevices
                                                                    .value
                                                                    ?.devices[
                                                                        index]
                                                                    .id
                                                                    .toString() ??
                                                                "");
                                                    Get.back();
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text(
                                                    'No',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                  )),
                            );
                          },
                        ),
                      )
                    ],
                  ],
                  
                  Text(
                    'For regular use',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      authController.setUserDevice();
                    },
                    child: Text(
                      'Add to saved devices',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'For temporary use',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      authController.setAsGuestDevice();
                    },
                    child: Text(
                      'Continue as a guest',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'If your are using this device frequently and is not in your saved devices list, your account may get restricted by the system automatically.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.red),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
