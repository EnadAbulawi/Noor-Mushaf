class Reciter {
  final String id;
  final String name;
  final String server;

  Reciter({required this.id, required this.name, required this.server});

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'],
      name: json['name'],
      server: json['server'],
    );
  }
}

class Surah {
  final String id;
  final String name;

  Surah({required this.id, required this.name});

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'],
      name: json['name'],
    );
  }
}
