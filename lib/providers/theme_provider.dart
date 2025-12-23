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
        return const Color(0xFF2986cc);
      case 'green':
        return Colors.green;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      case 'yellow':
        return Colors.yellow;
      default:
        return const Color(0xFF2986cc);
    }
  }

  Color get textColor {
    switch (_selectedTheme) {
      case 'blue':
      case 'green':
      case 'purple':
        return Colors.white;
      case 'pink':
      case 'yellow':
        return Colors.black;
      default:
        return Colors.white;
    }
  }

  Color get containerColor {
    switch (_selectedTheme) {
      case 'blue':
        return const Color(0xFFF8F9FA);
      case 'green':
        return Colors.green.shade50;
      case 'pink':
        return Colors.pink.shade50;
      case 'purple':
        return Colors.purple.shade50;
      case 'yellow':
        return Colors.yellow.shade50;
      default:
        return const Color(0xFFF8F9FA);
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
