import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static const String baseUrl = "http://192.168.0.102/find_loc_api/";

  // Map রিটার্ন করবে যাতে স্ট্যাটাস এবং মেসেজ দুটোই পাওয়া যায়
  static Future<Map<String, dynamic>> signup(
      String name, String email, String phone, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}signup.php"),
        body: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          'success': data['status'] == 'success',
          'message': data['message'] ?? 'Something went wrong'
        };
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return {'success': false, 'message': 'Connection failed!'};
  }
}