import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/controller/AuthController.dart';

class DeviceGuardPage extends StatefulWidget {
  const DeviceGuardPage({super.key});

  @override
  State<DeviceGuardPage> createState() => _DeviceGuardPageState();
}

final AuthController authController = Get.find<AuthController>();

class _DeviceGuardPageState extends State<DeviceGuardPage> {
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
                  Text(
                    'You can manage the saved devices from your profile section.',
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
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
