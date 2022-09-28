import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:plandroid/screens/auth/Login.dart';
import 'package:platform_device_id/platform_device_id.dart';

class UserListedDevices extends StatefulWidget {
  const UserListedDevices({super.key});

  @override
  State<UserListedDevices> createState() => _UserListedDevicesState();
}

final AuthController authController = Get.find<AuthController>();

class _UserListedDevicesState extends State<UserListedDevices> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        body: SafeArea(
          child: Obx(
            () => !authController.isLoggedIn.value
                ? const Login()
                : ModalProgressHUD(
                    inAsyncCall: authController.isInAsyncCall.value,
                    opacity: 0.7,
                    child: RefreshIndicator(
                      onRefresh: () {
                        return authController.getUserDevices();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Saved devices',
                            style: theme.textTheme.titleLarge,
                          ),
                          Text(
                            "Maximum allowed device : ${authController.userDevices.value?.maxAllowedDevice.toString() ?? "refresh data"}",
                            style: theme.textTheme.titleMedium,
                          ),

                          if (authController.isGuestDevice.value) ...[
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "You are using this device as a guest user. If you wish to use this device frequently, then please add to the saved devices.",
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.redAccent),
                              ),
                            ),
                          ],

                          if (!authController.hasCheckedDevice.value) ...[
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "Please set the device to access restricted pages.",
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.redAccent),
                              ),
                            ),
                          ],

                          if (authController.userDevices.value != null) ...[
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: authController
                                    .userDevices.value?.devices.length,
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
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                            text: authController.userDevices
                                                .value?.devices[index].device
                                                .toString(),
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                              const TextSpan(text: '  '),
                                              TextSpan(
                                                  text:
                                                      "(${authController.userDevices.value?.devices[index].ipAddress.toString()})"),
                                              TextSpan(
                                                text: _isCurrentDevice(
                                                    authController
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
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Are you sure to delete this device ?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          authController.deleteUserDevice(
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
                                                        child:
                                                            const Text('Yes'),
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
                          if (authController
                                  .userDevices.value?.devices.length ==
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
                            )
                          ],
                          // ignore: prefer_is_empty
                          if (authController
                                  .userDevices.value?.devices.length ==
                              0) ...[
                            const SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                'No device saved',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(color: Colors.red),
                              ),
                            )
                          ],

                          if (authController.isInSavedDevice.value ==
                              false) ...[
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    authController.setUserDevice();
                                  },
                                  child: Text(
                                    'Add this device',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: Colors.white),
                                  )),
                            )
                          ],

                          if (authController.isGuestDevice.value == true) ...[
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    authController.removeGuestDevice();
                                  },
                                  child: Text(
                                    'Remove guest device',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: Colors.white),
                                  )),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'refresh-devices',
          onPressed: () {
            if (kDebugMode) {
              print('refresh  clicked');
            }
            authController.getUserDevices();
          },
          child: const FaIcon(
            FontAwesomeIcons.rotate,
            size: iconSize,
            color: Colors.white,
          ),
        ));
  }
}
