import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AiProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;

  const AiProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory AiProduct.fromJson(Map<String, dynamic> json) {
    return AiProduct(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['image'] as String,
    );
  }
}

Future<List<AiProduct>> fetchAiProducts() async {
  final uri = Uri.parse('https://fakestoreapi.com/products');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => AiProduct.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('ไม่สามารถโหลดรายการสินค้าได้ (สถานะ ${response.statusCode})');
  } on TimeoutException {
    // เซิร์ฟเวอร์ไม่ตอบกลับภายในเวลาที่กำหนด (10 วินาที) เช่น เน็ตช้ามาก
    // ต้องดักแยกจาก error อื่น เพราะสาเหตุคือ "รอนานเกินไป" ไม่ใช่ "เชื่อมต่อไม่ได้เลย"
    // ผู้ใช้ควรได้รับคำแนะนำให้ลองใหม่ ไม่ใช่ error ทางเทคนิคที่งงว่าเกิดอะไรขึ้น
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // เกิดตอนเชื่อมต่อเซิร์ฟเวอร์ไม่ได้เลยตั้งแต่ต้น เช่น ไม่มีอินเทอร์เน็ต, DNS ผิดพลาด, เซิร์ฟเวอร์ล่ม
    // ต่างจาก TimeoutException ตรงที่นี่คือ "เชื่อมต่อไม่ติด" ไม่ใช่ "เชื่อมต่อได้แต่รอนาน"
    // จึงต้องแยกข้อความแจ้งเตือนให้ตรงสาเหตุ เพื่อให้ผู้ใช้รู้ว่าควรตรวจสอบอะไร
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // jsonDecode() โยน exception นี้เมื่อ response.body ไม่ใช่ JSON ที่ถูกต้อง
    // (เช่น เซิร์ฟเวอร์ส่ง HTML error page กลับมาแทน JSON) ต้องดักแยกเพราะเป็นปัญหาที่ฝั่ง
    // ข้อมูล ไม่ใช่ปัญหาเครือข่าย ถ้าไม่ดักไว้ ผู้ใช้จะเห็น error ดิบของ dart:convert ที่อ่านไม่รู้เรื่อง
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ กรุณาลองใหม่อีกครั้ง');
  }
}

Future<AiProduct> fetchAiProductById(int id) async {
  final uri = Uri.parse('https://fakestoreapi.com/products/$id');

  try {
    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AiProduct.fromJson(data);
    }
    throw Exception('ไม่พบสินค้าที่ต้องการ (สถานะ ${response.statusCode})');
  } on TimeoutException {
    // เหตุผลเดียวกับใน fetchAiProducts(): แยกกรณี "รอนานเกินไป" ออกจาก error อื่น
    throw Exception('การเชื่อมต่อหมดเวลา กรุณาลองใหม่อีกครั้ง');
  } on http.ClientException {
    // เหตุผลเดียวกับใน fetchAiProducts(): แยกกรณี "เชื่อมต่อไม่ติดเลย" ออกจาก timeout
    throw Exception('ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้ กรุณาตรวจสอบการเชื่อมต่อ');
  } on FormatException {
    // เหตุผลเดียวกับใน fetchAiProducts(): ป้องกัน error ดิบจาก jsonDecode() รั่วถึงผู้ใช้
    throw Exception('ข้อมูลที่ได้รับจากเซิร์ฟเวอร์ผิดรูปแบบ กรุณาลองใหม่อีกครั้ง');
  }
}
