import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  String? _authToken;
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  String? get authToken => _authToken;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;

  // Constructeur qui charge les données de l'utilisateur au démarrage
  UserProvider() {
    loadUserFromStorage();
  }

  // Méthode pour définir le token et les données utilisateur en mémoire
  void setTokenAndUser(String token, Map<String, dynamic> userData) {
    _authToken = token;
    _user = userData;
    notifyListeners();
  }

  // Méthode pour sauvegarder le token et les données de l'utilisateur sur le stockage local
  Future<void> saveUserAndToken(
    String token,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = token;
    _user = userData;
    await prefs.setString('authToken', token);
    await prefs.setString('user', json.encode(userData));
    notifyListeners();
  }

  // Méthode pour charger les données utilisateur depuis le stockage local
  Future<void> loadUserFromStorage() async {
    _isLoading = true;
    // notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final userDataString = prefs.getString('user');

    if (token != null && userDataString != null) {
      _authToken = token;
      try {
        _user = json.decode(userDataString);
      } catch (e) {
        debugPrint('Erreur de décodage des données utilisateur: $e');
        _user = null;
        _authToken = null;
        await prefs.remove('user');
        await prefs.remove('authToken');
      }
    } else {
      _authToken = null;
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Méthode pour déconnecter l'utilisateur
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('user');
    _authToken = null;
    _user = null;
    notifyListeners();
  }
}


// ------------- Okay Mais Booking


// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class UserProvider with ChangeNotifier {
//   String? _authToken;
//   Map<String, dynamic>? _user;
//   bool _isLoading = true;

//   String? get authToken => _authToken;
//   Map<String, dynamic>? get user => _user;
//   bool get isLoading => _isLoading;

//   // Constructor
//   UserProvider() {
//     loadUserFromStorage();
//   }

//   // ✅ New method to set token and user in memory without saving to storage
//   void setTokenAndUser(String token, Map<String, dynamic> userData) {
//     _authToken = token;
//     _user = userData;
//     notifyListeners();
//   }

//   Future<void> saveUserAndToken(
//     String token,
//     Map<String, dynamic> userData,
//   ) async {
//     final prefs = await SharedPreferences.getInstance();
//     _authToken = token;
//     _user = userData;
//     await prefs.setString('authToken', token);
//     await prefs.setString('user', json.encode(userData));
//     notifyListeners();
//   }

//   Future<void> loadUserFromStorage() async {
//     _isLoading = true;
//     // notifyListeners();

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('authToken');
//     final userDataString = prefs.getString('user');

//     if (token != null && userDataString != null) {
//       _authToken = token;
//       try {
//         _user = json.decode(userDataString);
//       } catch (e) {
//         debugPrint('Erreur de décodage des données utilisateur: $e');
//         _user = null;
//         _authToken = null;
//         await prefs.remove('user');
//         await prefs.remove('authToken');
//       }
//     } else {
//       _authToken = null;
//       _user = null;
//     }
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('authToken');
//     await prefs.remove('user');
//     _authToken = null;
//     _user = null;
//     notifyListeners();
//   }
// }

