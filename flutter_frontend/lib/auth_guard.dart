import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthGuard {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: 'token');
    return token != null;
  }

  Future<void> navigateTo(BuildContext context, String route) async {
    final isLoggedIn = await isAuthenticated();
    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, route);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/login');
    }
  }
}
