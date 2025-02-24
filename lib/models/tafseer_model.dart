class TafseerModel {
  final int number;
  final int surah;
  final String text;

  TafseerModel({
    required this.number,
    required this.surah,
    required this.text,
  });

  factory TafseerModel.fromJson(Map<String, dynamic> json) {
    return TafseerModel(
      number: json['number'] ?? 0,
      surah: json['surah'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}