class Episode {
  const Episode({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episodeCode,
  });

  final int id;
  final String name;
  final String airDate;
  final String episodeCode;

  factory Episode.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final airDate = json['air_date'];
    final code = json['episode'];
    if (id is! int ||
        name is! String ||
        airDate is! String ||
        code is! String) {
      throw const FormatException('Data episode dari server tidak valid.');
    }
    return Episode(id: id, name: name, airDate: airDate, episodeCode: code);
  }
}
