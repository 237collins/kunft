// ---------- Nouveau code dependant du UserProvider ---------

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/UserProvider.dart';

// Définissez votre URL de base d'API ici
const String API_BASE_URL = 'http://127.0.0.1:8000';

final Dio _dio = Dio(); // Instance de Dio pour les requêtes HTTP

class LogementProvider with ChangeNotifier {
  // ✅ NOUVEAU: Variable pour le message d'erreur général
  String? _generalErrorMessage;

  // ✅ NOUVEAU: Getter pour le message d'erreur
  String? get generalErrorMessage => _generalErrorMessage;

  // ✅ NOUVEAU: Méthode pour définir le message d'erreur
  void setErrorMessage(String? message) {
    _generalErrorMessage = message;
    notifyListeners();
  }

  // --- Données et états de chargement pour les logements généraux ---
  List<dynamic> _mainLogements = [];
  bool _isLoadingMainLogements = true;
  String? _errorMainLogements;

  List<dynamic> get mainLogements => _mainLogements;
  bool get isLoadingMainLogements => _isLoadingMainLogements;
  String? get errorMainLogements => _errorMainLogements;

  // --- Données et états de chargement pour le DERNIER logement
  Map<String, dynamic>? _lastLogement;
  bool _isLoadingLastLogement = true;
  String? _errorLastLogement;

  Map<String, dynamic>? get lastLogement => _lastLogement;
  bool get isLoadingLastLogement => _isLoadingLastLogement;
  String? get errorLastLogement => _errorLastLogement;

  // --- Données et états de chargement pour les logements populaires ---
  List<dynamic> _popularLogements = [];
  bool _isLoadingPopularLogements = true;
  String? _errorPopularLogements;

  List<dynamic> get popularLogements => _popularLogements;
  bool get isLoadingPopularLogements => _isLoadingPopularLogements;
  String? get errorPopularLogements => _errorPopularLogements;

  // --- Données et états de chargement pour les 10 derniers logements ---
  List<dynamic> _latestLogements = [];
  bool _isLoadingLatestLogements = true;
  String? _errorLatestLogements;

  List<dynamic> get latestLogements => _latestLogements;
  bool get isLoadingLatestLogements => _isLoadingLatestLogements;
  String? get errorLatestLogements => _errorLatestLogements;

  // --- Données et états de chargement pour les propriétaires tendance ---
  List<dynamic> _trendingOwners = [];
  bool _isLoadingTrendingOwners = true;
  String? _errorTrendingOwners;

  List<dynamic> get trendingOwners => _trendingOwners;
  bool get isLoadingTrendingOwners => _isLoadingTrendingOwners;
  String? get errorTrendingOwners => _errorTrendingOwners;

  // --- Données et états de chargement pour les recherches récentes ---
  List<dynamic> _recentSearches = [];
  bool _isLoadingRecentSearches = true;
  String? _errorRecentSearches;

  List<dynamic> get recentSearches => _recentSearches;
  bool get isLoadingRecentSearches => _isLoadingRecentSearches;
  String? get errorRecentSearches => _errorRecentSearches;

  // --- Données et états de chargement pour les compteurs de logements ---
  Map<String, int> _logementCounts = {
    'tous': 0,
    'duplex': 0,
    'villas': 0,
    'appartements': 0,
    'studios': 0,
    'chambres': 0,
  };
  bool _isLoadingLogementCounts = true;
  String? _errorLogementCounts;

  Map<String, int> get logementCounts => _logementCounts;
  bool get isLoadingLogementCounts => _isLoadingLogementCounts;
  String? get errorLogementCounts => _errorLogementCounts;

  // Helper pour obtenir le token
  String? getToken(BuildContext context) {
    return Provider.of<UserProvider>(context, listen: false).authToken;
  }

  // Helper pour extraire la liste de données de la réponse API
  List<dynamic> _extractDataFromResponse(dynamic responseData, String context) {
    if (responseData is Map &&
        responseData.containsKey('data') &&
        responseData['data'] is List) {
      return responseData['data'];
    } else if (responseData is Map &&
        responseData.containsKey('logements') &&
        responseData['logements'] is List) {
      return responseData['logements'];
    } else if (responseData is List) {
      return responseData;
    } else {
      String debugInfo =
          'Type de réponse inattendu: ${responseData.runtimeType}. ';
      if (responseData is Map) {
        debugInfo += 'Clés présentes: ${(responseData).keys.join(', ')}. ';
      }
      throw Exception('Format de réponse inattendu pour $context. $debugInfo');
    }
  }

  // Helper pour formater les données de logement (peut être réutilisé par les widgets)
  Map<String, String> formatLogementData(Map<String, dynamic> l) {
    final String imgUrl = (l['images'] != null && l['images'].isNotEmpty)
        ? '${l['images'][0]['image_paths']}'
        : 'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';

    // final String ownerName = (l['user'] != null && l['user']['name'] != null)
    //     ? '@${(l['user']['name'] as String).replaceAll(' ', '.').toLowerCase()}'
    //     : '@Hôte.inconnu'; // Ancien  code
    final String ownerName =
        '@${(l['users']?['name'] as String?)?.replaceAll(' ', '.').toLowerCase() ?? 'Hôte.inconnu'}';

    String formattedTime = 'Date inconnue';
    if (l['created_at'] != null) {
      try {
        final DateTime dateTime = DateTime.parse(l['created_at'] as String);
        final Duration difference = DateTime.now().difference(dateTime);
        if (difference.inDays > 30) {
          formattedTime = DateFormat('dd MMM yyyy', 'fr_FR').format(dateTime);
        } else if (difference.inDays > 0) {
          formattedTime =
              '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
        } else if (difference.inHours > 0) {
          formattedTime =
              '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
        } else if (difference.inMinutes > 0) {
          formattedTime =
              '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
        } else {
          formattedTime = 'à l\'instant';
        }
      } catch (e) {
        print('DEBUG: Erreur de parsing ou formatage de date: $e');
        formattedTime = 'Date invalide';
      }
    }

    String formattedPrice = 'N/A';
    if (l['price_per_night'] != null) {
      try {
        double price;
        if (l['price_per_night'] is String) {
          price = double.parse(l['price_per_night'] as String);
        } else if (l['price_per_night'] is num) {
          price = (l['price_per_night'] as num).toDouble();
        } else {
          throw FormatException('Type de prix inattendu');
        }
        formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
      } catch (e) {
        print(
          'DEBUG: Erreur de formatage du prix pour "${l['price_per_night']}" : $e',
        );
        formattedPrice = 'Prix invalide';
      }
    }

    return {
      'imgUrl': imgUrl,
      'houseName': l['titre'] ?? 'Titre Inconnu',
      'price': '$formattedPrice Fcfa',
      'locate': l['adresse'] ?? '',
      'ownerName': ownerName,
      'time': formattedTime,
    };
  }

  // --- Fonctions de récupération des données ---
  Future<void> fetchLastLogement(String? authToken) async {
    _isLoadingLastLogement = true;
    _errorLastLogement = null;
    notifyListeners();

    try {
      if (authToken == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final response = await _dio.get(
        '$API_BASE_URL/api/logements',
        queryParameters: {'limit': 1, 'sort': 'latest'},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final logements = _extractDataFromResponse(
          response.data,
          'le dernier logement',
        );
        if (logements.isNotEmpty) {
          _lastLogement = logements.first as Map<String, dynamic>;
        } else {
          _lastLogement = null;
        }
        _isLoadingLastLogement = false;
      } else {
        throw Exception(
          'Erreur API lors de la récupération du dernier logement: ${response.statusCode}',
        );
      }
    } catch (e) {
      _errorLastLogement = e.toString();
      _isLoadingLastLogement = false;
      print('DEBUG: Erreur fetchLastLogement: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchMainLogements({
    String? authToken,
    String? limit,
    String? sort,
  }) async {
    _isLoadingMainLogements = true;
    _errorMainLogements = null;
    // notifyListeners();

    try {
      if (authToken == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final Map<String, dynamic> queryParams = {};
      if (limit != null) queryParams['limit'] = limit;
      if (sort != null) queryParams['sort'] = sort;

      final response = await _dio.get(
        '$API_BASE_URL/api/logements',
        queryParameters: queryParams.isNotEmpty
            ? queryParams
            : {'sort': 'latest'},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        _mainLogements = _extractDataFromResponse(
          response.data,
          'les logements principaux',
        );
        _isLoadingMainLogements = false;
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur fetchMainLogements: $e');
      _errorMainLogements = e.toString();
      _isLoadingMainLogements = false;
    } finally {
      // notifyListeners();
    }
  }

  Future<void> fetchPopularLogements(String? authToken) async {
    _isLoadingPopularLogements = true;
    _errorPopularLogements = null;
    notifyListeners();

    try {
      if (authToken == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final response = await _dio.get(
        '$API_BASE_URL/api/logements',
        queryParameters: {'limit': 5, 'sort': 'latest'},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        _popularLogements = _extractDataFromResponse(
          response.data,
          'les logements populaires',
        );
        _isLoadingPopularLogements = false;
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur fetchPopularLogements: $e');
      _errorPopularLogements = e.toString();
      _isLoadingPopularLogements = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchLatestLogements(String? authToken) async {
    _isLoadingLatestLogements = true;
    _errorLatestLogements = null;
    notifyListeners();

    try {
      if (authToken == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final response = await _dio.get(
        '$API_BASE_URL/api/logements',
        queryParameters: {'limit': 10, 'sort': 'latest'},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        _latestLogements = _extractDataFromResponse(
          response.data,
          'les derniers logements',
        );
        _isLoadingLatestLogements = false;
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur fetchLatestLogements: $e');
      _errorLatestLogements = e.toString();
      _isLoadingLatestLogements = false;
    } finally {
      notifyListeners();
    }
  }
  //====================================================================
  // Pour afficher les hote populaires
  //====================================================================

  Future<void> fetchTrendingOwners(String? authToken) async {
    _isLoadingTrendingOwners = true;
    _errorTrendingOwners = null;
    notifyListeners();

    try {
      if (authToken == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final response = await _dio.get(
        '$API_BASE_URL/api/trending-owners',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        _trendingOwners = _extractDataFromResponse(
          response.data,
          'les propriétaires tendance',
        );
        _isLoadingTrendingOwners = false;
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur fetchTrendingOwners: $e');
      _errorTrendingOwners = e.toString();
      _isLoadingTrendingOwners = false;
    } finally {
      notifyListeners();
    }
  }

  //====================================================================
  // Pour afficher les recherches recentes, mais pas encore optimale
  //====================================================================

  Future<void> fetchRecentSearches(String? authToken) async {
    _isLoadingRecentSearches = true;
    _errorRecentSearches = null;
    notifyListeners();

    try {
      if (authToken == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final response = await _dio.get(
        '$API_BASE_URL/api/logements',
        queryParameters: {'limit': 4},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        _recentSearches = _extractDataFromResponse(
          response.data,
          'les recherches récentes',
        );
        _isLoadingRecentSearches = false;
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur fetchRecentSearches: $e');
      _errorRecentSearches = e.toString();
      _isLoadingRecentSearches = false;
    } finally {
      notifyListeners();
    }
  }

  //====================================================================
  // Pour afficher les logemnts a l'accueil
  //====================================================================
  Future<void> fetchHomeScreenData(String? authToken) async {
    await Future.wait<void>([
      fetchLastLogement(authToken),
      fetchPopularLogements(authToken),
      fetchMainLogements(authToken: authToken),
    ]);
  }

  Future<void> fetchExploreScreenData(String? authToken) async {
    await Future.wait<void>([
      fetchLatestLogements(authToken),
      fetchTrendingOwners(authToken),
      fetchRecentSearches(authToken),
    ]);
  }

  Future<void> fetchListLogementData(String? authToken) async {
    await Future.wait<void>([
      fetchLogementCounts(authToken),
      fetchMainLogements(authToken: authToken),
    ]);
  }

  Future<void> fetchLogementCounts(String? authToken) async {
    _isLoadingLogementCounts = true;
    _errorLogementCounts = null;
    notifyListeners();

    try {
      if (authToken == null) {
        // ✅ Gérer l'erreur avec la nouvelle méthode
        setErrorMessage('Token non trouvé. Veuillez vous connecter.');
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final response = await _dio.get(
        '$API_BASE_URL/api/logement-counts',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data is Map) {
        _logementCounts = Map<String, int>.from(
          response.data.map((key, value) => MapEntry(key, value as int)),
        );
        _isLoadingLogementCounts = false;
      } else {
        // ✅ Gérer l'erreur avec la nouvelle méthode
        setErrorMessage(
          'Erreur de chargement des compteurs: ${response.statusCode} - ${response.data}',
        );
        throw Exception(
          'Erreur de chargement des compteurs: ${response.statusCode} - ${response.data}',
        );
      }
    } on DioException catch (e) {
      String msg = 'Erreur réseau ou API: ${e.message}';
      if (e.response != null) {
        msg = 'Erreur API: ${e.response?.statusCode} - ${e.response?.data}';
      }
      print('DEBUG: Erreur fetchLogementCounts: $msg');
      // ✅ Gérer l'erreur avec la nouvelle méthode
      setErrorMessage('Impossible de charger les compteurs: $msg');
      _isLoadingLogementCounts = false;
    } catch (e) {
      print('DEBUG: Erreur inattendue fetchLogementCounts: $e');
      // ✅ Gérer l'erreur avec la nouvelle méthode
      setErrorMessage('Une erreur inattendue est survenue: ${e.toString()}');
      _isLoadingLogementCounts = false;
    } finally {
      notifyListeners();
    }
  }

  Future<List<dynamic>> fetchLogementsForType(
    String type,
    String? authToken,
  ) async {
    try {
      if (authToken == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }

      final response = await _dio.get(
        '$API_BASE_URL/api/logements',
        queryParameters: {'type_logement': type},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        return _extractDataFromResponse(
          response.data,
          'les logements de type $type',
        );
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur fetchLogementsForType ($type): $e');
      rethrow;
    }
  }
}



// ----------------- Ancien code okay mais Autonome ------------------


// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Définissez votre URL de base d'API ici
// const String API_BASE_URL = 'http://127.0.0.1:8000';

// final Dio _dio = Dio(); // Instance de Dio pour les requêtes HTTP

// class LogementProvider extends ChangeNotifier {
//   // --- Données et états de chargement pour les logements généraux ---
//   List<dynamic> _mainLogements = [];
//   bool _isLoadingMainLogements = true;
//   String? _errorMainLogements;

//   List<dynamic> get mainLogements => _mainLogements;
//   bool get isLoadingMainLogements => _isLoadingMainLogements;
//   String? get errorMainLogements => _errorMainLogements;

//   // --- Données et états de chargement pour le DERNIER logement
//   Map<String, dynamic>? _lastLogement;
//   bool _isLoadingLastLogement = true;
//   String? _errorLastLogement;

//   Map<String, dynamic>? get lastLogement => _lastLogement;
//   bool get isLoadingLastLogement => _isLoadingLastLogement;
//   String? get errorLastLogement => _errorLastLogement;

//   // --- Données et états de chargement pour les logements populaires ---
//   List<dynamic> _popularLogements = [];
//   bool _isLoadingPopularLogements = true;
//   String? _errorPopularLogements;

//   List<dynamic> get popularLogements => _popularLogements;
//   bool get isLoadingPopularLogements => _isLoadingPopularLogements;
//   String? get errorPopularLogements => _errorPopularLogements;

//   // --- Données et états de chargement pour les 10 derniers logements ---
//   List<dynamic> _latestLogements = [];
//   bool _isLoadingLatestLogements = true;
//   String? _errorLatestLogements;

//   List<dynamic> get latestLogements => _latestLogements;
//   bool get isLoadingLatestLogements => _isLoadingLatestLogements;
//   String? get errorLatestLogements => _errorLatestLogements;

//   // --- Données et états de chargement pour les propriétaires tendance ---
//   List<dynamic> _trendingOwners = [];
//   bool _isLoadingTrendingOwners = true;
//   String? _errorTrendingOwners;

//   List<dynamic> get trendingOwners => _trendingOwners;
//   bool get isLoadingTrendingOwners => _isLoadingTrendingOwners;
//   String? get errorTrendingOwners => _errorTrendingOwners;

//   // --- Données et états de chargement pour les recherches récentes ---
//   List<dynamic> _recentSearches = [];
//   bool _isLoadingRecentSearches = true;
//   String? _errorRecentSearches;

//   List<dynamic> get recentSearches => _recentSearches;
//   bool get isLoadingRecentSearches => _isLoadingRecentSearches;
//   String? get errorRecentSearches => _errorRecentSearches;

//   // --- Données et états de chargement pour les compteurs de logements ---
//   Map<String, int> _logementCounts = {
//     'tous': 0,
//     'duplex': 0,
//     'villas': 0,
//     'appartements': 0,
//     'studios': 0,
//     'chambres': 0,
//   };
//   bool _isLoadingLogementCounts = true;
//   String? _errorLogementCounts;

//   Map<String, int> get logementCounts => _logementCounts;
//   bool get isLoadingLogementCounts => _isLoadingLogementCounts;
//   String? get errorLogementCounts => _errorLogementCounts;

//   // Helper pour obtenir le token
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   // Helper pour extraire la liste de données de la réponse API
//   List<dynamic> _extractDataFromResponse(dynamic responseData, String context) {
//     if (responseData is Map &&
//         responseData.containsKey('data') &&
//         responseData['data'] is List) {
//       return responseData['data'];
//     } else if (responseData is Map &&
//         responseData.containsKey('logements') &&
//         responseData['logements'] is List) {
//       return responseData['logements'];
//     } else if (responseData is List) {
//       return responseData;
//     } else {
//       String debugInfo =
//           'Type de réponse inattendu: ${responseData.runtimeType}. ';
//       if (responseData is Map) {
//         debugInfo +=
//             'Clés présentes: ${(responseData).keys.join(', ')}. ';
//       }
//       throw Exception('Format de réponse inattendu pour $context. $debugInfo');
//     }
//   }

//   // Helper pour formater les données de logement (peut être réutilisé par les widgets)
//   Map<String, String> formatLogementData(Map<String, dynamic> l) {
//     final String imgUrl =
//         (l['images'] != null && l['images'].isNotEmpty)
//             ? '$API_BASE_URL/storage/${l['images'][0]['image_path']}'
//             : 'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';

//     final String ownerName =
//         (l['user'] != null && l['user']['name'] != null)
//             ? '@${(l['user']['name'] as String).replaceAll(' ', '.').toLowerCase()}'
//             : '@proprietaire.inconnu';

//     String formattedTime = 'Date inconnue';
//     if (l['created_at'] != null) {
//       try {
//         final DateTime dateTime = DateTime.parse(l['created_at'] as String);
//         final Duration difference = DateTime.now().difference(dateTime);
//         if (difference.inDays > 30) {
//           formattedTime = DateFormat('dd MMM yyyy', 'fr_FR').format(dateTime);
//         } else if (difference.inDays > 0) {
//           formattedTime =
//               '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
//         } else if (difference.inHours > 0) {
//           formattedTime =
//               '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
//         } else if (difference.inMinutes > 0) {
//           formattedTime =
//               '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
//         } else {
//           formattedTime = 'à l\'instant';
//         }
//       } catch (e) {
//         print('DEBUG: Erreur de parsing ou formatage de date: $e');
//         formattedTime = 'Date invalide';
//       }
//     }

//     String formattedPrice = 'N/A';
//     if (l['price_per_night'] != null) {
//       try {
//         double price;
//         if (l['price_per_night'] is String) {
//           price = double.parse(l['price_per_night'] as String);
//         } else if (l['price_per_night'] is num) {
//           price = (l['price_per_night'] as num).toDouble();
//         } else {
//           throw FormatException('Type de prix inattendu');
//         }
//         formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
//       } catch (e) {
//         print(
//           'DEBUG: Erreur de formatage du prix pour "${l['price_per_night']}" : $e',
//         );
//         formattedPrice = 'Prix invalide';
//       }
//     }

//     return {
//       'imgUrl': imgUrl,
//       'houseName': l['titre'] ?? 'Titre Inconnu',
//       'price': '$formattedPrice Fcfa',
//       'locate': l['adresse'] ?? '',
//       'ownerName': ownerName,
//       'time': formattedTime,
//     };
//   }

//   // --- Fonctions de récupération des données ---
//   // ----- Ancien code pas bien
//   // Future<void> fetchLastLogement() async {
//   //   _isLoadingLastLogement = true;
//   //   _errorLastLogement = null;
//   //   notifyListeners(); // ✅ CONSERVÉ pour la mise à jour initiale de l'état de chargement

//   //   try {
//   //     final token = await _getToken();
//   //     if (token == null) {
//   //       throw Exception('Token non trouvé. Veuillez vous connecter.');
//   //     }

//   //     final response = await _dio.get(
//   //       '$API_BASE_URL/api/logements',
//   //       queryParameters: {'limit': 1, 'sort': 'latest'},
//   //       options: Options(
//   //         headers: {
//   //           'Accept': 'application/json',
//   //           'Authorization': 'Bearer $token',
//   //         },
//   //       ),
//   //     );

//   //     if (response.statusCode == 200 &&
//   //         response.data is Map &&
//   //         response.data['data'] is List) {
//   //       final logements = response.data['data'] as List;
//   //       if (logements.isNotEmpty) {
//   //         _lastLogement = logements[0] as Map<String, dynamic>;
//   //       } else {
//   //         _lastLogement = null;
//   //       }
//   //       _isLoadingLastLogement = false;
//   //     } else {
//   //       throw Exception(
//   //         'Erreur API lors de la récupération du dernier logement: ${response.statusCode}',
//   //       );
//   //     }
//   //   } catch (e) {
//   //     _errorLastLogement = e.toString();
//   //     _isLoadingLastLogement = false;
//   //     print('DEBUG: Erreur fetchLastLogement: $e');
//   //   } finally {
//   //     notifyListeners(); // ✅ AJOUTÉ pour notifier la fin du chargement, que ce soit un succès ou un échec
//   //   }
//   // }

//   // ------- Nouveau code

//   Future<void> fetchLastLogement() async {
//     _isLoadingLastLogement = true;
//     _errorLastLogement = null;
//     notifyListeners();

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {'limit': 1, 'sort': 'latest'},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         // ✅ MODIFIÉ : Vérifiez si la réponse est bien une liste de logements
//         final logements = _extractDataFromResponse(
//           response.data,
//           'le dernier logement',
//         );
//         if (logements.isNotEmpty) {
//           _lastLogement = logements.first as Map<String, dynamic>;
//         } else {
//           _lastLogement = null;
//         }
//         _isLoadingLastLogement = false;
//       } else {
//         throw Exception(
//           'Erreur API lors de la récupération du dernier logement: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       _errorLastLogement = e.toString();
//       _isLoadingLastLogement = false;
//       print('DEBUG: Erreur fetchLastLogement: $e');
//     } finally {
//       notifyListeners();
//     }
//   }
//   // Fonction pour l'affichage de tous les logements dans la Home Screen

//   Future<void> fetchMainLogements({String? limit, String? sort}) async {
//     _isLoadingMainLogements = true;
//     _errorMainLogements = null;
//     // notifyListeners(); // ✅ AJOUTÉ

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final Map<String, dynamic> queryParams = {};
//       if (limit != null) queryParams['limit'] = limit;
//       if (sort != null) queryParams['sort'] = sort;

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters:
//             queryParams.isNotEmpty
//                 ? queryParams
//                 : {'sort': 'latest'}, // Pour tout afficher
//         // queryParameters: {'limit': 4, 'sort': 'latest'},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _mainLogements = _extractDataFromResponse(
//           response.data,
//           'les logements principaux',
//         );
//         _isLoadingMainLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchMainLogements: $e');
//       _errorMainLogements = e.toString();
//       _isLoadingMainLogements = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> fetchPopularLogements() async {
//     _isLoadingPopularLogements = true;
//     _errorPopularLogements = null;
//     notifyListeners(); // ✅ AJOUTÉ

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {'limit': 5, 'sort': 'latest'},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _popularLogements = _extractDataFromResponse(
//           response.data,
//           'les logements populaires',
//         );
//         _isLoadingPopularLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchPopularLogements: $e');
//       _errorPopularLogements = e.toString();
//       _isLoadingPopularLogements = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> fetchLatestLogements() async {
//     _isLoadingLatestLogements = true;
//     _errorLatestLogements = null;
//     // notifyListeners(); // ✅ AJOUTÉ

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {'limit': 10, 'sort': 'latest'},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _latestLogements = _extractDataFromResponse(
//           response.data,
//           'les derniers logements',
//         );
//         _isLoadingLatestLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchLatestLogements: $e');
//       _errorLatestLogements = e.toString();
//       _isLoadingLatestLogements = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> fetchTrendingOwners() async {
//     _isLoadingTrendingOwners = true;
//     _errorTrendingOwners = null;
//     // notifyListeners(); // ✅ AJOUTÉ

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/trending-owners',
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _trendingOwners = _extractDataFromResponse(
//           response.data,
//           'les propriétaires tendance',
//         );
//         _isLoadingTrendingOwners = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchTrendingOwners: $e');
//       _errorTrendingOwners = e.toString();
//       _isLoadingTrendingOwners = false;
//     } finally {
//       notifyListeners();
//     }
//   }
//   // Fonction pour l'affichage des logements recemment chercher dans la Explore Screen

//   Future<void> fetchRecentSearches() async {
//     _isLoadingRecentSearches = true;
//     _errorRecentSearches = null;
//     // notifyListeners(); // ✅ AJOUTÉ

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {'limit': 4},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _recentSearches = _extractDataFromResponse(
//           response.data,
//           'les recherches récentes',
//         );
//         _isLoadingRecentSearches = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchRecentSearches: $e');
//       _errorRecentSearches = e.toString();
//       _isLoadingRecentSearches = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> fetchHomeScreenData() async {
//     await Future.wait<void>([
//       fetchLastLogement(),
//       fetchPopularLogements(),
//       fetchMainLogements(),
//     ]);
//   }

//   Future<void> fetchExploreScreenData() async {
//     await Future.wait<void>([
//       fetchLatestLogements(),
//       fetchTrendingOwners(),
//       fetchRecentSearches(),
//     ]);
//   }

//   Future<void> fetchListLogementData() async {
//     await Future.wait<void>([fetchLogementCounts(), fetchMainLogements()]);
//   }

//   Future<void> fetchLogementCounts() async {
//     _isLoadingLogementCounts = true;
//     _errorLogementCounts = null;
//     // notifyListeners(); // ✅ AJOUTÉ

//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logement-counts',
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200 && response.data is Map) {
//         _logementCounts = Map<String, int>.from(
//           response.data.map((key, value) => MapEntry(key, value as int)),
//         );
//         _isLoadingLogementCounts = false;
//       } else {
//         throw Exception(
//           'Erreur de chargement des compteurs: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } on DioException catch (e) {
//       String msg = 'Erreur réseau ou API: ${e.message}';
//       if (e.response != null) {
//         msg = 'Erreur API: ${e.response?.statusCode} - ${e.response?.data}';
//       }
//       print('DEBUG: Erreur fetchLogementCounts: $msg');
//       _errorLogementCounts = 'Impossible de charger les compteurs: $msg';
//       _isLoadingLogementCounts = false;
//     } catch (e) {
//       print('DEBUG: Erreur inattendue fetchLogementCounts: $e');
//       _errorLogementCounts = 'Une erreur inattendue est survenue: $e';
//       _isLoadingLogementCounts = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<List<dynamic>> fetchLogementsForType(String type) async {
//     try {
//       final token = await _getToken();
//       if (token == null) {
//         throw Exception('Token non trouvé. Veuillez vous connecter.');
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {'type_logement': type},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         return _extractDataFromResponse(
//           response.data,
//           'les logements de type $type',
//         );
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchLogementsForType ($type): $e');
//       rethrow;
//     }
//   }
// }

// ----Ancien code okay mais... Last Logement

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Définissez votre URL de base d'API ici
// const String API_BASE_URL = 'http://127.0.0.1:8000';

// final Dio _dio = Dio(); // Instance de Dio pour les requêtes HTTP

// class LogementProvider extends ChangeNotifier {
//   // --- Données et états de chargement pour les logements généraux (utilisés dans HomeScreen, TousLogements, etc.) ---
//   List<dynamic> _mainLogements = []; // ✅ RENOMMÉ pour plus de clarté
//   bool _isLoadingMainLogements = true;
//   String? _errorMainLogements;

//   List<dynamic> get mainLogements => _mainLogements; // ✅ RENOMMÉ
//   bool get isLoadingMainLogements => _isLoadingMainLogements; // ✅ RENOMMÉ
//   String? get errorMainLogements => _errorMainLogements; // ✅ RENOMMÉ

//   // --- Données et états de chargement pour les logements populaires (utilisés dans HomeScreen) ---
//   List<dynamic> _popularLogements = [];
//   bool _isLoadingPopularLogements = true;
//   String? _errorPopularLogements;

//   List<dynamic> get popularLogements => _popularLogements;
//   bool get isLoadingPopularLogements => _isLoadingPopularLogements;
//   String? get errorPopularLogements => _errorPopularLogements;

//   // --- Données et états de chargement pour les 10 derniers logements (utilisés dans ExploreScreen) ---
//   List<dynamic> _latestLogements = [];
//   bool _isLoadingLatestLogements = true;
//   String? _errorLatestLogements;

//   List<dynamic> get latestLogements => _latestLogements;
//   bool get isLoadingLatestLogements => _isLoadingLatestLogements;
//   String? get errorLatestLogements => _errorLatestLogements;

//   // --- Données et états de chargement pour les propriétaires tendance (utilisés dans ExploreScreen) ---
//   List<dynamic> _trendingOwners = [];
//   bool _isLoadingTrendingOwners = true;
//   String? _errorTrendingOwners;

//   List<dynamic> get trendingOwners => _trendingOwners;
//   bool get isLoadingTrendingOwners => _isLoadingTrendingOwners;
//   String? get errorTrendingOwners => _errorTrendingOwners;

//   // --- Données et états de chargement pour les recherches récentes (utilisés dans ExploreScreen) ---
//   List<dynamic> _recentSearches = [];
//   bool _isLoadingRecentSearches = true;
//   String? _errorRecentSearches;

//   List<dynamic> get recentSearches => _recentSearches;
//   bool get isLoadingRecentSearches => _isLoadingRecentSearches;
//   String? get errorRecentSearches => _errorRecentSearches;

//   // --- Données et états de chargement pour les compteurs de logements (utilisés dans ListLogement) ---
//   Map<String, int> _logementCounts = {
//     'tous': 0,
//     'duplex': 0,
//     'villas': 0,
//     'appartements': 0,
//     'studios': 0,
//     'chambres': 0,
//   };
//   bool _isLoadingLogementCounts = true;
//   String? _errorLogementCounts;

//   Map<String, int> get logementCounts => _logementCounts;
//   bool get isLoadingLogementCounts => _isLoadingLogementCounts;
//   String? get errorLogementCounts => _errorLogementCounts;

//   // Helper pour obtenir le token
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   // Helper pour extraire la liste de données de la réponse API
//   List<dynamic> _extractDataFromResponse(dynamic responseData, String context) {
//     if (responseData is Map &&
//         responseData.containsKey('data') &&
//         responseData['data'] is List) {
//       return responseData['data'];
//     } else if (responseData is Map &&
//         responseData.containsKey('logements') &&
//         responseData['logements'] is List) {
//       return responseData['logements'];
//     } else if (responseData is List) {
//       return responseData;
//     } else {
//       String debugInfo =
//           'Type de réponse inattendu: ${responseData.runtimeType}. ';
//       if (responseData is Map) {
//         debugInfo +=
//             'Clés présentes: ${(responseData as Map).keys.join(', ')}. ';
//       }
//       throw Exception('Format de réponse inattendu pour $context. $debugInfo');
//     }
//   }

//   // Helper pour formater les données de logement (peut être réutilisé par les widgets)
//   Map<String, String> formatLogementData(Map<String, dynamic> l) {
//     final String imgUrl =
//         (l['images'] != null && l['images'].isNotEmpty)
//             ? '$API_BASE_URL/storage/${l['images'][0]['image_path']}'
//             : 'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';

//     final String ownerName =
//         (l['user'] != null && l['user']['name'] != null)
//             ? '@${(l['user']['name'] as String).replaceAll(' ', '.').toLowerCase()}'
//             : '@proprietaire.inconnu';

//     String formattedTime = 'Date inconnue';
//     if (l['created_at'] != null) {
//       try {
//         final DateTime dateTime = DateTime.parse(l['created_at'] as String);
//         final Duration difference = DateTime.now().difference(dateTime);
//         if (difference.inDays > 30) {
//           formattedTime = DateFormat('dd MMM yyyy', 'fr_FR').format(dateTime);
//         } else if (difference.inDays > 0) {
//           formattedTime =
//               '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
//         } else if (difference.inHours > 0) {
//           formattedTime =
//               '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
//         } else if (difference.inMinutes > 0) {
//           formattedTime =
//               '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
//         } else {
//           formattedTime = 'à l\'instant';
//         }
//       } catch (e) {
//         print('DEBUG: Erreur de parsing ou formatage de date: $e');
//         formattedTime = 'Date invalide';
//       }
//     }

//     String formattedPrice = 'N/A';
//     if (l['price_per_night'] != null) {
//       try {
//         double price;
//         if (l['price_per_night'] is String) {
//           price = double.parse(l['price_per_night'] as String);
//         } else if (l['price_per_night'] is num) {
//           price = (l['price_per_night'] as num).toDouble();
//         } else {
//           throw FormatException('Type de prix inattendu');
//         }
//         formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
//       } catch (e) {
//         print(
//           'DEBUG: Erreur de formatage du prix pour "${l['price_per_night']}" : $e',
//         );
//         formattedPrice = 'Prix invalide';
//       }
//     }

//     return {
//       'imgUrl': imgUrl,
//       'houseName': l['titre'] ?? 'Titre Inconnu',
//       'price': '$formattedPrice Fcfa',
//       'locate': l['adresse'] ?? '',
//       'ownerName': ownerName,
//       'time': formattedTime,
//     };
//   }

//   // --- Fonctions de récupération des données ---

//   // ✅ MODIFIÉ : Récupère les logements généraux (pour HomeScreen, TousLogements)
//   Future<void> fetchMainLogements({String? limit, String? sort}) async {
//     _isLoadingMainLogements = true;
//     _errorMainLogements = null;
//     // notifyListeners(); // Retiré pour éviter l'erreur "called during build"

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final Map<String, dynamic> queryParams = {};
//       if (limit != null) queryParams['limit'] = limit;
//       if (sort != null) queryParams['sort'] = sort;

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: queryParams.isNotEmpty ? queryParams : null,
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _mainLogements = _extractDataFromResponse(
//           response.data,
//           'les logements principaux',
//         );
//         _isLoadingMainLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchMainLogements: $e');
//       _errorMainLogements = e.toString();
//       _isLoadingMainLogements = false;
//     } finally {
//       notifyListeners(); // Notifie la fin du chargement (succès ou erreur)
//     }
//   }

//   // Récupère les logements populaires (pour HomeScreen)
//   Future<void> fetchPopularLogements() async {
//     _isLoadingPopularLogements = true;
//     _errorPopularLogements = null;
//     // notifyListeners(); // Retiré

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {
//           'limit': 5,
//           'sort': 'latest',
//         }, // Récupère les 5 derniers logements
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _popularLogements = _extractDataFromResponse(
//           response.data,
//           'les logements populaires',
//         );
//         _isLoadingPopularLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchPopularLogements: $e');
//       _errorPopularLogements = e.toString();
//       _isLoadingPopularLogements = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Récupère les 10 derniers logements (pour ExploreScreen)
//   Future<void> fetchLatestLogements() async {
//     _isLoadingLatestLogements = true;
//     _errorLatestLogements = null;
//     // notifyListeners(); // Retiré

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {
//           'limit': 10,
//           'sort': 'latest',
//         }, // Assurez-vous que votre API gère ces paramètres
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _latestLogements = _extractDataFromResponse(
//           response.data,
//           'les derniers logements',
//         );
//         _isLoadingLatestLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchLatestLogements: $e');
//       _errorLatestLogements = e.toString();
//       _isLoadingLatestLogements = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Récupère les propriétaires tendance (pour ExploreScreen)
//   Future<void> fetchTrendingOwners() async {
//     _isLoadingTrendingOwners = true;
//     _errorTrendingOwners = null;
//     // notifyListeners(); // Retiré

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/trending-owners', // Assurez-vous que cette route existe et est protégée
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _trendingOwners = _extractDataFromResponse(
//           response.data,
//           'les propriétaires tendance',
//         );
//         _isLoadingTrendingOwners = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchTrendingOwners: $e');
//       _errorTrendingOwners = e.toString();
//       _isLoadingTrendingOwners = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Récupère les logements pour la section "récemment recherchés" (pour ExploreScreen)
//   Future<void> fetchRecentSearches() async {
//     _isLoadingRecentSearches = true;
//     _errorRecentSearches = null;
//     // notifyListeners(); // Retiré

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements', // Utilise le même endpoint, sans filtre spécifique pour l'exemple
//         queryParameters: {
//           'limit': 4,
//         }, // Limite à quelques éléments pour cette section
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _recentSearches = _extractDataFromResponse(
//           response.data,
//           'les recherches récentes',
//         );
//         _isLoadingRecentSearches = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchRecentSearches: $e');
//       _errorRecentSearches = e.toString();
//       _isLoadingRecentSearches = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Fonction pour charger toutes les données initiales de la HomeScreen
//   Future<void> fetchHomeScreenData() async {
//     await Future.wait<void>([
//       fetchMainLogements(), // Charge les logements généraux pour la section principale
//       fetchPopularLogements(), // Charge les logements populaires
//     ]);
//   }

//   // Fonction pour charger toutes les données initiales de l'ExploreScreen
//   Future<void> fetchExploreScreenData() async {
//     await Future.wait<void>([
//       fetchLatestLogements(),
//       fetchTrendingOwners(),
//       fetchRecentSearches(),
//     ]);
//   }

//   // Fonction pour charger toutes les données initiales de la ListLogement
//   Future<void> fetchListLogementData() async {
//     await Future.wait<void>([
//       fetchLogementCounts(),
//       fetchMainLogements(), // Charge aussi les logements principaux pour l'onglet "Tous"
//     ]);
//   }

//   // Récupère les compteurs de logements par type (pour ListLogement)
//   Future<void> fetchLogementCounts() async {
//     _isLoadingLogementCounts = true;
//     _errorLogementCounts = null;
//     // notifyListeners(); // Retiré

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logement-counts', // Endpoint Laravel pour les comptes
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200 && response.data is Map) {
//         _logementCounts = Map<String, int>.from(
//           response.data.map((key, value) => MapEntry(key, value as int)),
//         );
//         _isLoadingLogementCounts = false;
//       } else {
//         throw Exception(
//           'Erreur de chargement des compteurs: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } on DioException catch (e) {
//       String msg = 'Erreur réseau ou API: ${e.message}';
//       if (e.response != null) {
//         msg = 'Erreur API: ${e.response?.statusCode} - ${e.response?.data}';
//       }
//       print('DEBUG: Erreur fetchLogementCounts: $msg');
//       _errorLogementCounts = 'Impossible de charger les compteurs: $msg';
//       _isLoadingLogementCounts = false;
//     } catch (e) {
//       print('DEBUG: Erreur inattendue fetchLogementCounts: $e');
//       _errorLogementCounts = 'Une erreur inattendue est survenue: $e';
//       _isLoadingLogementCounts = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // ✅ AJOUTÉ : Fonction pour charger les logements par type (retourne la liste, ne met pas à jour l'état du provider)
//   Future<List<dynamic>> fetchLogementsForType(String type) async {
//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {
//           'type_logement': type,
//         }, // Utilisez 'type_logement' si c'est le paramètre Laravel
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         return _extractDataFromResponse(
//           response.data,
//           'les logements de type $type',
//         );
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchLogementsForType ($type): $e');
//       rethrow; // Re-throw l'erreur pour que le widget appelant puisse la gérer
//     }
//   }
// }

// Code Okay sans mais sans les fonctions de recherche recents et infos de proprietaires

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // URL de base d'API ici
// const String API_BASE_URL = 'http://127.0.0.1:8000';

// final Dio _dio = Dio(); // Instance de Dio pour les requêtes HTTP

// class LogementProvider extends ChangeNotifier {
//   // --- Données et états de chargement pour les logements généraux (utilisés dans HomeScreen) ---
//   List<dynamic> _logements = [];
//   bool _isLoadingLogements = true;
//   String? _errorLogements;

//   List<dynamic> get logements => _logements;
//   bool get isLoadingLogements => _isLoadingLogements;
//   String? get errorLogements => _errorLogements;

//   // --- Données et états de chargement pour les logements populaires (utilisés dans HomeScreen) ---
//   List<dynamic> _popularLogements = [];
//   bool _isLoadingPopularLogements = true;
//   String? _errorPopularLogements;

//   List<dynamic> get popularLogements => _popularLogements;
//   bool get isLoadingPopularLogements => _isLoadingPopularLogements;
//   String? get errorPopularLogements => _errorPopularLogements;

//   // --- Données et états de chargement pour les propriétaires tendance (utilisés dans ExploreScreen) ---
//   List<dynamic> _trendingOwners = [];
//   bool _isLoadingTrendingOwners = true;
//   String? _errorTrendingOwners;

//   List<dynamic> get trendingOwners => _trendingOwners;
//   bool get isLoadingTrendingOwners => _isLoadingTrendingOwners;
//   String? get errorTrendingOwners => _errorTrendingOwners;

//   // --- Données et états de chargement pour les recherches récentes (utilisés dans ExploreScreen) ---
//   List<dynamic> _recentSearches = [];
//   bool _isLoadingRecentSearches = true;
//   String? _errorRecentSearches;

//   List<dynamic> get recentSearches => _recentSearches;
//   bool get isLoadingRecentSearches => _isLoadingRecentSearches;
//   String? get errorRecentSearches => _errorRecentSearches;

//   // --- Données et états de chargement pour les compteurs de logements (utilisés dans ListLogement) ---
//   Map<String, int> _logementCounts = {
//     'tous': 0,
//     'duplex': 0,
//     'villas': 0,
//     'appartements': 0,
//     'studios': 0,
//     'chambres': 0,
//   };
//   bool _isLoadingLogementCounts = true;
//   String? _errorLogementCounts;

//   Map<String, int> get logementCounts => _logementCounts;
//   bool get isLoadingLogementCounts => _isLoadingLogementCounts;
//   String? get errorLogementCounts => _errorLogementCounts;

//   // Helper pour obtenir le token
//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   // Helper pour extraire la liste de données de la réponse API
//   List<dynamic> _extractDataFromResponse(dynamic responseData, String context) {
//     if (responseData is Map &&
//         responseData.containsKey('data') &&
//         responseData['data'] is List) {
//       return responseData['data'];
//     } else if (responseData is Map &&
//         responseData.containsKey('logements') &&
//         responseData['logements'] is List) {
//       return responseData['logements'];
//     } else if (responseData is List) {
//       return responseData;
//     } else {
//       String debugInfo =
//           'Type de réponse inattendu: ${responseData.runtimeType}. ';
//       if (responseData is Map) {
//         debugInfo +=
//             'Clés présentes: ${(responseData as Map).keys.join(', ')}. ';
//       }
//       throw Exception('Format de réponse inattendu pour $context. $debugInfo');
//     }
//   }

//   // Helper pour formater les données de logement (peut être réutilisé par les widgets)
//   Map<String, String> formatLogementData(Map<String, dynamic> l) {
//     final String imgUrl =
//         (l['images'] != null && l['images'].isNotEmpty)
//             ? '$API_BASE_URL/storage/${l['images'][0]['image_path']}'
//             : 'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';

//     final String ownerName =
//         (l['user'] != null && l['user']['name'] != null)
//             ? '@${(l['user']['name'] as String).replaceAll(' ', '.').toLowerCase()}'
//             : '@proprietaire.inconnu';

//     String formattedTime = 'Date inconnue';
//     if (l['created_at'] != null) {
//       try {
//         final DateTime dateTime = DateTime.parse(l['created_at'] as String);
//         final Duration difference = DateTime.now().difference(dateTime);
//         if (difference.inDays > 30) {
//           formattedTime = DateFormat('dd MMM yyyy', 'fr_FR').format(dateTime);
//         } else if (difference.inDays > 0) {
//           formattedTime =
//               '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
//         } else if (difference.inHours > 0) {
//           formattedTime =
//               '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
//         } else if (difference.inMinutes > 0) {
//           formattedTime =
//               '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
//         } else {
//           formattedTime = 'à l\'instant';
//         }
//       } catch (e) {
//         print('DEBUG: Erreur de parsing ou formatage de date: $e');
//         formattedTime = 'Date invalide';
//       }
//     }

//     String formattedPrice = 'N/A';
//     if (l['price_per_night'] != null) {
//       try {
//         double price;
//         if (l['price_per_night'] is String) {
//           price = double.parse(l['price_per_night'] as String);
//         } else if (l['price_per_night'] is num) {
//           price = (l['price_per_night'] as num).toDouble();
//         } else {
//           throw FormatException('Type de prix inattendu');
//         }
//         formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
//       } catch (e) {
//         print(
//           'DEBUG: Erreur de formatage du prix pour "${l['price_per_night']}" : $e',
//         );
//         formattedPrice = 'Prix invalide';
//       }
//     }

//     return {
//       'imgUrl': imgUrl,
//       'houseName': l['titre'] ?? 'Titre Inconnu',
//       'price': '$formattedPrice Fcfa',
//       'locate': l['adresse'] ?? '',
//       'ownerName': ownerName,
//       'time': formattedTime,
//     };
//   }

//   // --- Fonctions de récupération des données ---

//   // Récupère les logements généraux (pour HomeScreen, TousLogements, Duplex, etc.)
//   Future<void> fetchLogements({String? type, int? limit, String? sort}) async {
//     _isLoadingLogements = true;
//     _errorLogements = null;
//     notifyListeners(); // Notifie le début du chargement

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final Map<String, dynamic> queryParams = {};
//       if (type != null) queryParams['type_logement'] = type;
//       if (limit != null) queryParams['limit'] = limit;
//       if (sort != null) queryParams['sort'] = sort;

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: queryParams.isNotEmpty ? queryParams : null,
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _logements = _extractDataFromResponse(response.data, 'les logements');
//         _isLoadingLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchLogements: $e');
//       _errorLogements = e.toString();
//       _isLoadingLogements = false;
//     } finally {
//       notifyListeners(); // Notifie la fin du chargement (succès ou erreur)
//     }
//   }

//   // Récupère les logements populaires (pour HomeScreen)
//   Future<void> fetchPopularLogements() async {
//     _isLoadingPopularLogements = true;
//     _errorPopularLogements = null;
//     notifyListeners();

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {
//           'limit': 5,
//           'sort': 'latest',
//         }, // Récupère les 5 derniers logements
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _popularLogements = _extractDataFromResponse(
//           response.data,
//           'les logements populaires',
//         );
//         _isLoadingPopularLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchPopularLogements: $e');
//       _errorPopularLogements = e.toString();
//       _isLoadingPopularLogements = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Récupère les propriétaires tendance (pour ExploreScreen)
//   Future<void> fetchTrendingOwners() async {
//     _isLoadingTrendingOwners = true;
//     _errorTrendingOwners = null;
//     notifyListeners();

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/trending-owners', // Assurez-vous que cette route existe et est protégée
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _trendingOwners = _extractDataFromResponse(
//           response.data,
//           'les propriétaires tendance',
//         );
//         _isLoadingTrendingOwners = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchTrendingOwners: $e');
//       _errorTrendingOwners = e.toString();
//       _isLoadingTrendingOwners = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Récupère les logements pour la section "récemment recherchés" (pour ExploreScreen)
//   Future<void> fetchRecentSearches() async {
//     _isLoadingRecentSearches = true;
//     _errorRecentSearches = null;
//     notifyListeners();

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements', // Utilise le même endpoint, sans filtre spécifique pour l'exemple
//         queryParameters: {
//           'limit': 6,
//         }, // Limite à quelques éléments pour cette section
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _recentSearches = _extractDataFromResponse(
//           response.data,
//           'les recherches récentes',
//         );
//         _isLoadingRecentSearches = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchRecentSearches: $e');
//       _errorRecentSearches = e.toString();
//       _isLoadingRecentSearches = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Récupère les compteurs de logements par type (pour ListLogement)
//   Future<void> fetchLogementCounts() async {
//     _isLoadingLogementCounts = true;
//     _errorLogementCounts = null;
//     notifyListeners();

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logement-counts', // Endpoint Laravel pour les comptes
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200 && response.data is Map) {
//         _logementCounts = Map<String, int>.from(
//           response.data.map((key, value) => MapEntry(key, value as int)),
//         );
//         _isLoadingLogementCounts = false;
//       } else {
//         throw Exception(
//           'Erreur de chargement des compteurs: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } on DioException catch (e) {
//       String msg = 'Erreur réseau ou API: ${e.message}';
//       if (e.response != null) {
//         msg = 'Erreur API: ${e.response?.statusCode} - ${e.response?.data}';
//       }
//       print('DEBUG: Erreur fetchLogementCounts: $msg');
//       _errorLogementCounts = 'Impossible de charger les compteurs: $msg';
//       _isLoadingLogementCounts = false;
//     } catch (e) {
//       print('DEBUG: Erreur inattendue fetchLogementCounts: $e');
//       _errorLogementCounts = 'Une erreur inattendue est survenue: $e';
//       _isLoadingLogementCounts = false;
//     } finally {
//       notifyListeners();
//     }
//   }

//   // Fonction pour charger toutes les données initiales de la HomeScreen
//   Future<void> fetchHomeScreenData() async {
//     await Future.wait([
//       fetchLogements(), // Charge les logements généraux pour la section principale
//       fetchPopularLogements(), // Charge les logements populaires
//     ]);
//   }

//   // Fonction pour charger toutes les données initiales de l'ExploreScreen
//   Future<void> fetchExploreScreenData() async {
//     await Future.wait([fetchTrendingOwners(), fetchRecentSearches()]);
//   }

//   // Fonction pour charger toutes les données initiales de la ListLogement
//   Future<void> fetchListLogementData() async {
//     await Future.wait([
//       fetchLogementCounts(),
//       // Si ListLogement a besoin de la liste complète des logements, appelez aussi:
//       // fetchLogements(),
//     ]);
//   }

//   // Fonction pour charger les logements par type (utilisée par Duplex, Villas, etc.)
//   Future<void> fetchLogementsByType(String type) async {
//     _isLoadingLogements =
//         true; // Utilise le même état de chargement que les logements généraux
//     _errorLogements = null;
//     notifyListeners();

//     try {
//       final token = await _getToken();
//       if (token == null)
//         throw Exception('Token non trouvé. Veuillez vous connecter.');

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logements',
//         queryParameters: {'type_logements': type},
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         _logements = _extractDataFromResponse(
//           response.data,
//           'les logements de type $type',
//         );
//         _isLoadingLogements = false;
//       } else {
//         throw Exception(
//           'Erreur API: ${response.statusCode} - ${response.data}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Erreur fetchLogementsByType ($type): $e');
//       _errorLogements = e.toString();
//       _isLoadingLogements = false;
//     } finally {
//       notifyListeners();
//     }
//   }
// }
