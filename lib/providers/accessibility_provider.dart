// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AccessibilityProvider with ChangeNotifier {
  final FlutterTts _flutterTts = FlutterTts();
  bool _ttsEnabled = false;
  bool get ttsEnabled => _ttsEnabled;
  bool _highContrastMode = false;

  bool get highContrastMode => _highContrastMode;

  ThemeMode get currentThemeMode =>
      _highContrastMode ? ThemeMode.dark : ThemeMode.light;

  AccessibilityProvider() {
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  void toggleTts() {
    _ttsEnabled = !_ttsEnabled;
    notifyListeners();
  }

  Future<void> speak(String text) async {
    if (_ttsEnabled) {
      await _flutterTts.speak(text);
    }
  }

  void toggleHighContrastMode() {
    _highContrastMode = !_highContrastMode;
    notifyListeners();
  }
}
