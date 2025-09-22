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
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authToken = userProvider.authToken;

    if (authToken == null) {
      _isLoading = false;
      _errorMessage =
          'Token d\'authentification introuvable. Veuillez vous reconnecter.';
      notifyListeners();
      return;
    }

    final dynamic rawId = logementData['id'];
    final int logementId = rawId is String ? int.parse(rawId) : rawId as int;
    final String? userId = userProvider.user?['id']?.toString();

    if (userId == null || dateDebut == null || dateFin == null) {
      _isLoading = false;
      _errorMessage = 'Détails de réservation incomplets.';
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
        await fetchUserReservations(authToken: authToken);
      }
    } on DioException catch (e) {
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
      _errorMessage = 'Erreur lors de la confirmation: $message';
      print(_errorMessage);
    } catch (e) {
      _errorMessage = 'Erreur inattendue: ${e.toString()}';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserReservations({String? authToken}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (authToken == null) {
      _errorMessage =
          'Token d\'authentification introuvable. Veuillez vous reconnecter.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final dio = Dio();
      // ✅ Mise à jour de l'URL pour inclure les relations 'logement' et 'images'
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

      // if (response.statusCode == 200) {
      //   // ✅ Assurez-vous que la clé 'reservations' existe
      //   _reservations = response.data['reservations'];
      //   _errorMessage = null;
      // }

      // Essaie pour voir l'erreur
      if (response.statusCode == 200) {
        print(
          'Données de l\'API : ${response.data}',
        ); // Affichez les données ici
        _reservations = response.data['reservations'];
        _errorMessage = null;
      } else {
        _errorMessage =
            'Échec de la récupération des réservations: ${response.statusCode}';
      }
    } on DioException catch (e) {
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
      _errorMessage =
          'Erreur lors de la récupération des réservations: $message';
    } catch (e) {
      _errorMessage = 'Erreur inattendue: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


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




// --------------- Ancien code simple


// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart'; // Importation du package Dio

// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class ReservationProvider with ChangeNotifier {
//   int? _logementId;
//   String? _userId;
//   DateTime? _dateDebut;
//   DateTime? _dateFin;

//   bool _isLoading = false;
//   String? _errorMessage;

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

//   Future<void> confirmReservation({required String authToken}) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       if (_logementId == null ||
//           _userId == null ||
//           _dateDebut == null ||
//           _dateFin == null) {
//         throw Exception('Détails de réservation incomplets.');
//       }

//       final dio = Dio();

//       const apiUrl = '$API_BASE_URL/api/reservations';

//       // ✅ MODIFICATION : Conversion de _userId en int
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
//       }
//     } on DioException catch (e) {
//       String? message;
//       // ✅ AMÉLIORATION : Gérer les différents types d'erreurs de Dio
//       if (e.response != null) {
//         final errorData = e.response!.data;
//         if (errorData is Map && errorData.containsKey('message')) {
//           message = errorData['message'];
//         } else {
//           message = 'Erreur du serveur (code: ${e.response!.statusCode}).';
//         }
//       } else {
//         message = 'Erreur de connexion : ${e.message}';
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
// }






// import 'package:flutter/material.dart';

// class ReservationProvider with ChangeNotifier {
//   int? _logementId;
//   int? _userId;
//   DateTime? _dateDebut;
//   DateTime? _dateFin;

//   bool _isLoading = false;
//   String? _errorMessage;

//   // Accesseurs (getters) pour les données de l'état
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void setReservationDetails({
//     required int logementId,
//     required int userId,
//     required DateTime dateDebut,
//     required DateTime dateFin,
//   }) {
//     // ✅ MODIFIÉ : Assurez-vous que logementId est un int.
//     // L'erreur _TypeError se produit si logementId est une String ici.
//     _logementId = logementId;
//     _userId = userId;
//     _dateDebut = dateDebut;
//     _dateFin = dateFin;
//   }

//   Future<void> confirmReservation() async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       // ✅ MODIFIÉ : Conversion de l'ID si elle est une chaîne de caractères.
//       // Cette ligne est un exemple de la conversion à effectuer si votre source de données renvoie l'ID en tant que String.
//       // Vous devez vous assurer que le type de logementId est bien un int dans la fonction setReservationDetails.
//       // Par exemple : int.parse(_logementId.toString()) si vous n'êtes pas sûr du type.

//       // Simulons une confirmation de réservation asynchrone (par exemple, un appel API)
//       await Future.delayed(const Duration(seconds: 2));

//       // Exemple de logique de confirmation (à remplacer par votre véritable logique)
//       if (_logementId != null && _userId != null) {
//         print(
//           'Réservation confirmée pour le logement ID: $_logementId par l\'utilisateur ID: $_userId',
//         );
//         // Nettoyer l'état après la confirmation
//         _logementId = null;
//         _userId = null;
//         _dateDebut = null;
//         _dateFin = null;
//       } else {
//         throw Exception('Détails de réservation incomplets.');
//       }
//     } catch (e) {
//       _errorMessage = 'Erreur lors de la confirmation: ${e.toString()}';
//       print(_errorMessage);
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }







//  ------ Ancien connexion avec http


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class ReservationProvider with ChangeNotifier {
//   // État du provider
//   bool _isLoading = false;
//   String? _errorMessage;
//   Map<String, dynamic>? _reservationData;

//   // Getters pour accéder à l'état
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   Map<String, dynamic>? get reservationData => _reservationData;

//   /// Confirme une nouvelle réservation en envoyant une requête POST à l'API.
//   /// @param reservationDetails Les détails de la réservation sous forme de Map.
//   Future<void> confirmReservation({
//     required int logementId,
//     required int userId,
//     required DateTime dateDebut,
//     required DateTime dateFin,
//     // required int nombreAdultes,
//     // required int nombreEnfants,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _reservationData = null;
//     notifyListeners();

//     try {
//       final url = Uri.parse(
//         '$API_BASE_URL/api/reservations',
//       ); // À remplacer par votre URL de base
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'logement_id': logementId,
//           'user_id': userId,
//           'date_debut': dateDebut.toIso8601String(),
//           'date_fin': dateFin.toIso8601String(),
//           // 'nombre_adultes': nombreAdultes,  // Non utile pour le moment
//           // 'nombre_enfants': nombreEnfants,  // Non utile pour le moment
//         }),
//       );

//       if (response.statusCode == 201) {
//         // Succès : La réservation a été créée
//         _reservationData = json.decode(response.body)['reservation'];
//         _errorMessage = null;
//         print('Réservation confirmée avec succès !');
//       } else {
//         // Échec : Gérer les erreurs de l'API
//         final responseBody = json.decode(response.body);
//         _errorMessage =
//             responseBody['message'] ??
//             'Une erreur est survenue lors de la confirmation.';
//         print('Erreur lors de la confirmation: $_errorMessage');
//       }
//     } catch (e) {
//       // Erreur de connexion ou autre exception
//       _errorMessage = 'Erreur de connexion: $e';
//       print('Erreur de connexion: $_errorMessage');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Vous pouvez ajouter d'autres méthodes ici, comme `fetchReservations()`
// }
