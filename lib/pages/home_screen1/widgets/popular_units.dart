import 'package:flutter/material.dart';
import 'package:kunft/pages/list_logement_populaire.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:kunft/provider/logement_provider.dart';
import 'package:kunft/widget/widget_popular_house_infos.dart';
import 'package:provider/provider.dart';

class PopularUnits extends StatefulWidget {
  const PopularUnits({super.key});

  @override
  State<PopularUnits> createState() => _PopularUnitsState();
}

class _PopularUnitsState extends State<PopularUnits> {
  @override
  void initState() {
    super.initState();
    // Utilise addPostFrameCallback pour s'assurer que la fonction de
    // chargement est appelée après le premier rendu du widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final logementProvider = Provider.of<LogementProvider>(
        context,
        listen: false,
      );

      final token = userProvider.authToken;

      if (token != null) {
        logementProvider.fetchHomeScreenData(token);
      } else {
        // Optionnel : Gérer le cas où le jeton n'est pas disponible,
        print('Erreur: Jeton d\'authentification non trouvé.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Le Consumer doit envelopper le widget qui utilise les données du provider.
    return Consumer<LogementProvider>(
      // J'ai renommé le deuxième argument pour plus de clarté (providerData)
      builder: (context, logementProvider, child) {
        // Les variables du provider sont ACCESSIBLES ici.
        final List<dynamic> popularLogements =
            logementProvider.popularLogements;
        final bool isLoadingPopularLogements =
            logementProvider.isLoadingPopularLogements;
        final String? errorPopularLogements =
            logementProvider.errorPopularLogements;

        // Le corps du widget est retourné directement par le builder
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Ajout pour aligner le titre
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Logement Populaire',
                  style: TextStyle(
                    color: Color(0xff010101),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListLogementPopulaire(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF256AFD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Affichage conditionnel basé sur l'état du provider
            isLoadingPopularLogements
                ? const Center(child: CircularProgressIndicator())
                : errorPopularLogements != null
                ? Center(
                    child: Text(
                      'Erreur: $errorPopularLogements',
                      textAlign: TextAlign.center,
                    ),
                  )
                : popularLogements.isEmpty
                ? const Center(
                    child: Text('Aucun logement populaire disponible.'),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: 130,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: popularLogements.map((l) {
                          final formattedData = logementProvider
                              .formatLogementData(l);
                          return WidgetPopularHouseInfos(
                            imgHouse: formattedData['imgUrl']!,
                            houseName: formattedData['houseName']!,
                            price: formattedData['price']!,
                            locate: formattedData['locate']!,
                            ownerName: formattedData['ownerName']!,
                            time: formattedData['time']!,
                            logementData: l,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ],
        );
      },
      // Le 'child' (troisième argument du builder) n'est pas utilisé ici,
      // donc il est omis ou laissé à null.
    );
  }
}
