import 'package:get/get.dart';

import '../models/episode.dart';
import '../services/api_service.dart';

class EpisodeController extends GetxController {
  EpisodeController(this._apiService);

  final ApiService _apiService;
  final RxList<Episode> episodes = <Episode>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadEpisodes();
  }

  Future<void> loadEpisodes() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      episodes.assignAll(await _apiService.fetchEpisodes());
    } on Object catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
