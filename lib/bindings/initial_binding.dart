import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(AuthService(Get.find(), Get.find()), permanent: true);
    Get.put(AuthController(Get.find()), permanent: true);
  }
}
