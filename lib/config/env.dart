import 'dart:io';

// โหลดค่าจากไฟล์ .env ที่ root ของโปรเจกต์ (ไม่ commit เข้า git)
// ใช้ได้กับสคริปต์ที่รันผ่าน `dart run` / `flutter run` จาก root โปรเจกต์เท่านั้น
class Env {
  static Map<String, String>? _cache;

  static Map<String, String> _load() {
    if (_cache != null) return _cache!;

    final file = File('.env');
    final values = <String, String>{};

    if (file.existsSync()) {
      for (final rawLine in file.readAsLinesSync()) {
        final line = rawLine.trim();
        if (line.isEmpty || line.startsWith('#')) continue;

        final separatorIndex = line.indexOf('=');
        if (separatorIndex == -1) continue;

        final key = line.substring(0, separatorIndex).trim();
        final value = line.substring(separatorIndex + 1).trim();
        values[key] = value;
      }
    }

    _cache = values;
    return values;
  }

  static String get(String key) {
    final value = _load()[key];
    if (value == null || value.isEmpty || value == 'YOUR_API_KEY') {
      throw Exception(
        'ไม่พบค่า $key ใน .env กรุณาสร้างไฟล์ .env ที่ root โปรเจกต์ '
        'และใส่ค่า $key=<API_KEY_จริง> (ดูตัวอย่างใน .env.example)',
      );
    }
    return value;
  }
}
