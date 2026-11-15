import 'package:get/get.dart';

import '../controllers/character_controller.dart';
import '../controllers/episode_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/navigation_controller.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoriteController(Get.find<LocalStorageService>()));
    Get.put(CharacterController(Get.find<ApiService>()));
    Get.put(EpisodeController(Get.find<ApiService>()));
    Get.put(NavigationController());
  }
}
