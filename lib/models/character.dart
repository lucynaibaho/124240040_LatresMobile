class Character {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String originName;
  final String locationName;
  final String image;

  factory Character.fromJson(Map<String, dynamic> json) {
    final origin = json['origin'];
    final location = json['location'];
    if (origin is! Map<String, dynamic> || location is! Map<String, dynamic>) {
      throw const FormatException('Data karakter dari server tidak valid.');
    }

    return Character(
      id: _asInt(json['id'], 'id'),
      name: _asString(json['name'], 'name'),
      status: _asString(json['status'], 'status'),
      species: _asString(json['species'], 'species'),
      gender: _asString(json['gender'], 'gender'),
      originName: _asString(origin['name'], 'origin.name'),
      locationName: _asString(location['name'], 'location.name'),
      image: _asString(json['image'], 'image'),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'gender': gender,
    'origin': {'name': originName},
    'location': {'name': locationName},
    'image': image,
  };

  static int _asInt(Object? value, String field) {
    if (value is int) return value;
    throw FormatException('Field $field karakter tidak valid.');
  }

  static String _asString(Object? value, String field) {
    if (value is String) return value;
    throw FormatException('Field $field karakter tidak valid.');
  }
}
