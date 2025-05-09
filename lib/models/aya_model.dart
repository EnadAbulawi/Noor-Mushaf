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

  @HiveField(4) // جديد
  final int page;

  @HiveField(5) // جديد
  final int juz;

  @HiveField(6) // جديد
  final int hizbQuarter;

  Ayah({
    required this.number,
    required this.text,
    required this.surahNumber,
    this.audio,
    required this.page, // جديد
    required this.juz, // جديد
    required this.hizbQuarter, // جديد
  });

  // تحويل إلى JSON
  Map<String, dynamic> toJson() => {
        'number': number,
        'text': text,
        'surahNumber': surahNumber,
        'audio': audio,
        'page': page,
        'juz': juz,
        'hizb': hizbQuarter,
      };

  // إنشاء من JSON
  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json['number'] ?? json['numberInSurah'] ?? 0,
        text: json['text'] ?? '',
        surahNumber: json['surahNumber'] ?? json['surah']?['number'] ?? 0,
        audio: json['audio'],
        page: json['page'] ?? 0,
        juz: json['juz'] ?? 0,
        hizbQuarter: json['hizb'] ?? json['hizbQuarter'] ?? 0,
      );
}
