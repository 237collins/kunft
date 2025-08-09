// Noubeu code

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Import de Provider
// Retirez dio et shared_preferences, car ils sont gérés par le Provider
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:kunft/widget/widget_horizontal_section_navigator.dart';

// Importez les widgets de sections de logement
import 'package:kunft/pages/logements/type_logements/apparts.dart';
import 'package:kunft/pages/logements/type_logements/chambres.dart';
import 'package:kunft/pages/logements/type_logements/duplex.dart';
import 'package:kunft/pages/logements/type_logements/studio.dart';
import 'package:kunft/pages/logements/type_logements/tous_logements.dart';
import 'package:kunft/pages/logements/type_logements/villas.dart';

// Importez votre LogementProvider
import 'package:kunft/provider/logement_provider.dart';

// Retirez les constantes API_BASE_URL et _dio, elles sont maintenant dans le Provider
// const String API_BASE_URL = 'http://127.0.0.1:8000';
// final Dio _dio = Dio();

class ListLogement extends StatefulWidget {
  const ListLogement({super.key});

  @override
  State<ListLogement> createState() => _ListLogementState();
}

class _ListLogementState extends State<ListLogement> {
  // ✅ RETIRÉ : Variables d'état pour stocker les compteurs de logements
  // Map<String, int> _logementCounts = {
  //   'tous': 0,
  //   'duplex': 0,
  //   'villas': 0,
  //   'appartements': 0,
  //   'studios': 0,
  //   'chambres': 0,
  // };
  // bool _isLoadingCounts = true;
  // String? _countsErrorMessage;

  @override
  void initState() {
    super.initState();
    // ✅ Appelle la fonction de fetch du provider pour les compteurs
    // listen: false car nous ne voulons pas reconstruire le widget ici, juste appeler la fonction
    Provider.of<LogementProvider>(context, listen: false).fetchLogementCounts();
  }

  // ✅ RETIRÉ : Fonction pour récupérer les compteurs de logements depuis Laravel
  // Future<void> _fetchLogementCounts() async { ... }

  @override
  Widget build(BuildContext context) {
    // ✅ Consomme les données du LogementProvider
    return Consumer<LogementProvider>(
      builder: (context, logementProvider, child) {
        // Accédez aux données et aux états de chargement via logementProvider
        final Map<String, int> logementCounts = logementProvider.logementCounts;
        final bool isLoadingCounts = logementProvider.isLoadingLogementCounts;
        final String? countsErrorMessage = logementProvider.errorLogementCounts;

        // Préparer les données pour HorizontalSectionNavigator
        final List<Map<String, dynamic>> sectionTitlesData = [
          {'title': 'Tous', 'count': logementCounts['tous']},
          {'title': 'Duplex', 'count': logementCounts['duplex']},
          {'title': 'Villas', 'count': logementCounts['villas']},
          {'title': 'Appartements', 'count': logementCounts['appartements']},
          {'title': 'Studios', 'count': logementCounts['studios']},
          {'title': 'Chambres', 'count': logementCounts['chambres']},
        ];

        final List<Widget> sectionContents = [
          const TousLogements(),
          const Duplex(),
          const Villas(),
          const Apparts(),
          const Studio(),
          const Chambres(),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Catégories Disponible'),
            backgroundColor: Colors.white,
          ),
          body:
              isLoadingCounts // ✅ Afficher un indicateur de chargement pour les compteurs
                  ? const Center(child: CircularProgressIndicator())
                  : countsErrorMessage !=
                      null // ✅ Afficher un message d'erreur si la récupération échoue
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        countsErrorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: HorizontalSectionNavigator(
                            sectionTitlesData:
                                sectionTitlesData, // ✅ Passez les données avec les compteurs
                            sectionContents: sectionContents,
                            // La propriété 'sectionTitles' n'existe plus dans HorizontalSectionNavigator
                            // Si vous l'avez ajoutée manuellement, retirez-la ici.
                            // sectionTitles: [],
                            // Personnalisation optionnelle
                            // navigationBarColor: Colors.deepPurple,
                            // selectedTitleColor: Colors.amberAccent,
                            // unselectedTitleColor: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}


// Ancien code Okay 

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart'; // Import pour les requêtes HTTP
// import 'package:kunft/widget/widget_horizontal_section_navigator.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import pour récupérer le token

// // Importez les widgets de sections de logement
// import 'package:kunft/pages/logements/type_logements/apparts.dart';
// import 'package:kunft/pages/logements/type_logements/chambres.dart';
// import 'package:kunft/pages/logements/type_logements/duplex.dart';
// import 'package:kunft/pages/logements/type_logements/studio.dart';
// import 'package:kunft/pages/logements/type_logements/tous_logements.dart';
// import 'package:kunft/pages/logements/type_logements/villas.dart';

// const String API_BASE_URL = 'http://127.0.0.1:8000';
// final Dio _dio = Dio();

// class ListLogement extends StatefulWidget {
//   const ListLogement({super.key});

//   @override
//   State<ListLogement> createState() => _ListLogementState();
// }

// class _ListLogementState extends State<ListLogement> {
//   // ✅ Variables d'état pour stocker les compteurs de logements
//   Map<String, int> _logementCounts = {
//     'tous': 0,
//     'duplex': 0,
//     'villas': 0,
//     'appartements': 0,
//     'studios': 0,
//     'chambres': 0,
//   };
//   bool _isLoadingCounts = true;
//   String? _countsErrorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchLogementCounts(); // Lancer la récupération des compteurs au démarrage
//   }

//   // ✅ Fonction pour récupérer les compteurs de logements depuis Laravel
//   Future<void> _fetchLogementCounts() async {
//     setState(() {
//       _isLoadingCounts = true;
//       _countsErrorMessage = null;
//     });
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String? token = prefs.getString('token');

//       if (token == null) {
//         throw Exception(
//           'Non authentifié. Veuillez vous connecter pour obtenir les comptes.',
//         );
//       }

//       final response = await _dio.get(
//         '$API_BASE_URL/api/logement-counts', // ✅ Endpoint Laravel pour les comptes
//         options: Options(
//           headers: {
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200 && response.data is Map) {
//         setState(() {
//           _logementCounts = Map<String, int>.from(
//             response.data.map((key, value) => MapEntry(key, value as int)),
//           );
//           _isLoadingCounts = false;
//         });
//         print('DEBUG: Compteurs de logements chargés: $_logementCounts');
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
//       print('DEBUG: Erreur lors du fetch des compteurs de logements: $msg');
//       setState(() {
//         _isLoadingCounts = false;
//         _countsErrorMessage = 'Impossible de charger les compteurs: $msg';
//       });
//     } catch (e) {
//       print('DEBUG: Erreur inattendue lors du fetch des compteurs: $e');
//       setState(() {
//         _isLoadingCounts = false;
//         _countsErrorMessage = 'Une erreur inattendue est survenue: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Préparer les données pour HorizontalSectionNavigator
//     final List<Map<String, dynamic>> sectionTitlesData = [
//       {'title': 'Tous', 'count': _logementCounts['tous']},
//       {'title': 'Duplex', 'count': _logementCounts['duplex']},
//       {'title': 'Villas', 'count': _logementCounts['villas']},
//       {'title': 'Appartements', 'count': _logementCounts['appartements']},
//       {'title': 'Studios', 'count': _logementCounts['studios']},
//       {'title': 'Chambres', 'count': _logementCounts['chambres']},
//     ];

//     final List<Widget> sectionContents = [
//       const TousLogements(), // Assurez-vous que ce widget existe
//       const Duplex(), // Créez ces widgets ou utilisez des placeholders
//       const Villas(),
//       const Apparts(),
//       const Studio(),
//       const Chambres(),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Catégories Disponible'), // Ajout de const
//         backgroundColor: Colors.white,
//       ),
//       body:
//           _isLoadingCounts // ✅ Afficher un indicateur de chargement pour les compteurs
//               ? const Center(child: CircularProgressIndicator())
//               : _countsErrorMessage !=
//                   null // ✅ Afficher un message d'erreur si la récupération échoue
//               ? Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0), // Ajout de const
//                   child: Text(
//                     _countsErrorMessage!,
//                     style: const TextStyle(
//                       color: Colors.red,
//                       fontSize: 16,
//                     ), // Ajout de const
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               )
//               : Padding(
//                 padding: const EdgeInsets.only(
//                   left: 10,
//                   right: 10,
//                 ), // Ajout de const
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: HorizontalSectionNavigator(
//                         sectionTitlesData:
//                             sectionTitlesData, // ✅ Passez les données avec les compteurs
//                         sectionContents: sectionContents,
//                         sectionTitles: [],
//                         // Personnalisation optionnelle
//                         // navigationBarColor: Colors.deepPurple,
//                         // selectedTitleColor: Colors.amberAccent,
//                         // unselectedTitleColor: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }





