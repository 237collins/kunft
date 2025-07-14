import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kunft/widget/widget_animation2.dart'; // Importez le nouveau WidgetAnimation2
import 'package:kunft/widget/widget_house_image1.dart';
import 'package:kunft/widget/widget_house_image2.dart';
import 'package:kunft/widget/widget_house_text_infos2.dart';
import 'package:kunft/widget/widget_house_specs.dart';
import 'package:kunft/widget/widget_owner_profile.dart';
import 'package:kunft/widget/widget_property_top_nav_bar.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000';

class PropertyDetail extends StatefulWidget {
  final Map<String, dynamic> logementData;

  const PropertyDetail({super.key, required this.logementData});

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  // ✅ Plus besoin de GlobalKey pour WidgetAnimation2.
  // WidgetAnimation2 gérera son propre état interne.
  // final GlobalKey<WidgetAnimationStateApi> _animationKey = GlobalKey(); // SUPPRIMER CETTE LIGNE

  String? _currentlySelectedImageUrl;
  List<String> _allImageUrls = []; // Pour passer à WidgetAnimation2

  @override
  void initState() {
    super.initState();
    _extractAllImageUrls();
    // Définir l'image par défaut lors de l'initialisation
    if (_allImageUrls.isNotEmpty) {
      _currentlySelectedImageUrl = _allImageUrls[0];
    } else {
      _currentlySelectedImageUrl =
          'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';
    }
  }

  void _extractAllImageUrls() {
    _allImageUrls = [];
    if (widget.logementData['images'] is List) {
      for (var image in widget.logementData['images']) {
        if (image['image_path'] != null) {
          _allImageUrls.add('$API_BASE_URL/storage/${image['image_path']}');
        }
      }
    }
    // Ajoutez une image par défaut si la liste est vide
    if (_allImageUrls.isEmpty) {
      _allImageUrls.add(
        'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg',
      );
    }
  }

  // Callback pour les vignettes, met à jour l'image principale
  void _updateMainImageCallback(String imageUrl) {
    setState(() {
      _currentlySelectedImageUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> logement = widget.logementData;

    final String ownerName =
        (logement['user'] != null && logement['user']['name'] != null)
            ? '@${logement['user']['name'].toString().replaceAll(' ', '.').toLowerCase()}'
            : '@proprietaire.inconnu';

    String formattedPrice = 'N/A';
    if (logement['prix_par_nuit'] != null) {
      try {
        double price;
        if (logement['prix_par_nuit'] is String) {
          price = double.parse(logement['prix_par_nuit'] as String);
        } else if (logement['prix_par_nuit'] is num) {
          price = (logement['prix_par_nuit'] as num).toDouble();
        } else {
          throw FormatException(
            'Type de prix inattendu: ${logement['prix_par_nuit'].runtimeType}',
          );
        }
        formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
      } catch (e) {
        print('DEBUG: Erreur de formatage du prix dans PropertyDetail: $e');
        formattedPrice = 'Prix invalide';
      }
    }

    List<Widget> colonneGWidgets = [];
    List<Widget> colonneDWidgets = [];

    final List<dynamic> images = logement['images'] ?? [];

    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        final imgUrl = '$API_BASE_URL/storage/${image['image_path'] ?? ''}';

        final bool isSelected = (_currentlySelectedImageUrl == imgUrl);

        final imageWidget =
            i.isEven
                ? WidgetHouseImage1(
                  imgHouse: imgUrl,
                  houseName: logement['titre'] ?? 'Logement',
                  price: '$formattedPrice Fcfa',
                  locate: logement['adresse'] ?? '',
                  ownerName: ownerName,
                  time: logement['created_at'] ?? '',
                  onTapImage: _updateMainImageCallback,
                  isSelected: isSelected,
                )
                : WidgetHouseImage2(
                  imgHouse: imgUrl,
                  houseName: logement['titre'] ?? 'Logement',
                  price: '$formattedPrice Fcfa',
                  locate: logement['adresse'] ?? '',
                  ownerName: ownerName,
                  time: logement['created_at'] ?? '',
                  onTapImage: _updateMainImageCallback,
                  isSelected: isSelected,
                );

        if (i.isEven) {
          colonneGWidgets.add(imageWidget);
        } else {
          colonneDWidgets.add(imageWidget);
        }
      }
    } else {
      final defaultImgUrl =
          'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';
      colonneGWidgets.add(
        WidgetHouseImage1(
          imgHouse: defaultImgUrl,
          houseName: logement['titre'] ?? 'Logement',
          price: '$formattedPrice Fcfa',
          locate: logement['adresse'] ?? '',
          ownerName: ownerName,
          time: logement['created_at'] ?? '',
          onTapImage: (imageUrl) {
            /* Pas d'action pour le placeholder */
          },
          isSelected: (_currentlySelectedImageUrl == defaultImgUrl),
        ),
      );
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    String propertyCount = '0';
    if (logement['user'] != null &&
        logement['user']['logements_count'] != null) {
      propertyCount = logement['user']['logements_count'].toString();
    }

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // ✅ Utilisation du nouveau WidgetAnimation2
                          WidgetAnimation2(
                            imageUrls: _allImageUrls,
                            initialImageUrl:
                                _currentlySelectedImageUrl ?? _allImageUrls[0],
                          ),

                          SizedBox(
                            height: screenHeight * .47,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: WidgetPropertyTopNavBar(
                                    title: 'Détails',
                                  ),
                                ),
                                const Spacer(),
                                WidgetHouseTextInfos2(logementData: logement),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetHouseSpecs(
                              bed:
                                  logement['nombre_chambres']?.toString() ??
                                  'N/A',
                              bath:
                                  logement['nombre_douches']?.toString() ??
                                  'N/A',
                              wifi: logement['wifi'] == 1,
                              parking: logement['parking'] == 1,
                              generator: logement['groupe_electrogene'] == 1,
                              climatisation: logement['climatisation'] == 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Complete Images',
                            style: TextStyle(
                              color: Color(0xff010101),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      SizedBox(
                        height:
                            (colonneGWidgets.length > colonneDWidgets.length
                                ? colonneGWidgets.length * (220.0 + 8.0)
                                : colonneDWidgets.length * (305.0 + 8.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: colonneGWidgets.length,
                                itemBuilder:
                                    (context, index) => colonneGWidgets[index],
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: colonneDWidgets.length,
                                itemBuilder:
                                    (context, index) => colonneDWidgets[index],
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              height: 100,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: WidgetOwnerProfile(
                imgOwner:
                    (logement['user'] != null &&
                            logement['user']['profile_image'] != null)
                        ? '$API_BASE_URL/storage/${logement['user']['profile_image']}'
                        : 'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg?t=st=1752401142~exp=1752404742~hmac=6b43b692930935ffccf1b7b5d664b102f36c&w=1380',
                ownerName:
                    (logement['user'] != null &&
                            logement['user']['name'] != null)
                        ? logement['user']['name']
                        : 'Inconnu',
                // propertyCount: propertyCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
