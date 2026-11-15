import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_morty_character_explorer/models/character.dart';
import 'package:rick_morty_character_explorer/services/auth_service.dart';
import 'package:rick_morty_character_explorer/services/local_database_service.dart';
import 'package:rick_morty_character_explorer/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStorageService storage;
  late LocalDatabaseService database;
  late AuthService auth;
  late Directory databaseDirectory;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    databaseDirectory = await Directory.systemTemp.createTemp(
      'rick_morty_accounts_',
    );
    Hive.init(databaseDirectory.path);
    database = await LocalDatabaseService.open();
    storage = LocalStorageService(await SharedPreferences.getInstance());
    auth = AuthService(storage, database);
  });

  tearDown(() async {
    await Hive.close();
    await databaseDirectory.delete(recursive: true);
  });

  test('registers an account, then creates a session on login', () async {
    final user = await auth.register(
      name: 'Morty Smith',
      email: 'Morty@Example.com',
      password: 'portal123',
    );

    expect(user.email, 'morty@example.com');
    expect(auth.restoreSession(), isNull);
    final savedAccount = database.getAccount(user.email);
    expect(savedAccount?['password'], isNull);
    expect(savedAccount?['passwordHash'], isNotNull);

    await auth.logout();
    expect(auth.restoreSession(), isNull);

    final signedIn = await auth.login(
      email: 'MORTY@example.com',
      password: 'portal123',
    );
    expect(signedIn.name, user.name);
    expect(signedIn.email, user.email);
    expect(auth.restoreSession()?.email, user.email);
  });

  test('rejects duplicate accounts and incorrect passwords', () async {
    await auth.register(
      name: 'Rick Sanchez',
      email: 'rick@example.com',
      password: 'portal123',
    );

    await expectLater(
      auth.register(
        name: 'Another Rick',
        email: 'RICK@example.com',
        password: 'different',
      ),
      throwsA(isA<AuthException>()),
    );
    await expectLater(
      auth.login(email: 'rick@example.com', password: 'wrong-password'),
      throwsA(isA<AuthException>()),
    );
  });

  test('keeps registered accounts after reopening the Hive database', () async {
    await auth.register(
      name: 'Summer Smith',
      email: 'summer@example.com',
      password: 'portal123',
    );

    await Hive.close();
    Hive.init(databaseDirectory.path);
    database = await LocalDatabaseService.open();

    expect(database.getAccount('summer@example.com')?['name'], 'Summer Smith');
  });

  test('persists and restores favorite characters', () async {
    const character = Character(
      id: 1,
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      gender: 'Male',
      originName: 'Earth (C-137)',
      locationName: 'Citadel of Ricks',
      image: 'https://example.com/rick.png',
    );

    await storage.saveFavorites([character]);

    final restored = storage.getFavorites().single;
    expect(restored.id, character.id);
    expect(restored.name, character.name);
    expect(restored.originName, character.originName);
    expect(restored.locationName, character.locationName);
  });
}
