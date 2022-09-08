import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/routes/routeconst.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true; // for password toggle

  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    // _obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => ModalProgressHUD(
          opacity: 0.5,
          inAsyncCall: _authController.isInAsyncCall.value,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.black87),
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
                          controller: _authController.emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofocus: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            final emailRegExp = RegExp(
                                r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            if (emailRegExp.hasMatch(value) == false) {
                              return 'Please enter a valid email';
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
                            hintText: "E-mail address",
                            errorText: _authController.emailErrorText,
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
                          controller: _authController.passwordController,
                          obscureText: _obscureText,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Please enter your full password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
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
                              FocusManager.instance.primaryFocus?.unfocus();
                              _formKey.currentState!.save();
                              _authController.login();
                            }
                          },
                          child: Text(
                            'Login',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextButton(
                          onPressed: () {
                            if (kDebugMode) {
                              print('create new account');
                            }
                            Get.toNamed(register);
                          },
                          child: Text(
                            'Create New Account',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 0.0,
                        // ),
                        TextButton(
                          onPressed: () {
                            if (kDebugMode) {
                              print('forgot your password');
                            }
                            Get.toNamed(requestPassword);
                          },
                          child: const Text(
                            'Reset Your Password',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
