import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:rick_morty_character_explorer/controllers/character_controller.dart';
import 'package:rick_morty_character_explorer/models/character.dart';
import 'package:rick_morty_character_explorer/services/api_service.dart';

void main() {
  test('an older character request cannot overwrite the latest filter', () async {
    final allCharacters = Completer<List<Character>>();
    final unknownCharacters = Completer<List<Character>>();
    final controller = CharacterController(
      _DeferredApiService({
        null: allCharacters,
        'unknown': unknownCharacters,
      }),
    );

    final initialRequest = controller.loadCharacters();
    controller.selectedStatus.value = 'unknown';
    final filteredRequest = controller.loadCharacters();

    unknownCharacters.complete([_character(2, 'unknown')]);
    await filteredRequest;
    allCharacters.complete([_character(1, 'alive')]);
    await initialRequest;

    expect(controller.characters.single.status, 'unknown');
    expect(controller.isLoading.value, isFalse);
  });
}

class _DeferredApiService extends ApiService {
  _DeferredApiService(this.responses)
    : super(client: MockClient((_) async => http.Response('{}', 200)));

  final Map<String?, Completer<List<Character>>> responses;

  @override
  Future<List<Character>> fetchCharacters({String? status, String? name}) {
    return responses[status]!.future;
  }
}

Character _character(int id, String status) => Character(
  id: id,
  name: 'Character $id',
  status: status,
  species: 'Human',
  gender: 'Unknown',
  originName: 'Earth',
  locationName: 'Earth',
  image: '',
);
