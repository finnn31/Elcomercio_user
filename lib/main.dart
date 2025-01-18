import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = prefs.getBool('darkMode') ?? false ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _updateTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
    prefs.setBool('darkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elcomercio',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/login',
      routes: {
        '/login': (context) => UserLoginScreen(),
        '/home': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(onToggleTheme: _updateTheme), // Callback ke SettingsScreen
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfileScreen(), // Tambahkan route dengan argumen dinamis
      },
    );
  }
}
