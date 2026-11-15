import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';
import '../models/episode.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://rickandmortyapi.com/api';
  final http.Client _client;

  Future<List<Character>> fetchCharacters({
    String? status,
    String? name,
  }) async {
    final parameters = <String, String>{};
    if (status != null) parameters['status'] = status;
    if (name != null && name.trim().isNotEmpty) {
      parameters['name'] = name.trim();
    }
    final json = await _getJson(
      Uri.parse('$_baseUrl/character').replace(queryParameters: parameters),
    );
    final results = json['results'];
    if (results is! List) {
      throw const ApiException(
        'Format daftar karakter dari server tidak valid.',
      );
    }
    return results.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const ApiException('Data karakter dari server tidak valid.');
      }
      return Character.fromJson(item);
    }).toList();
  }

  Future<Character> fetchCharacter(int id) async {
    final json = await _getJson(Uri.parse('$_baseUrl/character/$id'));
    return Character.fromJson(json);
  }

  Future<List<Episode>> fetchEpisodes() async {
    final json = await _getJson(Uri.parse('$_baseUrl/episode'));
    final results = json['results'];
    if (results is! List) {
      throw const ApiException(
        'Format daftar episode dari server tidak valid.',
      );
    }
    return results.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const ApiException('Data episode dari server tidak valid.');
      }
      return Episode.fromJson(item);
    }).toList();
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    late final http.Response response;
    try {
      response = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));
    } on Exception catch (error) {
      throw ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi Anda. ($error)',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        response.statusCode == 404
            ? 'Data tidak ditemukan.'
            : 'Server mengembalikan kesalahan (${response.statusCode}).',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Respons server tidak valid.');
    }
    return decoded;
  }
}
