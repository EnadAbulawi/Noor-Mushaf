class BookmarkModel {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;
  final DateTime dateAdded;
  final String category;

  BookmarkModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
    required this.dateAdded,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'surahName': surahName,
        'ayahText': ayahText,
        'dateAdded': dateAdded.toIso8601String(),
        'category': category,
      };

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        surahNumber: json['surahNumber'],
        ayahNumber: json['ayahNumber'],
        surahName: json['surahName'],
        ayahText: json['ayahText'],
        dateAdded: DateTime.parse(json['dateAdded']),
        category: json['category'],
      );
}