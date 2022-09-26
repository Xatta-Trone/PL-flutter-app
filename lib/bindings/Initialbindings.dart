import 'package:get/get.dart';
import 'package:plandroid/controller/AuthController.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
