import 'package:flutter_dotenv/flutter_dotenv.dart';

// อ่านค่าจาก .env ที่ถูกโหลดไว้แล้วตอนเริ่มแอปใน main() (ดู dotenv.load ใน main.dart)
class Env {
  static String get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty || value == 'YOUR_API_KEY') {
      throw Exception(
        'ไม่พบค่า $key ใน .env กรุณาสร้างไฟล์ .env ที่ root โปรเจกต์ '
        'และใส่ค่า $key=<API_KEY_จริง> (ดูตัวอย่างใน .env.example)',
      );
    }
    return value;
  }
}
