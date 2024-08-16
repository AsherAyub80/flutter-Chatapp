import 'package:flutter/material.dart';
import 'package:flutter_chat_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return animatedSwitch(
        themeProvider.isDarkMode, (value) => themeProvider.toggleTheme());
  }

  Widget animatedSwitch(bool value, void Function(bool) onChange) =>
      Transform.scale(
        scale: 1.2,
        child: Switch(
          value: value,
          onChanged: onChange,
          activeThumbImage: AssetImage('images/moon.png'),
          inactiveThumbImage: AssetImage('images/sun.png'),
        ),
      );
}
