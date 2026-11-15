import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rick_morty_character_explorer/services/api_service.dart';

void main() {
  test('requests characters with status and name filters', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.url.path, '/api/character');
        expect(request.url.queryParameters, {
          'status': 'alive',
          'name': 'Rick',
        });
        return http.Response(
          jsonEncode({
            'results': [_characterJson],
          }),
          200,
        );
      }),
    );

    final characters = await service.fetchCharacters(
      status: 'alive',
      name: 'Rick',
    );

    expect(characters.single.id, 1);
    expect(characters.single.name, 'Rick Sanchez');
  });

  test('loads a character detail by ID', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.url.path, '/api/character/1');
        return http.Response(jsonEncode(_characterJson), 200);
      }),
    );

    final character = await service.fetchCharacter(1);

    expect(character.id, 1);
    expect(character.originName, 'Earth (C-137)');
  });

  test('loads episode names and air dates', () async {
    final service = ApiService(
      client: MockClient((request) async {
        expect(request.url.path, '/api/episode');
        return http.Response(
          jsonEncode({
            'results': [
              {
                'id': 1,
                'name': 'Pilot',
                'air_date': 'December 2, 2013',
                'episode': 'S01E01',
              },
            ],
          }),
          200,
        );
      }),
    );

    final episodes = await service.fetchEpisodes();

    expect(episodes.single.name, 'Pilot');
    expect(episodes.single.airDate, 'December 2, 2013');
  });

  test('reports API errors instead of returning empty data', () async {
    final service = ApiService(
      client: MockClient((request) async => http.Response('{}', 500)),
    );

    await expectLater(service.fetchCharacters(), throwsA(isA<ApiException>()));
  });
}

const _characterJson = {
  'id': 1,
  'name': 'Rick Sanchez',
  'status': 'Alive',
  'species': 'Human',
  'type': '',
  'gender': 'Male',
  'origin': {'name': 'Earth (C-137)', 'url': ''},
  'location': {'name': 'Citadel of Ricks', 'url': ''},
  'image': 'https://example.com/rick.png',
  'episode': ['https://rickandmortyapi.com/api/episode/1'],
  'url': 'https://rickandmortyapi.com/api/character/1',
  'created': '2017-11-04T18:48:46.250Z',
};
