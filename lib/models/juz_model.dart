class JuzModel {
  final int number;
  final String startSurahName;
  final String endSurahName;
  final List<JuzVerse> verses;

  JuzModel({
    required this.number,
    required this.startSurahName,
    required this.endSurahName,
    required this.verses,
  });

  factory JuzModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ayahs = json['ayahs'];
    final verses = ayahs.map((ayah) => JuzVerse.fromJson(ayah)).toList();

    return JuzModel(
      number: json['number'],
      startSurahName: ayahs.first['surah']['name'],
      endSurahName: ayahs.last['surah']['name'],
      verses: verses,
    );
  }
}

class JuzVerse {
  final String text;
  final String surahName;
  final int number;

  JuzVerse({
    required this.text,
    required this.surahName,
    required this.number,
  });

  factory JuzVerse.fromJson(Map<String, dynamic> json) {
    return JuzVerse(
      text: json['text'],
      surahName: json['surah']['name'],
      number: json['numberInSurah'],
    );
  }
}
