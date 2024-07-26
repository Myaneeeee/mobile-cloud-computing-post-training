import 'package:flutter/material.dart';
import 'package:frontend/auth_guard.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/items_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:frontend/pages/welcome_page.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harley-Davidboy',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/items': (context) => const ItemsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
