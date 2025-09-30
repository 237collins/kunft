import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/UserProvider.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000';

class ReservationProvider with ChangeNotifier {
  List<dynamic> _reservations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get reservations => _reservations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> confirmReservation(
    BuildContext context, {
    required Map<String, dynamic> logementData,
    required DateTime dateDebut,
    required DateTime dateFin,
    required String paymentMode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authToken = userProvider.authToken;

    if (authToken == null) {
      _errorMessage =
          'Token d\'authentification introuvable. Veuillez vous reconnecter.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // ✅ Vérification des données entrantes pour éviter les erreurs de type
    final dynamic rawId = logementData['id'];
    final int logementId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;
    final String? userId = userProvider.user?['id']?.toString();

    if (userId == null || logementId == 0) {
      _errorMessage = 'Détails de réservation incomplets.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final dio = Dio();
      const apiUrl = '$API_BASE_URL/api/reservations';

      final data = {
        'logement_id': logementId,
        'user_id': int.parse(userId),
        'date_debut': dateDebut.toIso8601String(),
        'date_fin': dateFin.toIso8601String(),
        'payment_mode': paymentMode,
      };

      final response = await dio.post(
        apiUrl,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Réservation confirmée avec succès !');
        _errorMessage = null;
        // ✅ C'est la ligne clé pour la réactivité automatique
        await fetchUserReservations(authToken: authToken);
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _errorMessage = 'Erreur inattendue: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserReservations({required String authToken}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dio = Dio();
      const apiUrl = '$API_BASE_URL/api/user/reservations';

      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        _reservations = response.data['reservations'];
        _errorMessage = null;
      } else {
        _errorMessage =
            'Échec de la récupération des réservations: ${response.statusCode}';
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _errorMessage = 'Erreur inattendue: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Nouvelle méthode utilitaire pour gérer les erreurs Dio
  void _handleDioError(DioException e) {
    String? message;
    if (e.response != null) {
      final errorData = e.response!.data;
      if (errorData is Map && errorData.containsKey('message')) {
        message = errorData['message'];
      } else {
        message = 'Erreur du serveur (code: ${e.response!.statusCode}).';
      }
    } else {
      message = 'Erreur de connexion: ${e.message}';
    }
    _errorMessage = message;
    print('Erreur: $_errorMessage');
  }
}



// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:provider/provider.dart';
// import 'package:kunft/provider/UserProvider.dart';

// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class ReservationProvider with ChangeNotifier {
//   List<dynamic> _reservations = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<dynamic> get reservations => _reservations;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void setErrorMessage(String? message) {
//     _errorMessage = message;
//     notifyListeners();
//   }

//   Future<void> confirmReservation(
//     BuildContext context, {
//     required Map<String, dynamic> logementData,
//     required DateTime dateDebut,
//     required DateTime dateFin,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final authToken = userProvider.authToken;

//     if (authToken == null) {
//       _isLoading = false;
//       _errorMessage =
//           'Token d\'authentification introuvable. Veuillez vous reconnecter.';
//       notifyListeners();
//       return;
//     }

//     final dynamic rawId = logementData['id'];
//     final int logementId = rawId is String ? int.parse(rawId) : rawId as int;
//     final String? userId = userProvider.user?['id']?.toString();

//     if (userId == null || dateDebut == null || dateFin == null) {
//       _isLoading = false;
//       _errorMessage = 'Détails de réservation incomplets.';
//       notifyListeners();
//       return;
//     }

//     try {
//       final dio = Dio();
//       const apiUrl = '$API_BASE_URL/api/reservations';

//       final data = {
//         'logement_id': logementId,
//         'user_id': int.parse(userId),
//         'date_debut': dateDebut.toIso8601String(),
//         'date_fin': dateFin.toIso8601String(),
//       };

//       final response = await dio.post(
//         apiUrl,
//         data: data,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json; charset=UTF-8',
//             'Authorization': 'Bearer $authToken',
//           },
//         ),
//       );

//       if (response.statusCode == 201) {
//         print('Réservation confirmée avec succès !');
//         _errorMessage = null;
//         await fetchUserReservations(authToken: authToken);
//       }
//     } on DioException catch (e) {
//       String? message;
//       if (e.response != null) {
//         final errorData = e.response!.data;
//         if (errorData is Map && errorData.containsKey('message')) {
//           message = errorData['message'];
//         } else {
//           message = 'Erreur du serveur (code: ${e.response!.statusCode}).';
//         }
//       } else {
//         message = 'Erreur de connexion: ${e.message}';
//       }
//       _errorMessage = 'Erreur lors de la confirmation: $message';
//       print(_errorMessage);
//     } catch (e) {
//       _errorMessage = 'Erreur inattendue: ${e.toString()}';
//       print(_errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> fetchUserReservations({String? authToken}) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     if (authToken == null) {
//       _errorMessage =
//           'Token d\'authentification introuvable. Veuillez vous reconnecter.';
//       _isLoading = false;
//       notifyListeners();
//       return;
//     }

//     try {
//       final dio = Dio();
//       // ✅ Mise à jour de l'URL pour inclure les relations 'logement' et 'images'
//       const apiUrl = '$API_BASE_URL/api/user/reservations';

//       final response = await dio.get(
//         apiUrl,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $authToken',
//             'Accept': 'application/json',
//           },
//         ),
//       );

//       // Essaie pour voir l'erreur
//       if (response.statusCode == 200) {
//         print(
//           'Données de l\'API : ${response.data}',
//         ); // Affichez les données ici
//         _reservations = response.data['reservations'];
//         _errorMessage = null;
//       } else {
//         _errorMessage =
//             'Échec de la récupération des réservations: ${response.statusCode}';
//       }
//     } on DioException catch (e) {
//       String? message;
//       if (e.response != null) {
//         final errorData = e.response!.data;
//         if (errorData is Map && errorData.containsKey('message')) {
//           message = errorData['message'];
//         } else {
//           message = 'Erreur du serveur (code: ${e.response!.statusCode}).';
//         }
//       } else {
//         message = 'Erreur de connexion: ${e.message}';
//       }
//       _errorMessage =
//           'Erreur lors de la récupération des réservations: $message';
//     } catch (e) {
//       _errorMessage = 'Erreur inattendue: ${e.toString()}';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }


//----------- Ancien 2


// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:provider/provider.dart';
// import 'package:kunft/provider/UserProvider.dart'; // Importez le UserProvider

// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class ReservationProvider with ChangeNotifier {
//   int? _logementId;
//   String? _userId;
//   DateTime? _dateDebut;
//   DateTime? _dateFin;

//   List<dynamic> _reservations = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<dynamic> get reservations => _reservations;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void setReservationDetails({
//     required int logementId,
//     required String userId,
//     required DateTime dateDebut,
//     required DateTime dateFin,
//   }) {
//     _logementId = logementId;
//     _userId = userId;
//     _dateDebut = dateDebut;
//     _dateFin = dateFin;
//     notifyListeners();
//   }

//   // ✅ Méthode mise à jour pour accepter le BuildContext au lieu du token
//   Future<void> confirmReservation(BuildContext context) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     // ✅ Récupère le token directement depuis le UserProvider
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final authToken = userProvider.authToken;

//     if (authToken == null) {
//       _isLoading = false;
//       _errorMessage =
//           'Token d\'authentification introuvable. Veuillez vous reconnecter.';
//       notifyListeners();
//       return;
//     }

//     try {
//       if (_logementId == null ||
//           _userId == null ||
//           _dateDebut == null ||
//           _dateFin == null) {
//         throw Exception('Détails de réservation incomplets.');
//       }

//       final dio = Dio();
//       const apiUrl = '$API_BASE_URL/api/reservations';

//       final data = {
//         'logement_id': _logementId,
//         'user_id': int.parse(_userId!),
//         'date_debut': _dateDebut!.toIso8601String(),
//         'date_fin': _dateFin!.toIso8601String(),
//       };

//       final response = await dio.post(
//         apiUrl,
//         data: data,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json; charset=UTF-8',
//             'Authorization': 'Bearer $authToken',
//           },
//         ),
//       );

//       if (response.statusCode == 201) {
//         print('Réservation confirmée avec succès !');
//         _logementId = null;
//         _userId = null;
//         _dateDebut = null;
//         _dateFin = null;

//         // ✅ L'appel est maintenant fait avec le token récupéré localement
//         fetchUserReservations(authToken: authToken);
//       }
//     } on DioException catch (e) {
//       String? message;
//       if (e.response != null) {
//         final errorData = e.response!.data;
//         if (errorData is Map && errorData.containsKey('message')) {
//           message = errorData['message'];
//         } else {
//           message = 'Erreur du serveur (code: ${e.response!.statusCode}).';
//         }
//       } else {
//         message = 'Erreur de connexion: ${e.message}';
//       }
//       _errorMessage = 'Erreur lors de la confirmation: $message';
//       print(_errorMessage);
//     } catch (e) {
//       _errorMessage = 'Erreur inattendue: ${e.toString()}';
//       print(_errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Cette méthode est correcte et ne nécessite pas de changement
//   Future<void> fetchUserReservations({String? authToken}) async {
//     // ...
//   }
// }
