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
  int _loadRequestId = 0;

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
    final requestId = ++_loadRequestId;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final results = await _apiService.fetchCharacters(
        status: selectedStatus.value,
        name: query.value,
      );
      if (requestId == _loadRequestId) characters.assignAll(results);
    } on Object catch (error) {
      if (requestId == _loadRequestId) errorMessage.value = error.toString();
    } finally {
      if (requestId == _loadRequestId) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }
}
