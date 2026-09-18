import 'dart:convert';
import 'models/weather.dart'; // ปรับ path ให้ตรงกับตำแหน่งไฟล์จริงในโปรเจกต์

void main() {
  // TODO: แทนที่ข้อความด้านล่างด้วย Response Body จริงที่คัดลอกมาจาก Postman ในขั้นตอนที่ 1.1
  const rawJson = '''
  {
      "coord": {
          "lon": 100.5167,
          "lat": 13.75
      },
      "weather": [
          {
              "id": 501,
              "main": "Rain",
              "description": "ฝนปานกลาง",
              "icon": "10d"
          }
      ],
      "base": "stations",
      "main": {
          "temp": 29.7,
          "feels_like": 35.49,
          "temp_min": 27.94,
          "temp_max": 30.51,
          "pressure": 1007,
          "humidity": 75,
          "sea_level": 1007,
          "grnd_level": 1006
      },
      "visibility": 10000,
      "wind": {
          "speed": 0.99,
          "deg": 264,
          "gust": 1.45
      },
      "rain": {
          "1h": 1.3
      },
      "clouds": {
          "all": 97
      },
      "dt": 1789713679,
      "sys": {
          "type": 2,
          "id": 2112373,
          "country": "TH",
          "sunrise": 1789686417,
          "sunset": 1789730264
      },
      "timezone": 25200,
      "id": 1609350,
      "name": "กรุงเทพมหานคร",
      "cod": 200
  }
  ''';

  final json = jsonDecode(rawJson) as Map<String, dynamic>;
  final weather = Weather.fromJson(json);

  print('cityName: ${weather.cityName}');
  print('temperature: ${weather.temperature}');
  print('description: ${weather.description}');
  print('feelsLike: ${weather.feelsLike}');
}
