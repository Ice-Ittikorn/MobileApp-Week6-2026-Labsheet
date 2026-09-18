import 'services/weather_service.dart';

// สคริปต์ทดสอบ WeatherService.fetchWeather แบบ manual
// รัน: dart run lib/test_weather_service.dart
// ก่อนรัน ต้องใส่ API key จริงในไฟล์ .env ที่ root โปรเจกต์ (OPENWEATHER_API_KEY=...)
void main() async {
  final service = WeatherService();

  // กรณีที่ 1: สำเร็จ (statusCode 200) - ใช้ชื่อเมืองที่มีอยู่จริง
  print('--- กรณีสำเร็จ (Bangkok) ---');
  try {
    final weather = await service.fetchWeather('Bangkok');
    print('cityName: ${weather.cityName}');
    print('temperature: ${weather.temperature}');
    print('description: ${weather.description}');
    print('feelsLike: ${weather.feelsLike}');
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }

  // กรณีที่ 2: ไม่พบเมือง (statusCode 404) - ใช้ชื่อเมืองที่ไม่มีอยู่จริง
  print('\n--- กรณี 404 (เมืองไม่มีอยู่จริง) ---');
  try {
    final weather = await service.fetchWeather('asdkjaslkdjalskjd');
    print('cityName: ${weather.cityName}');
  } catch (e) {
    print('เกิดข้อผิดพลาด: $e');
  }
}
