import 'dart:convert';
import 'package:http/http.dart' as http;

class CommentService {
  final String baseUrl;

  CommentService(this.baseUrl);

  Future<List<dynamic>> fetchComments(int motorbikeId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/comments/get/$motorbikeId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> postComment(
      int motorbikeId, int userId, String commentText) async {
    final commentDate = DateTime.now().toIso8601String();
    final response = await http.post(
      Uri.parse('$baseUrl/comments/post'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'motorbikeId': motorbikeId,
        'userId': userId,
        'commentText': commentText,
        'commentDate': commentDate,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to post comment');
    }
  }
}
