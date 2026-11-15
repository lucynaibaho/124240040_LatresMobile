import 'package:get/get.dart';

import '../models/character.dart';
import '../services/api_service.dart';
import 'favorite_controller.dart';

class DetailController extends GetxController {
  DetailController(this._apiService, this.favoriteController);

  final ApiService _apiService;
  final FavoriteController favoriteController;
  final Rxn<Character> character = Rxn<Character>();
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  late final int characterId;

  @override
  void onInit() {
    super.onInit();
    final argument = Get.arguments;
    if (argument is Character) {
      character.value = argument;
      characterId = argument.id;
    } else if (argument is int && argument > 0) {
      characterId = argument;
    } else {
      characterId = 0;
      errorMessage.value = 'Karakter tidak ditemukan.';
      isLoading.value = false;
      return;
    }
    loadCharacter();
  }

  Future<void> loadCharacter() async {
    if (characterId <= 0) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      character.value = await _apiService.fetchCharacter(characterId);
    } on Object catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
