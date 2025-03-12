import 'package:hive/hive.dart';
part 'aya_model.g.dart';

@HiveType(typeId: 0) // تخصيص نوع البيانات
class Ayah {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final int surahNumber;

  @HiveField(3)
  final String? audio;
  @HiveField(4)
  final String? page;
  @HiveField(5)
  final String? juz;
  @HiveField(6)
  final String? hizbQuarter;

  Ayah({
    required this.number,
    required this.text,
    required this.surahNumber,
    this.audio,
    this.page,
    this.juz,
    this.hizbQuarter,
  });

  // تحويل إلى JSON
  Map<String, dynamic> toJson() => {
        'number': number,
        'text': text,
        'surahNumber': surahNumber,
        'audio': audio,
      };

  // إنشاء من JSON
  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json['number'] ?? json['numberInSurah'] ?? 0,
        text: json['text'] ?? '',
        surahNumber: json['surahNumber'] ?? json['surah']?['number'] ?? 0,
        audio: json['audio'],
        page: json['page'] ?? 0,
        juz: json['juz'] ?? 0,
        hizbQuarter: json['hizbQuarter'] ?? 0,
      );
}
