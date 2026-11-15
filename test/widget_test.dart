import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_morty_character_explorer/main.dart';
import 'package:rick_morty_character_explorer/services/local_database_service.dart';
import 'package:rick_morty_character_explorer/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Directory databaseDirectory;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    databaseDirectory = await Directory.systemTemp.createTemp(
      'rick_morty_app_',
    );
    Hive.init(databaseDirectory.path);
    final database = await LocalDatabaseService.open();
    Get.put(database, permanent: true);
    final preferences = await SharedPreferences.getInstance();
    Get.put(LocalStorageService(preferences), permanent: true);
  });

  tearDown(() async {
    Get.reset();
    await Hive.close();
    await databaseDirectory.delete(recursive: true);
  });

  testWidgets('unauthenticated users are sent to the login screen', (
    tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang kembali'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
