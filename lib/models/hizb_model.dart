import 'aya_model.dart';

class HizbQuarter {
  final int number;
  final List<Ayah> ayahs;

  HizbQuarter({
    required this.number,
    required this.ayahs,
  });

  factory HizbQuarter.fromJson(Map<String, dynamic> json) {
    return HizbQuarter(
      number: json['number'] ?? 0,
      ayahs: (json['ayahs'] as List? ?? []).map((ayah) => Ayah.fromJson(ayah)).toList(),
    );
  }
}
