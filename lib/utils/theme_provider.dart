import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _isDark = false;
  String _lang = 'ar';
  double _fontScale = 1.0;

  bool get isDark => _isDark;
  String get lang => _lang;
  double get fontScale => _fontScale;

  ThemeData get theme => _isDark
      ? ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F2A3A), // أزرق غامق
          primaryColor: const Color(0xFF1B5E3A),           // أخضر داكن
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF1B5E3A),
            secondary: Color(0xFF2E7D4F),
            surface: Color(0xFF15384B),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1B5E3A),
            foregroundColor: Colors.white,
          ),
          fontFamily: 'SF Pro Display',
        )
      : ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFF4FC3F7),           // أزرق فاتح
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF4FC3F7),
            secondary: Color(0xFF81D4FA),
            surface: Color(0xFFE3F2FD),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4FC3F7),
            foregroundColor: Colors.white,
          ),
          fontFamily: 'SF Pro Display',
        );

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    _isDark = p.getBool('dark') ?? false;
    _lang = p.getString('lang') ?? 'ar';
    _fontScale = p.getDouble('font') ?? 1.0;
    notifyListeners();
  }

  Future<void> setDark(bool v) async {
    _isDark = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark', v);
    notifyListeners();
  }

  Future<void> setLang(String v) async {
    _lang = v;
    final p = await SharedPreferences.getInstance();
    await p.setString('lang', v);
    notifyListeners();
  }

  Future<void> setFont(double v) async {
    _fontScale = v;
    final p = await SharedPreferences.getInstance();
    await p.setDouble('font', v);
    notifyListeners();
  }
}