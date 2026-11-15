import 'package:get/get.dart';

import '../controllers/detail_controller.dart';
import '../services/api_service.dart';
import '../controllers/favorite_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DetailController(
        Get.find<ApiService>(),
        Get.find<FavoriteController>(),
      ),
    );
  }
}
