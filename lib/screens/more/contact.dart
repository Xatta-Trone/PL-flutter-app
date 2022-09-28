import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/globals/globals.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

final _formKey = GlobalKey<FormState>();

class _ContactPageState extends State<ContactPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  // ignore: prefer_final_fields
  bool _isLoading = false;

  Future submitResponse() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await Api().dio.post('/submit-response', data: {
        'name': nameController.value.text,
        'email': emailController.value.text,
        'subject': subjectController.value.text,
        'body': msgController.value.text,
      });

      // Get.toNamed(changePassword);
      Get.defaultDialog(
        title: 'Success !!',
        middleText: "Response received successfully.",
        textConfirm: ('Okay'),
        onConfirm: () {
          Get.close(2);
          // cleanup
          nameController.clear();
          emailController.clear();
          subjectController.clear();
          msgController.clear();
        },
      );
    } on DioError catch (e) {
      if (e.response != null) {
        if (kDebugMode) {
          print(e.response);
          print(e.response?.data['status']);
        }

        String errData = Globals().formatText(
            e.response?.data['message'] ?? 'Something unknown occurred');

        Get.defaultDialog(
          title: 'Error !!',
          middleText: "${e.response?.statusCode}: $errData",
          textConfirm: ('Okay'),
          onConfirm: () => Get.back(),
        );
      } else {
        if (kDebugMode) {
          print(e.message);
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Get In Touch',
                    style: theme
                        .textTheme
                        .headline4
                        ,
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
                          children: [
                            TextFormField(
                              controller: nameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                      
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Your Name",
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
                              controller: emailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
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
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Your Email Address",
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
                              controller: subjectController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter subject';
                                }
                      
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Email Subject",
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
                              controller: msgController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.done,
                              minLines: 6,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please type your message';
                                }
                      
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText: "Message..",
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
                                  // FocusManager.instance.primaryFocus?.unfocus();
                                  _formKey.currentState!.save();
                                  submitResponse();
                                }
                              },
                              child: Text(
                                'Submit',
                                style: theme
                                    .textTheme
                                    .titleMedium
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
