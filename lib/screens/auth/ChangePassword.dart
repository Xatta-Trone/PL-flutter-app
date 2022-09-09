// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/controller/AuthController.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

final _formKey = GlobalKey<FormState>();

final AuthController _authController = Get.find<AuthController>();

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureText = true; // for password toggle
  bool _obscureConfirmText = true; // for password toggle

  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.black87),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'A code has been sent to your email address. Please enter the code below. The code expires in 60 minutes.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          TextFormField(
                            controller: _authController.pwdCodeController,
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the reset code';
                              }

                              if (value.length < 6 || value.length > 6) {
                                return 'Please enter the full code';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {});
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Password reset code",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: _authController.changePwdController,
                            obscureText: _obscureText,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be more than 8 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Password",
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
                                          FontAwesomeIcons.eye,
                                          size: 18,
                                        )
                                      : const FaIcon(
                                          FontAwesomeIcons.eyeSlash,
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
                                _authController.changePwdConfirmationController,
                            obscureText: _obscureConfirmText,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value !=
                                  _authController
                                      .changePwdController.value.text) {
                                return 'Passwords do not match.';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
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
                                          FontAwesomeIcons.eye,
                                          size: 18,
                                        )
                                      : const FaIcon(
                                          FontAwesomeIcons.eyeSlash,
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
                                _authController.resetPassword();
                              }
                            },
                            child: Text(
                              'Change password',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                        ],
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
