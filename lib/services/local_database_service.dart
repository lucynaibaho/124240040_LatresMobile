import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class LocalDatabaseService {
  LocalDatabaseService(this._accounts);

  static const _accountsBoxName = 'accounts';

  final Box<String> _accounts;

  static Future<LocalDatabaseService> open() async {
    final accounts = await Hive.openBox<String>(_accountsBoxName);
    return LocalDatabaseService(accounts);
  }

  Map<String, dynamic>? getAccount(String email) {
    final encoded = _accounts.get(email);
    if (encoded == null) return null;

    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Data akun lokal tidak valid.');
    }
    return decoded;
  }

  Future<void> saveAccount({
    required String email,
    required Map<String, dynamic> account,
  }) async {
    await _accounts.put(email, jsonEncode(account));
  }
}
