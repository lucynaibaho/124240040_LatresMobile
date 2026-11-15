import 'dart:async';

import 'package:get/get.dart';

import '../models/character.dart';
import '../services/api_service.dart';

class CharacterController extends GetxController {
  CharacterController(this._apiService);

  final ApiService _apiService;
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxnString selectedStatus = RxnString();
  final RxString query = ''.obs;
  Timer? _searchTimer;

  @override
  void onInit() {
    super.onInit();
    loadCharacters();
  }

  void setStatus(String? status) {
    if (selectedStatus.value == status) return;
    selectedStatus.value = status;
    loadCharacters();
  }

  void search(String value) {
    query.value = value;
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 400), loadCharacters);
  }

  Future<void> loadCharacters() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      characters.assignAll(
        await _apiService.fetchCharacters(
          status: selectedStatus.value,
          name: query.value,
        ),
      );
    } on Object catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }
}
