import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rick_morty_character_explorer/controllers/character_controller.dart';
import 'package:rick_morty_character_explorer/controllers/favorite_controller.dart';
import 'package:rick_morty_character_explorer/models/character.dart';
import 'package:rick_morty_character_explorer/services/api_service.dart';
import 'package:rick_morty_character_explorer/services/local_storage_service.dart';
import 'package:rick_morty_character_explorer/views/favorites_screen.dart';
import 'package:rick_morty_character_explorer/views/home_screen.dart';
import 'package:rick_morty_character_explorer/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStorageService storage;
  late FavoriteController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = LocalStorageService(await SharedPreferences.getInstance());
    Get.put(storage);
    controller = Get.put(FavoriteController(storage));
  });

  tearDown(Get.reset);

  testWidgets('shows an empty state when no characters are saved', (
    tester,
  ) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: FavoritesScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada favorit'), findsOneWidget);
  });

  testWidgets('heart state updates when persisted favorites are loaded', (
    tester,
  ) async {
    final apiService = ApiService(
      client: MockClient(
        (request) async => http.Response(
          jsonEncode({
            'results': [_character.toJson()],
          }),
          200,
        ),
      ),
    );
    Get.put(CharacterController(apiService));

    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: HomeScreen())),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await storage.saveFavorites([_character]);
    await controller.loadFavorites();
    await tester.pump();

    final activeHeart = tester.widget<Icon>(find.byIcon(Icons.favorite));
    expect(activeHeart.color, AppTheme.favorite);
    expect(storage.getFavorites().single.id, _character.id);
  });
}

const _character = Character(
  id: 1,
  name: 'Rick Sanchez',
  status: 'Alive',
  species: 'Human',
  gender: 'Male',
  originName: 'Earth (C-137)',
  locationName: 'Citadel of Ricks',
  image: 'https://example.com/rick.png',
);
