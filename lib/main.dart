import 'package:flutter/material.dart';
import 'package:news_app/pages/home_page.dart';
import 'package:news_app/utils/themes/theme_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeApps.lightTheme,
      darkTheme: ThemeApps.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePageView(),
    );
  }
}

