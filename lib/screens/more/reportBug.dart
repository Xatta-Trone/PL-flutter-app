import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/src/form_data.dart' as form_data;
import 'package:dio/src/multipart_file.dart' as multipart_file;
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plandroid/api/api.dart';
import 'package:plandroid/globals/globals.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  State<ReportBugPage> createState() => _ReportBugPageState();
}

class _ReportBugPageState extends State<ReportBugPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController msgController = TextEditingController();
  // ignore: prefer_final_fields
  bool _isLoading = false;
  // ignore: prefer_final_fields
  double _progress = 0.0;
  // ignore: prefer_final_fields
  List<File> _images = List<File>.empty(growable: true);
  List uploadList = [];

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  _getFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png']);

    if (result != null) {
      // List<File> files = result.paths.map((path) => File(path)).toList();

      setState(() {
        _images.clear();
      });

      result.paths.asMap().forEach((index, file) {
        if (kDebugMode) {
          print(result.files[index].size);
        }

        // if the file size is less than 1mb then add to the list

        setState(() {
          if (result.files[index].size / (1024 * 1024) < 1) {
            _images.add(File(result.files[index].path.toString()));
            if (kDebugMode) {
              print('file path');
              print(result.files[index].path.toString());
            }
          }
        });
      });
    } else {
      // User canceled the picker
    }
  }

  Future submitResponse() async {
    setState(() {
      _isLoading = true;
    });

    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap().toString();

    if (kDebugMode) {
      print(map);
    }
    try {
      if (_images.isNotEmpty) {
        uploadList.clear();
        _images.asMap().forEach((key, value) async {
          String fileNameSingle = _images[key].path.split('/').last;
          // print(fileNameSingle);

          uploadList.add(await multipart_file.MultipartFile.fromFile(
            _images[key].path,
            filename: fileNameSingle,
          ));
        });
        // print(uploadList.toList());
      }

      var formData = form_data.FormData.fromMap({
        'message':
            "${msgController.value.text}  \n Device Info: \n $map \n Package info \n ${_packageInfo.toString()}",
        'files': _images.isEmpty ? null : uploadList,
      });

      var response = await Api().dio.post(
            '/report-bug',
            data: formData,
          );

      // Get.toNamed(changePassword);
      Get.defaultDialog(
        title: 'Success !!',
        middleText: "Response received successfully.",
        textConfirm: ('Okay'),
        onConfirm: () {
          Get.close(2);
          // cleanup
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
        _images.clear();
        _formKey.currentState?.reset();
      });
    }
  }

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  @override
  void dispose() {
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
                    'Report bug',
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
                      child: Column(
                        children: [
                          TextFormField(
                            controller: msgController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.newline,
                            minLines: 6,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please describe in details';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                             
                              hintText: "Describe in details",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () => _getFiles(),
                            // ignore: prefer_const_constructors
                            child: Text(
                              'Select Screenshots',
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          const Text('Each file size must be less than 1MB'),
                          const SizedBox(
                            height: 15.0,
                          ),
                          if (_images.isNotEmpty) ...[
                            SizedBox(
                              width: double.infinity,
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: _images.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  if (_images.isEmpty) {
                                    return const Center(child: Text('data'));
                                  }

                                  return Image.file(_images[index]);
                                },
                              ),
                            )
                          ],
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
                              style: Theme.of(context)
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
