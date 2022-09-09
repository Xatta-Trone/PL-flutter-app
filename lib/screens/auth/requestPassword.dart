import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/routes/routeconst.dart';

class RequestPassword extends StatefulWidget {
  const RequestPassword({Key? key}) : super(key: key);

  @override
  State<RequestPassword> createState() => _RequestPasswordState();
}

final _formKey = GlobalKey<FormState>();
final AuthController _authController = Get.find<AuthController>();
class _RequestPasswordState extends State<RequestPassword> {
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            inAsyncCall: _authController.isInAsyncCall.value,
            opacity: 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Password Reset',
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
                            controller: _authController.pwdResetEmailController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            autofocus: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
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
                                _authController.requestPassword();
                              }
                            },
                            child: Text(
                              'Request code',
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
