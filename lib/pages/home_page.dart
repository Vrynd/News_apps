import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  // Warna dan Teks
  ColorScheme get color => Theme.of(context).colorScheme;
  TextTheme get textStyle => Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

