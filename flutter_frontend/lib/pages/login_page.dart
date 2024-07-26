import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/auth_guard.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final storage = const FlutterSecureStorage();

  String? _loginError;

  void _login() async {
    setState(() {
      _loginError = null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final apiService = UserService('http://10.0.2.2:3000/users');

      try {
        final response = await apiService.login(
          _emailController.text,
          _passwordController.text,
        );

        final String id = response['id'].toString();
        final String username = response['username'];
        final String token = response['token'];

        await storage.write(key: 'token', value: token);
        await storage.write(key: 'id', value: id);
        await storage.write(key: 'username', value: username);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful: $username')),
        );

        // ignore: use_build_context_synchronously
        AuthGuard().navigateTo(context, '/home');
      } catch (e) {
        setState(() {
          _loginError = e.toString();
          // _loginError = 'Wrong credentials';
        });
        _formKey.currentState?.validate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AuthGuard().navigateTo(context, '/');
          },
        ),
        title: Text(
          'Login',
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: theme.appBarTheme.titleTextStyle?.color,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 5),
                icon: Icon(
                  themeProvider.themeData.brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Welcome back!',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Please log in to continue!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  final emailRegExp = RegExp(
                    r'^[^@]+@[^@]+\.[^@]+$',
                    caseSensitive: false,
                  );
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  if (_loginError != null) {
                    return _loginError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (_loginError != null) {
                    return _loginError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.textTheme.bodyText1?.color,
                      ),
                    ),
                    TextSpan(
                      text: 'Register here',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade600,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AuthGuard().navigateTo(context, '/register');
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('LOG IN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
