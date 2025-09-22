import 'package:flutter/material.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:kunft/widget/widget_empty_house.dart';
import 'package:provider/provider.dart'; // Import de Provider
import 'package:kunft/widget/widget_house_infos2_bis.dart';
import 'package:kunft/pages/property_detail.dart'; // Import pour la navigation vers les détails

// Importez votre LogementProvider
import 'package:kunft/provider/logement_provider.dart'; // Correction du chemin si nécessaire

class Apparts extends StatefulWidget {
  const Apparts({super.key});

  @override
  State<Apparts> createState() => _AppartsState();
}

class _AppartsState extends State<Apparts> {
  List<dynamic> _logements = []; // ✅ État local pour les logements de ce type
  bool _isLoading = true; // ✅ État de chargement local
  String? _errorMessage; // ✅ Message d'erreur local

  @override
  void initState() {
    super.initState();
    _fetchApparts(); // ✅ Appelle la fonction de fetch locale
  }

  // ✅ Fonction de fetch locale pour les appartements
  Future<void> _fetchApparts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Obtenez une instance du UserProvider pour récupérer le token
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.authToken;

      if (token == null) {
        throw Exception('Token non trouvé. Veuillez vous connecter.');
      }
      // Appelle la fonction du provider qui retourne la liste
      final data = await Provider.of<LogementProvider>(
        context,
        listen: false,
      ).fetchLogementsForType('Appartement', token);
      setState(() {
        _logements = data;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Erreur lors du chargement des appartements: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Impossible de charger les appartements : $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Consomme le provider uniquement pour le helper formatLogementData
    return Consumer<LogementProvider>(
      builder: (context, logementProvider, child) {
        // Accédez aux données et aux états de chargement via l'état local
        final List<dynamic> logements = _logements;
        final bool isLoading = _isLoading;
        final String? errorMessage = _errorMessage;

        return Scaffold(
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                ) // Indicateur de chargement
              : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : logements.isEmpty
              ? WidgetEmptyHouse(
                  message: 'Aucun Appartement disponible pour le moment.',
                )
              : Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ), // Padding général pour la grille
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 colonnes pour la grille
                      crossAxisSpacing: 8.0, // Espacement horizontal
                      mainAxisSpacing: 8.0, // Espacement vertical
                      childAspectRatio:
                          0.7, // Ajustez si nécessaire pour que les cartes s'affichent bien
                    ),
                    itemCount: logements.length,
                    itemBuilder: (context, index) {
                      final l = logements[index];

                      // Utilise le helper formatLogementData du provider
                      final formattedData = logementProvider.formatLogementData(
                        l,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyDetail(logementData: l),
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
                          logementData:
                              l, // Passez les données complètes du logement
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
