import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme/theme_provider.dart';

class LogoWidget extends StatelessWidget {
  final double height;

  const LogoWidget({Key? key, this.height = 250}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final logoAsset = themeProvider.themeData.brightness == Brightness.light
        ? 'assets/images/logo.png'
        : 'assets/images/logo_dark.png';

    return Image.asset(
      logoAsset,
      height: height,
    );
  }
}
