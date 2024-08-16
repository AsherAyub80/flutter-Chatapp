import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider with ChangeNotifier {
  final _storage = GetStorage();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  void _loadThemeMode() {
    _isDarkMode = _storage.read<bool>('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storage.write('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
