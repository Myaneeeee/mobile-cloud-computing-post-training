import 'dart:convert';
import 'package:frontend/model/motorbike_model.dart';
import 'package:http/http.dart' as http;

class MotorbikeService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Motorbike>> fetchMotorbikes() async {
    final response = await http.get(Uri.parse('$baseUrl/motorbikes'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((motorbike) => Motorbike.fromJson(motorbike))
          .toList();
    } else {
      throw Exception('Failed to load motorbikes');
    }
  }
}
