// ignore: file_names
import 'dart:io';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:plandroid/constants/const.dart';
import 'package:plandroid/controller/AuthController.dart';
import 'package:plandroid/globals/globals.dart';
// import 'package:barcode_finder/barcode_finder.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

final AuthController _authController = Get.find<AuthController>();

enum UserType { currentStudent, alumni, outsider }

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool _isStudentIDSet = true; // for password toggle
  var image;

  // final controller = BarcodeFinderController();

  Future<String?> scanFile() async {
    // Used to pick a file from device storage
    final pickedFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (pickedFile != null) {
      final filePath = pickedFile.files.single.path;
      if (filePath != null) {
        if (kDebugMode) {
          print(filePath);
        }
        setState(() {
          image = File(filePath);
        });
        // var res = await BarcodeFinder.scanFile(path: filePath);
        // print(res);
        try {
          var res = await BarcodeFinder.scanFile(path: filePath);
          if (kDebugMode) {
            print(res);
          }

          String decodedSID = res.toString();

          if (decodedSID.startsWith('S') && decodedSID.length == 10) {
            _authController.studentIdController.text = decodedSID;
            setState(() {
              _isStudentIDSet = true;
            });
          } else {
            _authController.studentIdController.clear();
            setState(() {
              _isStudentIDSet = false;
            });
            openDialog(
                'There is a problem with this image. Please choose a clear one.');
          }
          // openDialog(res.toString());
        } catch (e) {
          _authController.studentIdController.clear();
          setState(() {
            _isStudentIDSet = false;
          });
          openDialog(
              'There is a problem with this image. Please choose a clear one.');
        }
      }
    }
    return null;
  }

  void openDialog(String text) {
    Get.dialog(
      AlertDialog(
        title: const Text('Alert !'),
        content: Text(text),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  var selectedUserType;

  @override
  void initState() {
    _authController.getHalls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            opacity: 0.5,
            inAsyncCall: _authController.isInAsyncCall.value,
            child: Center(
              child: selectedUserType == null
                  ? selectUserType(theme.textTheme)
                  : selectedUserType == UserType.outsider
                      ? OutsiderWidget(txtTheme: theme.textTheme)
                      : selectedUserType == UserType.alumni
                          ? AlumniWidget(txtTheme: theme.textTheme)
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Register',
                                    style: theme.textTheme.headline4,
                                  ),
                                  const SizedBox(
                                    height: 25.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Please enter all the data according to your student ID card.',
                                            style: theme.textTheme.titleMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          TextFormField(
                                            controller:
                                                _authController.nameController,
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.text,
                                            autofocus: true,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your name';
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
                                             
                                              hintText: "Your official name",
                                              helperText:
                                                  'According to your student ID',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          TextFormField(
                                            controller: _authController
                                                .emailRegisterController,
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              final emailRegExp = RegExp(
                                                  r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your email';
                                              }

                                              if (emailRegExp.hasMatch(value) ==
                                                  false) {
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
                                             
                                              hintText: "E-mail address",
                                              helperText: 'Gmail is preferred',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Visibility(
                                            visible: false,
                                            child: TextFormField(
                                              controller: _authController
                                                  .studentIdController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your student id';
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
                                               
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   height: 15.0,
                                          // ),
                                          TextFormField(
                                            controller: _authController
                                                .meritPosController,
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your merit position';
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
                                             
                                              hintText: "Your merit position",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: theme.inputDecorationTheme
                                                  .fillColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(5.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              hint: const Text(
                                                'Select your hall',
                                              ),
                                              isExpanded: true,
                                              items: _authController.halls.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                // This is called when the user selects an item.
                                                _authController.setSelectedHall(
                                                    value ?? '');
                                                if (kDebugMode) {
                                                  print(value);
                                                }
                                              },
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Please select your hall';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          OutlinedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.black54,
                                              minimumSize:
                                                  const Size.fromHeight(
                                                      50.0), // NEW
                                            ),
                                            onPressed: () {
                                              if (kDebugMode) {
                                                print('pressed');
                                              }
                                              // pickImage();
                                              scanFile();
                                            },
                                            child: const Text(
                                              'Select the back side photo of student id',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          if (image != null) ...[
                                            const SizedBox(
                                              height: 15.0,
                                            ),
                                            SizedBox(
                                              height: 200,
                                              child: Image.file(
                                                image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ],

                                          Text.rich(
                                            textAlign: TextAlign.center,
                                            TextSpan(
                                              text:
                                                  'By registering you are agreeing to the ',
                                              children: [
                                                const TextSpan(text: '  '),
                                                TextSpan(
                                                  text: 'Terms & conditions',
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Globals.launchURL(
                                                              "$homeUrl/page/terms-and-conditions");
                                                        },
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.cyan),
                                                ),
                                                const TextSpan(text: '  '),
                                                TextSpan(
                                                  text: ' & Privacy policy',
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Globals.launchURL(
                                                              "$homeUrl/page/privacy-policy");
                                                        },
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.red),
                                                ),
                                              ],
                                            ),
                                          ),


                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize:
                                                  const Size.fromHeight(
                                                      50.0), // NEW
                                            ),
                                            onPressed: () {
                                              if (kDebugMode) {
                                                print(_formKey.currentState!
                                                    .validate());
                                              }

                                              if (!_isStudentIDSet) {
                                                openDialog(
                                                    'There was an error with the photo. Please use a different one.');
                                              }

                                              if (_formKey.currentState!
                                                  .validate()) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();

                                                _formKey.currentState!.save();
                                                _authController.register();
                                              }
                                            },
                                            child: Text(
                                              'Register',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ),
          ),
        ),
      ),
    );
  }

  Column selectUserType(TextTheme txtTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              'Choose your category',
              style: txtTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        divider,
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: () {
                setState(() {
                  selectedUserType = UserType.currentStudent;
                });
                if (kDebugMode) {
                  print(UserType.currentStudent);
                }
              },
              child: Center(
                  child: Text(
                'Current undergrad student',
                style: txtTheme.headline5,
              ))),
        ),
        divider,
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: () {
                setState(() {
                  selectedUserType = UserType.alumni;
                });
                if (kDebugMode) {
                  print(UserType.alumni);
                }
              },
              child: Center(
                  child: Text(
                'Alumni/ foreign student',
                style: txtTheme.headline5,
              ))),
        ),
        divider,
        Expanded(
          flex: 1,
          child: InkWell(
              onTap: () {
                setState(() {
                  selectedUserType = UserType.outsider;
                });
                if (kDebugMode) {
                  print(UserType.outsider);
                }
              },
              child: Center(
                  child: Text(
                'Non-buetian',
                style: txtTheme.headline5,
              ))),
        ),
      ],
    );
  }
}

class OutsiderWidget extends StatelessWidget {
  const OutsiderWidget({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    return StudentMsg(
      txtTheme: txtTheme,
      text:
          'Sorry, This website is only for the undergrad students of BUET. \n However, the books section is open for all. \n Thank you for your understanding.\n🙇‍♂️',
    );
  }
}

class AlumniWidget extends StatelessWidget {
  const AlumniWidget({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StudentMsg(
          txtTheme: txtTheme,
          text:
              'Please send a message to our FB page with your student id and email address. ',
        ),
        const SizedBox(
          height: 15.0,
        ),
        ElevatedButton(
          onPressed: () {
            if (kDebugMode) {
              print('follow us');
            }
            Globals.launchURL("https://www.facebook.com/thepltutorials");
          },
          child: const Text(
            'Go to FB page',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class StudentMsg extends StatelessWidget {
  const StudentMsg({
    Key? key,
    required this.txtTheme,
    required this.text,
  }) : super(key: key);

  final TextTheme txtTheme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: txtTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
