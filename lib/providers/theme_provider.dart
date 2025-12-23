import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class ThemeProvider extends ChangeNotifier {
  String _selectedTheme = 'blue'; // blue, green, pink, purple, yellow
  bool _isUrduLanguage = false;

  // Getters
  String get selectedTheme => _selectedTheme;
  bool get isUrduLanguage => _isUrduLanguage;

  // Theme color getters
  Color get primaryColor {
    switch (_selectedTheme) {
      case 'blue':
        return const Color(0xFF2196F3); // Material Blue
      case 'green':
        return const Color(0xFF4CAF50); // Material Green
      case 'pink':
        return const Color(0xFFE91E63); // Material Pink
      case 'purple':
        return const Color(0xFF9C27B0); // Material Purple
      case 'yellow':
        return const Color(0xFFFFC107); // Material Yellow
      default:
        return const Color(0xFF2196F3); // Material Blue
    }
  }

  Color get textColor {
    switch (_selectedTheme) {
      case 'blue':
      case 'green':
      case 'purple':
        return Colors.black;
      case 'pink':
      case 'yellow':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  Color get containerColor {
    switch (_selectedTheme) {
      case 'blue':
        return const Color(0xFFF3F8FF); // Light Blue
      case 'green':
        return const Color(0xFFF1F8E9); // Light Green
      case 'pink':
        return const Color(0xFFFCE4EC); // Light Pink
      case 'purple':
        return const Color(0xFFF3E5F5); // Light Purple
      case 'yellow':
        return const Color(0xFFFFF9C4); // Light Yellow
      default:
        return const Color(0xFFF3F8FF); // Light Blue
    }
  }

  // Setters
  void setTheme(String theme) {
    _selectedTheme = theme;
    web.window.localStorage['selectedTheme'] = theme;
    notifyListeners();
  }

  void setLanguage(bool isUrdu) {
    _isUrduLanguage = isUrdu;
    web.window.localStorage['isUrduLanguage'] = isUrdu.toString();
    notifyListeners();
  }

  void loadPreferences() {
    _selectedTheme = web.window.localStorage['selectedTheme'] ?? 'blue';
    _isUrduLanguage = web.window.localStorage['isUrduLanguage'] == 'true';
    notifyListeners();
  }

  void savePreferences() {
    // Save preferences to localStorage
    // Note: Individual theme and language are already saved when set
    notifyListeners();
  }
}
