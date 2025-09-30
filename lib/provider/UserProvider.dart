import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class UserProvider with ChangeNotifier {
  String? _authToken;
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  String? get authToken => _authToken;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;

  final Dio _dio = Dio();
  // TODO: Remplacez l'URL par l'adresse IP de votre machine, e.g., 'http://192.168.1.10:8000/api'
  final String _apiUrl = 'http://127.0.0.1:8000/api';

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserProvider() {
    loadUserFromStorage();
  }

  /// Définit le token d'authentification et les données utilisateur en mémoire.
  /// Cette méthode est utilisée après une connexion réussie pour mettre à jour l'état de l'application.
  void setTokenAndUser(String token, Map<String, dynamic> userData) {
    _authToken = token;
    _user = userData;
    notifyListeners();
  }

  /// Sauvegarde le token et les données utilisateur dans le stockage persistant (SharedPreferences).
  /// C'est essentiel pour maintenir la session de l'utilisateur entre les redémarrages de l'application.
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

  /// Charge le token et les données utilisateur depuis le stockage persistant au démarrage de l'application.
  /// Cela permet de réauthentifier l'utilisateur automatiquement.
  Future<void> loadUserFromStorage() async {
    _isLoading = true;
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

  /// Déconnecte l'utilisateur en supprimant le token et les données du stockage et de la mémoire.
  /// L'état de l'application est mis à jour pour refléter l'état déconnecté.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('user');
    _authToken = null;
    _user = null;
    notifyListeners();
  }

  /// Envoie une requête à l'API pour initier le processus de réinitialisation du mot de passe.
  /// Un lien ou un OTP est envoyé à l'adresse e-mail fournie.
  Future<bool> sendResetPasswordLink(String emailOrPhone) async {
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _dio.post(
        '$_apiUrl/forgot-password',
        data: {'email': emailOrPhone},
      );
      if (response.statusCode == 200) {
        _errorMessage = null;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.data is Map) {
          _errorMessage = e.response!.data['message'] ?? 'Erreur inconnue.';
        } else if (e.response!.data is String) {
          _errorMessage = e.response!.data;
        } else {
          _errorMessage = 'Une erreur de format de réponse est survenue.';
        }
      } else {
        _errorMessage = 'Erreur de connexion au serveur.';
      }
      notifyListeners();
    }
    return false;
  }

  /// Vérifie le code OTP et, si valide, renvoie un jeton de réinitialisation.
  /// Ce jeton est nécessaire pour procéder à la réinitialisation du mot de passe.
  Future<String?> verifyOtpAndGetToken({
    required String email,
    required String otp,
  }) async {
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _dio.post(
        '$_apiUrl/verify-otp',
        data: {'email': email, 'token': otp},
      );
      if (response.statusCode == 200 && response.data['reset_token'] != null) {
        _errorMessage = null;
        notifyListeners();
        return response.data['reset_token'];
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData != null &&
          responseData is Map &&
          responseData.containsKey('error')) {
        _errorMessage = responseData['error'] is String
            ? responseData['error']
            : (responseData['error'] as Map).values.first?.first ??
                  'Erreur de validation du code.';
      } else {
        _errorMessage = e.message ?? 'Erreur de validation du code.';
      }
      notifyListeners();
    }
    return null;
  }

  /// Réinitialise le mot de passe de l'utilisateur en utilisant le jeton de réinitialisation.
  /// C'est la dernière étape du processus de récupération du mot de passe.
  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _dio.post(
        '$_apiUrl/password/reset',
        data: {
          'email': email,
          'token': token,
          'password': newPassword,
          'password_confirmation': newPassword,
        },
      );
      if (response.statusCode == 200) {
        _errorMessage = null;
        notifyListeners();
        return true;
      }
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData != null && responseData is Map) {
        if (responseData.containsKey('message')) {
          _errorMessage = responseData['message'];
        } else if (responseData.containsKey('errors') &&
            responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;
          if (errors.isNotEmpty) {
            _errorMessage = (errors.values.first as List).first;
          } else {
            _errorMessage = 'Erreur de réinitialisation du mot de passe.';
          }
        } else {
          _errorMessage = 'Erreur inattendue.';
        }
      } else {
        _errorMessage = 'Erreur de connexion au serveur.';
      }
      notifyListeners();
    }
    return false;
  }

  /// Récupère les messages d'une conversation spécifique depuis l'API, avec prise en charge de la pagination.
  /// Les messages sont récupérés par lot pour ne pas surcharger le serveur.
  Future<List<Map<String, dynamic>>?> getConversationMessages(
    int conversationId,
    int page,
  ) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/messages/$conversationId?page=$page',
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ??
          'Échec de la récupération des messages.';
      notifyListeners();
    }
    return null;
  }

  /// Envoie un message à un utilisateur via l'API.
  /// Ce message est ajouté à la conversation et enregistré dans la base de données.
  Future<bool> sendMessage(int receiverId, String content) async {
    try {
      final response = await _dio.post(
        '$_apiUrl/messages/send',
        data: {'receiver_id': receiverId, 'content': content},
        options: Options(headers: {'Authorization': 'Bearer $_authToken'}),
      );

      if (response.statusCode == 201) {
        return true;
      }
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ?? 'Échec de l\'envoi du message.';
      notifyListeners();
    }
    return false;
  }
}




// ------- Sans fonction des sms --------


// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:dio/dio.dart';

// class UserProvider with ChangeNotifier {
//   String? _authToken;
//   Map<String, dynamic>? _user;
//   bool _isLoading = true;

//   String? get authToken => _authToken;
//   Map<String, dynamic>? get user => _user;
//   bool get isLoading => _isLoading;

//   final Dio _dio = Dio();
//   // TODO: Remplacez l'URL par l'adresse IP de votre machine, e.g., 'http://192.168.1.10:8000/api'
//   final String _apiUrl = 'http://127.0.0.1:8000/api';

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   // Constructeur qui charge les données de l'utilisateur au démarrage
//   UserProvider() {
//     loadUserFromStorage();
//   }

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

//   // Méthode pour envoyer le code de réinitialisation
//   Future<bool> sendResetPasswordLink(String emailOrPhone) async {
//     _errorMessage = null;
//     notifyListeners();
//     try {
//       final response = await _dio.post(
//         '$_apiUrl/forgot-password',
//         data: {'email': emailOrPhone},
//       );
//       if (response.statusCode == 200) {
//         _errorMessage = null;
//         notifyListeners();
//         return true;
//       }
//     } on DioException catch (e) {
//       // 🐛 Correction ici : vérification du type de la réponse
//       if (e.response != null) {
//         if (e.response!.data is Map) {
//           _errorMessage = e.response!.data['message'] ?? 'Erreur inconnue.';
//         } else if (e.response!.data is String) {
//           _errorMessage = e.response!.data;
//         } else {
//           _errorMessage = 'Une erreur de format de réponse est survenue.';
//         }
//       } else {
//         _errorMessage = 'Erreur de connexion au serveur.';
//       }
//       notifyListeners();
//     }
//     return false;
//   }

//   // --- NOUVELLE MÉTHODE DEMANDÉE : vérification du code OTP ---
//   Future<String?> verifyOtpAndGetToken({
//     required String email,
//     required String otp,
//   }) async {
//     _errorMessage = null;
//     notifyListeners();
//     try {
//       final response = await _dio.post(
//         '$_apiUrl/verify-otp',
//         data: {'email': email, 'token': otp},
//       );
//       if (response.statusCode == 200 && response.data['reset_token'] != null) {
//         _errorMessage = null;
//         notifyListeners();
//         return response.data['reset_token'];
//       }
//     } on DioException catch (e) {
//       final responseData = e.response?.data;
//       if (responseData != null &&
//           responseData is Map &&
//           responseData.containsKey('error')) {
//         _errorMessage = responseData['error'] is String
//             ? responseData['error']
//             : (responseData['error'] as Map).values.first?.first ??
//                   'Erreur de validation du code.';
//       } else {
//         _errorMessage = e.message ?? 'Erreur de validation du code.';
//       }
//       notifyListeners();
//     }
//     return null;
//   }

//   // --- MÉTHODE MISE À JOUR POUR LA RÉINITIALISATION FINALE ---
//   Future<bool> resetPassword({
//     required String email,
//     required String token,
//     required String newPassword,
//   }) async {
//     _errorMessage = null;
//     notifyListeners();
//     try {
//       final response = await _dio.post(
//         '$_apiUrl/password/reset',
//         data: {
//           'email': email,
//           'token': token,
//           'password': newPassword,
//           'password_confirmation': newPassword,
//         },
//       );
//       if (response.statusCode == 200) {
//         _errorMessage = null;
//         notifyListeners();
//         return true;
//       }
//     } on DioException catch (e) {
//       final responseData = e.response?.data;
//       if (responseData != null && responseData is Map) {
//         if (responseData.containsKey('message')) {
//           _errorMessage = responseData['message'];
//         } else if (responseData.containsKey('errors') &&
//             responseData['errors'] is Map) {
//           final errors = responseData['errors'] as Map;
//           if (errors.isNotEmpty) {
//             _errorMessage = (errors.values.first as List).first;
//           } else {
//             _errorMessage = 'Erreur de réinitialisation du mot de passe.';
//           }
//         } else {
//           _errorMessage = 'Erreur inattendue.';
//         }
//       } else {
//         _errorMessage = e.message ?? 'Erreur de connexion au serveur.';
//       }
//       notifyListeners();
//     }
//     return false;
//   }
// }





// --------- Mais sans infos du user --------


// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:dio/dio.dart';

// class UserProvider with ChangeNotifier {
//   String? _authToken;
//   Map<String, dynamic>? _user;
//   bool _isLoading = true;

//   String? get authToken => _authToken;
//   Map<String, dynamic>? get user => _user;
//   bool get isLoading => _isLoading;

//   final Dio _dio = Dio();
//   // TODO: Remplacez l'URL par l'adresse IP de votre machine, e.g., 'http://192.168.1.10:8000/api'
//   final String _apiUrl = 'http://127.0.0.1:8000/api';

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   // Constructeur qui charge les données de l'utilisateur au démarrage
//   UserProvider() {
//     loadUserFromStorage();
//   }

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

//   // Méthode pour envoyer le code de réinitialisation
//   Future<bool> sendResetPasswordLink(String emailOrPhone) async {
//     _errorMessage = null;
//     notifyListeners();
//     try {
//       final response = await _dio.post(
//         '$_apiUrl/forgot-password',
//         data: {'email': emailOrPhone},
//       );
//       if (response.statusCode == 200) {
//         _errorMessage = null;
//         notifyListeners();
//         return true;
//       }
//     } on DioException catch (e) {
//       // 🐛 Correction ici : vérification du type de la réponse
//       if (e.response != null) {
//         if (e.response!.data is Map) {
//           _errorMessage = e.response!.data['message'] ?? 'Erreur inconnue.';
//         } else if (e.response!.data is String) {
//           _errorMessage = e.response!.data;
//         } else {
//           _errorMessage = 'Une erreur de format de réponse est survenue.';
//         }
//       } else {
//         _errorMessage = 'Erreur de connexion au serveur.';
//       }
//       notifyListeners();
//     }
//     return false;
//   }

//   // --- NOUVELLE MÉTHODE DEMANDÉE : vérification du code OTP ---
//   Future<String?> verifyOtpAndGetToken({
//     required String email,
//     required String otp,
//   }) async {
//     _errorMessage = null;
//     notifyListeners();
//     try {
//       final response = await _dio.post(
//         '$_apiUrl/verify-otp',
//         data: {'email': email, 'token': otp},
//       );
//       if (response.statusCode == 200 && response.data['reset_token'] != null) {
//         _errorMessage = null;
//         notifyListeners();
//         // ✅ CORRECTION ICI : la clé de la réponse de l'API est 'reset_token', pas 'token'
//         return response.data['reset_token'];
//       }
//     } on DioException catch (e) {
//       final responseData = e.response?.data;
//       if (responseData != null &&
//           responseData is Map &&
//           responseData.containsKey('error')) {
//         _errorMessage = responseData['error'] is String
//             ? responseData['error']
//             : (responseData['error'] as Map).values.first?.first ??
//                   'Erreur de validation du code.';
//       } else {
//         _errorMessage = e.message ?? 'Erreur de validation du code.';
//       }
//       notifyListeners();
//     }
//     return null;
//   }

//   // --- MÉTHODE MISE À JOUR POUR LA RÉINITIALISATION FINALE ---
//   Future<bool> resetPassword({
//     required String email,
//     required String token,
//     required String newPassword,
//   }) async {
//     _errorMessage = null;
//     notifyListeners();
//     try {
//       final response = await _dio.post(
//         '$_apiUrl/password/reset',
//         data: {
//           'email': email,
//           'token': token,
//           'password': newPassword,
//           'password_confirmation': newPassword,
//         },
//       );
//       if (response.statusCode == 200) {
//         _errorMessage = null;
//         notifyListeners();
//         return true;
//       }
//     } on DioException catch (e) {
//       _errorMessage = e.response?.data['message'] ?? 'Erreur de validation.';
//       notifyListeners();
//       print('message ehonnne mon ga');
//     }
//     return false;
//   }
// }

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

//   // Constructeur qui charge les données de l'utilisateur au démarrage
//   UserProvider() {
//     loadUserFromStorage();
//   }

//   // Méthode pour définir le token et les données utilisateur en mémoire
//   void setTokenAndUser(String token, Map<String, dynamic> userData) {
//     _authToken = token;
//     _user = userData;
//     notifyListeners();
//   }

//   // Méthode pour sauvegarder le token et les données de l'utilisateur sur le stockage local
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

//   // Méthode pour charger les données utilisateur depuis le stockage local
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

//   // Méthode pour déconnecter l'utilisateur
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('authToken');
//     await prefs.remove('user');
//     _authToken = null;
//     _user = null;
//     notifyListeners();
//   }

  
// }

