import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/controller/AuthController.dart';

class ChangeCurrentPassword extends StatefulWidget {
  const ChangeCurrentPassword({super.key});

  @override
  State<ChangeCurrentPassword> createState() => _ChangeCurrentPasswordState();
}

final _formKey = GlobalKey<FormState>();

final AuthController _authController = Get.find<AuthController>();

class _ChangeCurrentPasswordState extends State<ChangeCurrentPassword> {
  bool _obscureCurrentText = true; // for password toggle
  bool _obscureText = true; // for password toggle
  bool _obscureConfirmText = true; // for password toggle
  

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            inAsyncCall: _authController.isInAsyncCall.value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Change password',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            TextFormField(
                              controller: _authController.currentPwdController,
                              obscureText: _obscureCurrentText,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.password],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Current password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 2.0,
                                  ),
                                  child: GestureDetector(
                                    child: _obscureCurrentText
                                        ? const FaIcon(
                                            FontAwesomeIcons.eyeSlash,
                                            size: 18,
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.eye,
                                            size: 18,
                                          ),
                                    onTap: () {
                                      setState(() {
                                        _obscureCurrentText =
                                            !_obscureCurrentText;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: _authController.newPwdController,
                              obscureText: _obscureText,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newUsername],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your new password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be more than 8 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "New password",
                                helperText:
                                    'Password must be 8 characters or more.',
                                // errorText: _authController.passwordErrorText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 2.0,
                                  ),
                                  child: GestureDetector(
                                    child: _obscureText
                                        ? const FaIcon(
                                            FontAwesomeIcons.eyeSlash,
                                            size: 18,
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.eye,
                                            size: 18,
                                          ),
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller:
                                  _authController.newPwdConfirmController,
                              obscureText: _obscureConfirmText,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value !=
                                    _authController
                                        .newPwdController.value.text) {
                                  return 'Passwords do not match.';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Password confirmation",
                                // errorText: _authController.passwordErrorText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 2.0,
                                  ),
                                  child: GestureDetector(
                                    child: _obscureConfirmText
                                        ? const FaIcon(
                                            FontAwesomeIcons.eyeSlash,
                                            size: 18,
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.eye,
                                            size: 18,
                                          ),
                                    onTap: () {
                                      setState(() {
                                        _obscureConfirmText =
                                            !_obscureConfirmText;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50), // NEW
                              ),
                              // ignore: avoid_print
                              onPressed: () {
                                if (kDebugMode) {
                                  print(_formKey.currentState!.validate());
                                }

                                if (_formKey.currentState!.validate()) {
                                  // FocusManager.instance.primaryFocus?.unfocus();
                                  _formKey.currentState!.save();
                                  _authController.changeCurrentPassword();
                                }
                              },
                              child: Text(
                                'Change password',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
