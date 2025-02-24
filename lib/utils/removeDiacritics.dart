// دالة لإزالة التشكيل والزخرفة من النصوص
String normalizeArabicText(String text) {
  final diacritics = RegExp(r'[\u064B-\u0652]'); // جميع الحركات والتنوين
  final decorations = RegExp(r'[\u06D6-\u06ED]'); // جميع الزخارف القرآنية
  return text
      .replaceAll(diacritics, '')
      .replaceAll(decorations, '')
      .trim()
      .toLowerCase();
}
