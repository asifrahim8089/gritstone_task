// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:grits_task/providers/accessibility_provider.dart';
import 'package:grits_task/providers/data_provider.dart';
import 'package:grits_task/views/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: Consumer<AccessibilityProvider>(
          builder: (context, accessibilityProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Griststone',
          theme: ThemeData(
            fontFamily: "Roboto",
          ),
          darkTheme: ThemeData.dark(),
          themeMode: accessibilityProvider.currentThemeMode,
          home: const HomePage(),
        );
      }),
    );
  }
}
