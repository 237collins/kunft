import 'package:flutter/material.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:kunft/widget/widget_owner_list.dart';
import 'package:provider/provider.dart'; // Import de Provider
// import 'package:intl/intl.dart'; // Pour le formatage des dates et nombres

import 'package:kunft/pages/property_detail.dart'; // Pour la navigation vers les détails des logements
import 'package:kunft/widget/widget_animation2.dart';
import 'package:kunft/widget/widget_message_aleatoire.dart';

import 'package:kunft/widget/widget_house_infos2_bis.dart';
import 'package:kunft/widget/widget_house_infos_explore.dart';
import 'package:kunft/widget/widget_profile_infos.dart';

// Importez votre LogementProvider
import 'package:kunft/provider/logement_provider.dart'; // Correction du chemin si nécessaire

// Retirez les constantes API_BASE_URL et _dio, elles sont maintenant dans le Provider
// const String API_BASE_URL = 'http://127.0.0.1:8000'; // Déjà dans LogementProvider
// final Dio _dio = Dio();

// Retirez les helpers _getToken, _formatLogementData, _extractDataFromResponse,
// et les fonctions de fetch, elles sont maintenant dans le Provider

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  // ---- Ancien code ---
  // void initState() {
  //   super.initState();
  //   // Appelle la fonction de fetch du provider pour ExploreScreen
  //   // listen: false car nous ne voulons pas reconstruire le widget ici, juste appeler la fonction
  //   Provider.of<LogementProvider>(
  //     context,
  //     listen: false,
  //   ).fetchExploreScreenData();
  // }
  // -------- Nouveau Code --------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final logementProvider = Provider.of<LogementProvider>(
        context,
        listen: false,
      );
      final token = userProvider.authToken;

      if (token != null) {
        logementProvider.fetchExploreScreenData(token);
      } else {
        // Gérer le cas où le jeton n'est pas disponible, par exemple, en affichant un message d'erreur.
        print('Erreur: Jeton d\'authentification non trouvé.');
        logementProvider.setErrorMessage(
          'Veuillez vous connecter pour voir les données.',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Consomme les données du LogementProvider
    return Consumer<LogementProvider>(
      builder: (context, logementProvider, child) {
        // Accédez aux données et aux états de chargement via logementProvider
        final List<dynamic> latestLogements = logementProvider.latestLogements;
        final bool isLoadingLatest = logementProvider.isLoadingLatestLogements;
        final String? errorLatest = logementProvider.errorLatestLogements;

        final List<dynamic> trendingOwners = logementProvider.trendingOwners;
        final bool isLoadingOwners = logementProvider.isLoadingTrendingOwners;
        final String? errorOwners = logementProvider.errorTrendingOwners;

        final List<dynamic> recentSearches = logementProvider.recentSearches;
        final bool isLoadingRecent = logementProvider.isLoadingRecentSearches;
        final String? errorRecent = logementProvider.errorRecentSearches;

        // Préparer les colonnes pour les logements récemment recherchés
        List<Widget> colonneGWidgets = [];
        List<Widget> colonneDWidgets = [];

        // La boucle utilise recentSearches du provider
        for (int i = 0; i < recentSearches.length; i++) {
          final l = recentSearches[i];
          final formattedData = logementProvider.formatLogementData(
            l,
          ); // Utilisez le helper du provider

          final Widget houseWidget = Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetail(logementData: l),
                  ),
                );
              },
              child: WidgetHouseInfos2Bis(
                imgHouse: formattedData['imgUrl']!,
                houseName: formattedData['houseName']!,
                price: formattedData['price']!,
                locate: formattedData['locate']!,
                ownerName: formattedData['ownerName']!,
                time: formattedData['time']!,
                logementData: l,
              ),
            ),
          );

          if (i.isEven) {
            colonneGWidgets.add(houseWidget);
          } else {
            colonneDWidgets.add(houseWidget);
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xfff7f7f7),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Animation (si elle n'a pas besoin de données spécifiques de logement ici)
                          const WidgetAnimation2(
                            imageUrls:
                                [], // Remplacez par les vraies URLs si Animation2 en a besoin
                            initialImageUrl:
                                'https://www.freepik.com/free-photo/swimming-pool_1037896.htm#fromView=search&page=1&position=49&uuid=cb31a530-6c15-4a84-a79a-0ada78578303&query=maison+de+luxe',
                          ),
                          // Contenu superposé sur l'animation
                          SizedBox(
                            height: screenHeight * .3,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WidgetProfileInfos(),
                                Spacer(),
                                Column(
                                  children: [
                                    WidgetMessageAleatoire(),
                                    //
                                    SizedBox(height: 15),
                                    //
                                    // WidgetHouseInfosExplore: Affiche les 10 derniers logements
                                    // Non utile pour le moment
                                    // isLoadingLatest
                                    //     ? const SizedBox(
                                    //         height:
                                    //             150, // Hauteur fixe pour le CircularProgressIndicator
                                    //         child: Center(
                                    //           child:
                                    //               CircularProgressIndicator(),
                                    //         ),
                                    //       )
                                    //     : errorLatest != null
                                    //     ? SizedBox(
                                    //         height:
                                    //             150, // Hauteur fixe pour le message d'erreur
                                    //         child: Center(
                                    //           child: Text(
                                    //             'Erreur: $errorLatest',
                                    //             textAlign: TextAlign.center,
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : latestLogements.isEmpty
                                    //     ? const SizedBox(
                                    //         height:
                                    //             150, // Hauteur fixe pour le message 'aucun logement'
                                    //         child: Center(
                                    //           child: Text(
                                    //             'Aucun logement récent disponible',
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : SizedBox(
                                    //         // height:
                                    //         //     130, // Hauteur fixe pour les cartes
                                    //         child: Padding(
                                    //           padding:
                                    //               const EdgeInsets.symmetric(
                                    //                 horizontal: 10,
                                    //               ),
                                    //           child: SingleChildScrollView(
                                    //             scrollDirection:
                                    //                 Axis.horizontal,
                                    //             child: Row(
                                    //               children: latestLogements.map((
                                    //                 l,
                                    //               ) {
                                    //                 final formattedData =
                                    //                     logementProvider
                                    //                         .formatLogementData(
                                    //                           l,
                                    //                         );
                                    //                 return Padding(
                                    //                   padding:
                                    //                       const EdgeInsets.only(
                                    //                         right: 10.0,
                                    //                       ),
                                    //                   child: WidgetHouseInfosExplore(
                                    //                     imgHouse:
                                    //                         formattedData['imgUrl']!,
                                    //                     houseName:
                                    //                         formattedData['houseName']!,
                                    //                     price:
                                    //                         formattedData['price']!,
                                    //                     locate:
                                    //                         formattedData['locate']!,
                                    //                     ownerName:
                                    //                         formattedData['ownerName']!,
                                    //                     time:
                                    //                         formattedData['time']!,
                                    //                     logementData: l,
                                    //                   ),
                                    //                 );
                                    //               }).toList(),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    // //
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Column(
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth * .55,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.search, color: Colors.grey),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Chercher un Meublé',
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              backgroundColor: Colors.white,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.tune, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffd055),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.map_outlined),
                                      SizedBox(width: 10),
                                      InkWell(
                                        // onTap: () {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder:
                                        //           (context) =>
                                        //               const MapTestScreen(), // Page test
                                        //     ),
                                        //   );
                                        // },
                                        child: Text(
                                          'Google Map',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Ici tu dois d\'abord afficher selon la position et faire le filtre selon un rayon en km',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hôte disponibles',
                                style: TextStyle(
                                  color: Color(0xff010101),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'see all',
                                style: TextStyle(
                                  color: Color(0xffffd055),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // WidgetOwnerList: Affiche les propriétaires tendance
                          isLoadingOwners
                              ? const Center(child: CircularProgressIndicator())
                              : errorOwners != null
                              ? Center(
                                  child: Text(
                                    'Erreur: $errorOwners',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : trendingOwners.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Aucun propriétaire tendance disponible',
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: trendingOwners.map((owner) {
                                      // ✅ MODIFIÉ : Passe l'objet 'owner' complet à ownerData
                                      return WidgetOwnerList(
                                        withSpacing: true,
                                        ownerData: owner,
                                      );
                                    }).toList(),
                                  ),
                                ),
                          const SizedBox(height: 18),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recherche récentes',
                                style: TextStyle(
                                  color: Color(0xff010101),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'see all',
                                style: TextStyle(
                                  color: Color(0xffffd055),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // WidgetHouseInfos2Bis: Affiche les logements récemment recherchés
                      const SizedBox(height: 16),
                      isLoadingRecent
                          ? const Center(child: CircularProgressIndicator())
                          : errorRecent != null
                          ? Center(
                              child: Text(
                                'Erreur: $errorRecent',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : recentSearches.isEmpty
                          ? const Center(
                              child: Text(
                                'Aucun logement récemment recherché disponible.',
                              ),
                            )
                          : SizedBox(
                              height:
                                  (recentSearches.length / 2).ceil() * 270.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: (recentSearches.length / 2)
                                          .ceil(),
                                      itemBuilder: (context, index) {
                                        final l = recentSearches[index * 2];
                                        final formattedData = logementProvider
                                            .formatLogementData(l);
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PropertyDetail(
                                                        logementData: l,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: WidgetHouseInfos2Bis(
                                              imgHouse:
                                                  formattedData['imgUrl']!,
                                              houseName:
                                                  formattedData['houseName']!,
                                              price: formattedData['price']!,
                                              locate: formattedData['locate']!,
                                              ownerName:
                                                  formattedData['ownerName']!,
                                              time: formattedData['time']!,
                                              logementData: l,
                                            ),
                                          ),
                                        );
                                      },
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ), // Espace entre les Colonnes
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: (recentSearches.length / 2)
                                          .floor(),
                                      itemBuilder: (context, index) {
                                        final l = recentSearches[index * 2 + 1];
                                        final formattedData = logementProvider
                                            .formatLogementData(l);
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8.0,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PropertyDetail(
                                                        logementData: l,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: WidgetHouseInfos2Bis(
                                              imgHouse:
                                                  formattedData['imgUrl']!,
                                              houseName:
                                                  formattedData['houseName']!,
                                              price: formattedData['price']!,
                                              locate: formattedData['locate']!,
                                              ownerName:
                                                  formattedData['ownerName']!,
                                              time: formattedData['time']!,
                                              logementData: l,
                                            ),
                                          ),
                                        );
                                      },
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
