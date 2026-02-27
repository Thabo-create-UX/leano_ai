import 'package:flutter/material.dart';
import 'package:leano_app/screens/setting_screen.dart';
import 'screens/chat_screen.dart';


final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(LeanoApp());
}

class LeanoApp extends StatelessWidget {
  const LeanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Leano',
          themeMode: mode, // <-- This listens to themeNotifier
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          initialRoute: '/chat',
          routes: {
            '/chat': (ctx) => ChatScreen(),
            '/settings': (ctx) => SettingsScreen(),
          },
        );
      },
    );
  }
}