class Endpoints {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  // Quran Structure
  static const String surahs = '$baseUrl/surah';
  static const String juzs = '$baseUrl/juz';
  static const String pages = '$baseUrl/page';
  static const String hizbQuarters = '$baseUrl/hizbQuarter';

  // Single Item Endpoints
  static String surah(int number) => '$baseUrl/surah/$number';
  static String juz(int number) => '$baseUrl/juz/$number';
  static String page(int number) => '$baseUrl/page/$number';
  static String hizbQuarter(int number) => '$baseUrl/hizbQuarter/$number';

  // Editions & Translations
  static String ayahWithTafseer(int number) =>
      '$baseUrl/ayah/$number/editions/ar.muyassar';
  static String surahWithTafseer(int number) =>
      '$baseUrl/surah/$number/ar.muyassar';

  // Audio
  static String ayahAudio(int number) => '$baseUrl/ayah/$number/ar.alafasy';
}
