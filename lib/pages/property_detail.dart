import 'package:flutter/material.dart';
import 'package:kunft/widget/Paiement/widget_bouton_commander.dart';
import 'package:kunft/widget/Paiement/widget_bouton_reservation.dart';
import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:photo_view_v3/photo_view.dart';
import 'package:photo_view_v3/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:kunft/widget/widget_animation2.dart';
import 'package:kunft/widget/widget_house_image1.dart';
import 'package:kunft/widget/widget_house_image2.dart';
import 'package:kunft/widget/widget_house_text_infos2.dart';
import 'package:kunft/widget/widget_house_specs.dart';
import 'package:kunft/widget/widget_owner_profile.dart';
import 'package:kunft/widget/widget_property_top_nav_bar.dart';
import 'package:kunft/provider/logement_provider.dart'
    show LogementProvider, API_BASE_URL;

class PropertyDetail extends StatefulWidget {
  final Map<String, dynamic> logementData;

  const PropertyDetail({super.key, required this.logementData});

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  String? _currentlySelectedImageUrl;
  List<String> _allImageUrls = [];
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _extractAllImageUrls();
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
    if (_allImageUrls.isEmpty) {
      _allImageUrls.add(
        'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg',
      );
    }
  }

  void _updateMainImageCallback(String imageUrl) {
    setState(() {
      _currentlySelectedImageUrl = imageUrl;
    });
  }

  void _showFullScreenImage(
    BuildContext context,
    List<String> imageUrls,
    int initialIndex,
  ) {
    // Créez un contrôleur de page avec l'index initial
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // ✅ CORRIGÉ : Utilisation de StatefulBuilder pour gérer l'état du compteur
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: [
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    final String imageUrl = imageUrls[index];
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(imageUrl),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
                    );
                  },
                  itemCount: imageUrls.length,
                  loadingBuilder:
                      (context, event) => Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value:
                                event == null
                                    ? 0
                                    : event.cumulativeBytesLoaded /
                                        (event.expectedTotalBytes ?? 1),
                          ),
                        ),
                      ),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  pageController: pageController,
                  // ✅ NOUVEAU : Écouteur pour mettre à jour l'index de page
                  onPageChanged: (int index) {
                    setState(() {
                      initialIndex = index;
                    });
                  },
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // Ajout du compteur de page
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      '${initialIndex + 1} / ${imageUrls.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogementProvider>(
      builder: (context, logementProvider, child) {
        final Map<String, dynamic> logement = widget.logementData;
        final formattedLogementData = logementProvider.formatLogementData(
          logement,
        );
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
                      houseName: formattedLogementData['houseName']!,
                      price: formattedLogementData['price']!,
                      locate: formattedLogementData['locate']!,
                      ownerName: formattedLogementData['ownerName']!,
                      time: formattedLogementData['time']!,
                      onTapImage: _updateMainImageCallback,
                      isSelected: isSelected,
                    )
                    : WidgetHouseImage2(
                      imgHouse: imgUrl,
                      houseName: formattedLogementData['houseName']!,
                      price: formattedLogementData['price']!,
                      locate: formattedLogementData['locate']!,
                      ownerName: formattedLogementData['ownerName']!,
                      time: formattedLogementData['time']!,
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
              houseName: formattedLogementData['houseName']!,
              price: formattedLogementData['price']!,
              locate: formattedLogementData['locate']!,
              ownerName: formattedLogementData['ownerName']!,
              time: formattedLogementData['time']!,
              onTapImage: (imageUrl) {},
              isSelected: (_currentlySelectedImageUrl == defaultImgUrl),
            ),
          );
        }

        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final String description =
            logement['description'] ?? 'Aucune description disponible.';
        final bool showSeeMoreButton = (description.length > 100);

        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                // ✅ CORRIGÉ : Ajout du GestureDetector pour la vue en plein écran
                                GestureDetector(
                                  onTap: () {
                                    if (_currentlySelectedImageUrl != null) {
                                      int initialIndex = _allImageUrls.indexOf(
                                        _currentlySelectedImageUrl!,
                                      );
                                      if (initialIndex != -1) {
                                        _showFullScreenImage(
                                          context,
                                          _allImageUrls,
                                          initialIndex,
                                        );
                                      }
                                    }
                                  },
                                  child: WidgetAnimation2(
                                    imageUrls: _allImageUrls,
                                    initialImageUrl:
                                        _currentlySelectedImageUrl ??
                                        _allImageUrls[0],
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * .47,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Expanded(
                                        child: WidgetPropertyTopNavBar(
                                          title: ' ',
                                        ),
                                      ),
                                      const Spacer(),
                                      WidgetHouseTextInfos2(
                                        logementData: logement,
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetHouseSpecs(
                                    bed:
                                        logement['nombre_chambres']
                                            ?.toString() ??
                                        'N/A',
                                    bath:
                                        logement['nombre_douches']
                                            ?.toString() ??
                                        'N/A',
                                    wifi: logement['wifi'] == 1,
                                    parking: logement['parking'] == 1,
                                    generator:
                                        logement['groupe_electrogene'] == 1,
                                    climatisation:
                                        logement['climatisation'] == 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 10),
                      Stack(
                        children: [
                          //
                          Container(
                            height: 7,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black12, Colors.transparent],
                              ),
                            ),
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: screenHeight * .35,
                              // decoration: BoxDecoration(color: Colors.pinkAccent),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      SizedBox(
                                        width: screenWidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Description',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (showSeeMoreButton)
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isDescriptionExpanded =
                                                        !_isDescriptionExpanded;
                                                  });
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 5,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          9,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    _isDescriptionExpanded
                                                        ? 'Voir moins'
                                                        : 'Voir plus',
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        description,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff404040),
                                        ),
                                        maxLines:
                                            _isDescriptionExpanded ? null : 2,
                                        overflow:
                                            _isDescriptionExpanded
                                                ? TextOverflow.visible
                                                : TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Images Complètes',
                                        style: TextStyle(
                                          color: Color(0xff010101),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      //
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(LucideIcons.map, size: 17),
                                            SizedBox(width: 6),
                                            Text(
                                              'Google Maps',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    height:
                                        (colonneGWidgets.length >
                                                    colonneDWidgets.length
                                                ? colonneGWidgets.length *
                                                    (220.0 + 8.0)
                                                : colonneDWidgets.length *
                                                    (305.0 + 8.0))
                                            .toDouble(),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: colonneGWidgets.length,
                                            itemBuilder:
                                                (context, index) =>
                                                    colonneGWidgets[index],
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: colonneDWidgets.length,
                                            itemBuilder:
                                                (context, index) =>
                                                    colonneDWidgets[index],
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
                      // const SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  height: 90,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Color(0xe6ffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, -2),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetOwnerProfile(
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
                        // ✅ MODIFIÉ : Passez la variable logement ici
                        houseInfosWidget: WidgetHouseInfos3Bis(
                          logementData: logement,
                        ),
                      ),
                      // Bouton action de paiement
                      Row(
                        children: [
                          WidgetBoutonCommander(
                            // ✅ MODIFIÉ : Passage des données du logement au bouton
                            logementData: widget.logementData,
                          ),
                          const SizedBox(width: 15),
                          WidgetBoutonReservation(
                            logementData:
                                widget
                                    .logementData, // ✅ Ici, vous passez les données du logement
                          ),
                        ],
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

// ------- Ancien code avec full view de l'image

// import 'package:flutter/material.dart';
// import 'package:kunft/widget/Paiement/widget_bouton_commander.dart';
// import 'package:kunft/widget/Paiement/widget_bouton_reservation.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:photo_view_v3/photo_view.dart';
// import 'package:provider/provider.dart';

// import 'package:kunft/widget/widget_animation2.dart';
// import 'package:kunft/widget/widget_house_image1.dart';
// import 'package:kunft/widget/widget_house_image2.dart';
// import 'package:kunft/widget/widget_house_text_infos2.dart';
// import 'package:kunft/widget/widget_house_specs.dart';
// import 'package:kunft/widget/widget_owner_profile.dart';
// import 'package:kunft/widget/widget_property_top_nav_bar.dart';
// import 'package:kunft/provider/logement_provider.dart'
//     show LogementProvider, API_BASE_URL;

// class PropertyDetail extends StatefulWidget {
//   final Map<String, dynamic> logementData;

//   const PropertyDetail({super.key, required this.logementData});

//   @override
//   State<PropertyDetail> createState() => _PropertyDetailState();
// }

// class _PropertyDetailState extends State<PropertyDetail> {
//   String? _currentlySelectedImageUrl;
//   List<String> _allImageUrls = [];
//   bool _isDescriptionExpanded = false;

//   @override
//   void initState() {
//     super.initState();
//     _extractAllImageUrls();
//     if (_allImageUrls.isNotEmpty) {
//       _currentlySelectedImageUrl = _allImageUrls[0];
//     } else {
//       _currentlySelectedImageUrl =
//           'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';
//     }
//   }

//   void _extractAllImageUrls() {
//     _allImageUrls = [];
//     if (widget.logementData['images'] is List) {
//       for (var image in widget.logementData['images']) {
//         if (image['image_path'] != null) {
//           _allImageUrls.add('$API_BASE_URL/storage/${image['image_path']}');
//         }
//       }
//     }
//     if (_allImageUrls.isEmpty) {
//       _allImageUrls.add(
//         'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg',
//       );
//     }
//   }

//   void _updateMainImageCallback(String imageUrl) {
//     setState(() {
//       _currentlySelectedImageUrl = imageUrl;
//     });
//   }

//   // ✅ NOUVEAU: Fonction pour afficher l'image en plein écran
//   void _showFullScreenImage(BuildContext context, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Stack(
//           children: [
//             PhotoView(
//               imageProvider: NetworkImage(imageUrl),
//               minScale: PhotoViewComputedScale.contained,
//               maxScale: PhotoViewComputedScale.covered * 2,
//               heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
//             ),
//             Positioned(
//               top: 40,
//               right: 10,
//               child: IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white, size: 30),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LogementProvider>(
//       builder: (context, logementProvider, child) {
//         final Map<String, dynamic> logement = widget.logementData;
//         final formattedLogementData = logementProvider.formatLogementData(
//           logement,
//         );
//         List<Widget> colonneGWidgets = [];
//         List<Widget> colonneDWidgets = [];
//         final List<dynamic> images = logement['images'] ?? [];

//         if (images.isNotEmpty) {
//           for (int i = 0; i < images.length; i++) {
//             final image = images[i];
//             final imgUrl = '$API_BASE_URL/storage/${image['image_path'] ?? ''}';
//             final bool isSelected = (_currentlySelectedImageUrl == imgUrl);
//             final imageWidget =
//                 i.isEven
//                     ? WidgetHouseImage1(
//                       imgHouse: imgUrl,
//                       houseName: formattedLogementData['houseName']!,
//                       price: formattedLogementData['price']!,
//                       locate: formattedLogementData['locate']!,
//                       ownerName: formattedLogementData['ownerName']!,
//                       time: formattedLogementData['time']!,
//                       onTapImage: _updateMainImageCallback,
//                       isSelected: isSelected,
//                     )
//                     : WidgetHouseImage2(
//                       imgHouse: imgUrl,
//                       houseName: formattedLogementData['houseName']!,
//                       price: formattedLogementData['price']!,
//                       locate: formattedLogementData['locate']!,
//                       ownerName: formattedLogementData['ownerName']!,
//                       time: formattedLogementData['time']!,
//                       onTapImage: _updateMainImageCallback,
//                       isSelected: isSelected,
//                     );
//             if (i.isEven) {
//               colonneGWidgets.add(imageWidget);
//             } else {
//               colonneDWidgets.add(imageWidget);
//             }
//           }
//         } else {
//           final defaultImgUrl =
//               'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';
//           colonneGWidgets.add(
//             WidgetHouseImage1(
//               imgHouse: defaultImgUrl,
//               houseName: formattedLogementData['houseName']!,
//               price: formattedLogementData['price']!,
//               locate: formattedLogementData['locate']!,
//               ownerName: formattedLogementData['ownerName']!,
//               time: formattedLogementData['time']!,
//               onTapImage: (imageUrl) {},
//               isSelected: (_currentlySelectedImageUrl == defaultImgUrl),
//             ),
//           );
//         }

//         final screenHeight = MediaQuery.of(context).size.height;
//         final screenWidth = MediaQuery.of(context).size.width;
//         final String description =
//             logement['description'] ?? 'Aucune description disponible.';
//         final bool showSeeMoreButton = (description.length > 100);

//         return Scaffold(
//           body: Stack(
//             children: [
//               Column(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(10),
//                         child: Column(
//                           children: [
//                             Stack(
//                               children: [
//                                 // ✅ MODIFIÉ : Ajout du GestureDetector pour la vue en plein écran
//                                 GestureDetector(
//                                   onTap: () {
//                                     if (_currentlySelectedImageUrl != null) {
//                                       _showFullScreenImage(
//                                         context,
//                                         _currentlySelectedImageUrl!,
//                                       );
//                                     }
//                                   },
//                                   child: WidgetAnimation2(
//                                     imageUrls: _allImageUrls,
//                                     initialImageUrl:
//                                         _currentlySelectedImageUrl ??
//                                         _allImageUrls[0],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: screenHeight * .47,
//                                   child: Column(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Expanded(
//                                         child: WidgetPropertyTopNavBar(
//                                           title: ' ',
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       WidgetHouseTextInfos2(
//                                         logementData: logement,
//                                       ),
//                                       const SizedBox(height: 20),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   WidgetHouseSpecs(
//                                     bed:
//                                         logement['nombre_chambres']
//                                             ?.toString() ??
//                                         'N/A',
//                                     bath:
//                                         logement['nombre_douches']
//                                             ?.toString() ??
//                                         'N/A',
//                                     wifi: logement['wifi'] == 1,
//                                     parking: logement['parking'] == 1,
//                                     generator:
//                                         logement['groupe_electrogene'] == 1,
//                                     climatisation:
//                                         logement['climatisation'] == 1,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // const SizedBox(height: 10),
//                       Stack(
//                         children: [
//                           //
//                           Container(
//                             height: 50,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20),
//                               ),
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [Colors.black12, Colors.transparent],
//                               ),
//                             ),
//                           ),
//                           //
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: SizedBox(
//                               height: screenHeight * .35,
//                               // decoration: BoxDecoration(color: Colors.pinkAccent),
//                               child: ListView(
//                                 padding: EdgeInsets.zero,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(height: 5),
//                                       SizedBox(
//                                         width: screenWidth,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const Text(
//                                               'Description',
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Colors.black87,
//                                               ),
//                                             ),
//                                             if (showSeeMoreButton)
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     _isDescriptionExpanded =
//                                                         !_isDescriptionExpanded;
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         horizontal: 8,
//                                                         vertical: 5,
//                                                       ),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.blue,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           15,
//                                                         ),
//                                                   ),
//                                                   child: Text(
//                                                     _isDescriptionExpanded
//                                                         ? 'Voir moins'
//                                                         : 'Voir plus',
//                                                     style: const TextStyle(
//                                                       fontSize: 10,
//                                                       fontWeight:
//                                                           FontWeight.w800,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         description,
//                                         style: const TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w400,
//                                           color: Color(0xff404040),
//                                         ),
//                                         maxLines:
//                                             _isDescriptionExpanded ? null : 2,
//                                         overflow:
//                                             _isDescriptionExpanded
//                                                 ? TextOverflow.visible
//                                                 : TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 15),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Images Complètes',
//                                         style: TextStyle(
//                                           color: Color(0xff010101),
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       //
//                                       Container(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: 15,
//                                           vertical: 10,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: Colors.amber,
//                                           borderRadius: BorderRadius.circular(
//                                             30,
//                                           ),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Icon(LucideIcons.map, size: 17),
//                                             SizedBox(width: 6),
//                                             Text(
//                                               'Google Maps',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 14),
//                                   SizedBox(
//                                     height:
//                                         (colonneGWidgets.length >
//                                                     colonneDWidgets.length
//                                                 ? colonneGWidgets.length *
//                                                     (220.0 + 8.0)
//                                                 : colonneDWidgets.length *
//                                                     (305.0 + 8.0))
//                                             .toDouble(),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: ListView.builder(
//                                             padding: EdgeInsets.zero,
//                                             itemCount: colonneGWidgets.length,
//                                             itemBuilder:
//                                                 (context, index) =>
//                                                     colonneGWidgets[index],
//                                             shrinkWrap: true,
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         Expanded(
//                                           child: ListView.builder(
//                                             padding: EdgeInsets.zero,
//                                             itemCount: colonneDWidgets.length,
//                                             itemBuilder:
//                                                 (context, index) =>
//                                                     colonneDWidgets[index],
//                                             shrinkWrap: true,
//                                             physics:
//                                                 const NeverScrollableScrollPhysics(),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       // const SizedBox(height: 100),
//                     ],
//                   ),
//                 ],
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: Container(
//                   padding: const EdgeInsets.only(
//                     bottom: 20,
//                     top: 10,
//                     left: 10,
//                     right: 10,
//                   ),
//                   height: 100,
//                   width: screenWidth,
//                   decoration: BoxDecoration(
//                     color: Color(0xe6ffffff),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         offset: Offset(0, -2),
//                         blurRadius: 12,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       WidgetOwnerProfile(
//                         imgOwner:
//                             (logement['user'] != null &&
//                                     logement['user']['profile_image'] != null)
//                                 ? '$API_BASE_URL/storage/${logement['user']['profile_image']}'
//                                 : 'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg?t=st=1752401142~exp=1752404742~hmac=6b43b692930935ffccf1b7b5d664b102f36c&w=1380',
//                         ownerName:
//                             (logement['user'] != null &&
//                                     logement['user']['name'] != null)
//                                 ? logement['user']['name']
//                                 : 'Inconnu',
//                         // ✅ MODIFIÉ : Passez la variable logement ici
//                         houseInfosWidget: WidgetHouseInfos3Bis(
//                           logementData: logement,
//                         ),
//                       ),
//                       // Bouton action de paiement
//                       Row(
//                         children: [
//                           WidgetBoutonCommander(
//                             // ✅ MODIFIÉ : Passage des données du logement au bouton
//                             logementData: widget.logementData,
//                           ),
//                           const SizedBox(width: 15),
//                           WidgetBoutonReservation(
//                             logementData:
//                                 widget
//                                     .logementData, // ✅ Ici, vous passez les données du logement
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// Ancien code

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:kunft/widget/widget_animation2.dart';
// import 'package:kunft/widget/widget_house_image1.dart';
// import 'package:kunft/widget/widget_house_image2.dart';
// import 'package:kunft/widget/widget_house_text_infos2.dart';
// import 'package:kunft/widget/widget_house_specs.dart';
// import 'package:kunft/widget/widget_owner_profile.dart';
// import 'package:kunft/widget/widget_property_top_nav_bar.dart';

// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class PropertyDetail extends StatefulWidget {
//   final Map<String, dynamic> logementData;

//   const PropertyDetail({super.key, required this.logementData});

//   @override
//   State<PropertyDetail> createState() => _PropertyDetailState();
// }

// class _PropertyDetailState extends State<PropertyDetail> {
//   String? _currentlySelectedImageUrl;
//   List<String> _allImageUrls = [];
//   bool _isDescriptionExpanded = false; // Variable d'état pour la description

//   @override
//   void initState() {
//     super.initState();
//     _extractAllImageUrls();
//     if (_allImageUrls.isNotEmpty) {
//       _currentlySelectedImageUrl = _allImageUrls[0];
//     } else {
//       _currentlySelectedImageUrl =
//           'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';
//     }
//   }

//   void _extractAllImageUrls() {
//     _allImageUrls = [];
//     if (widget.logementData['images'] is List) {
//       for (var image in widget.logementData['images']) {
//         if (image['image_path'] != null) {
//           _allImageUrls.add('$API_BASE_URL/storage/${image['image_path']}');
//         }
//       }
//     }
//     if (_allImageUrls.isEmpty) {
//       _allImageUrls.add(
//         'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg',
//       );
//     }
//   }

//   void _updateMainImageCallback(String imageUrl) {
//     setState(() {
//       _currentlySelectedImageUrl = imageUrl;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> logement = widget.logementData;

//     final String ownerName =
//         (logement['user'] != null && logement['user']['name'] != null)
//             ? '@${logement['user']['name'].toString().replaceAll(' ', '.').toLowerCase()}'
//             : '@proprietaire.inconnu';

//     String formattedPrice = 'N/A';
//     if (logement['prix_par_nuit'] != null) {
//       try {
//         double price;
//         if (logement['prix_par_nuit'] is String) {
//           price = double.parse(logement['prix_par_nuit'] as String);
//         } else if (logement['prix_par_nuit'] is num) {
//           price = (logement['prix_par_nuit'] as num).toDouble();
//         } else {
//           throw FormatException(
//             'Type de prix inattendu: ${logement['prix_par_nuit'].runtimeType}',
//           );
//         }
//         formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
//       } catch (e) {
//         print('DEBUG: Erreur de formatage du prix dans PropertyDetail: $e');
//         formattedPrice = 'Prix invalide';
//       }
//     }

//     List<Widget> colonneGWidgets = [];
//     List<Widget> colonneDWidgets = [];

//     final List<dynamic> images = logement['images'] ?? [];

//     if (images.isNotEmpty) {
//       for (int i = 0; i < images.length; i++) {
//         final image = images[i];
//         final imgUrl = '$API_BASE_URL/storage/${image['image_path'] ?? ''}';

//         final bool isSelected = (_currentlySelectedImageUrl == imgUrl);

//         final imageWidget =
//             i.isEven
//                 ? WidgetHouseImage1(
//                   imgHouse: imgUrl,
//                   houseName: logement['titre'] ?? 'Logement',
//                   price: '$formattedPrice Fcfa',
//                   locate: logement['adresse'] ?? '',
//                   ownerName: ownerName,
//                   time: logement['created_at'] ?? '',
//                   onTapImage: _updateMainImageCallback,
//                   isSelected: isSelected,
//                 )
//                 : WidgetHouseImage2(
//                   imgHouse: imgUrl,
//                   houseName: logement['titre'] ?? 'Logement',
//                   price: '$formattedPrice Fcfa',
//                   locate: logement['adresse'] ?? '',
//                   ownerName: ownerName,
//                   time: logement['created_at'] ?? '',
//                   onTapImage: _updateMainImageCallback,
//                   isSelected: isSelected,
//                 );

//         if (i.isEven) {
//           colonneGWidgets.add(imageWidget);
//         } else {
//           colonneDWidgets.add(imageWidget);
//         }
//       }
//     } else {
//       final defaultImgUrl =
//           'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';
//       colonneGWidgets.add(
//         WidgetHouseImage1(
//           imgHouse: defaultImgUrl,
//           houseName: logement['titre'] ?? 'Logement',
//           price: '$formattedPrice Fcfa',
//           locate: logement['adresse'] ?? '',
//           ownerName: ownerName,
//           time: logement['created_at'] ?? '',
//           onTapImage: (imageUrl) {
//             /* Pas d'action pour le placeholder */
//           },
//           isSelected: (_currentlySelectedImageUrl == defaultImgUrl),
//         ),
//       );
//     }

//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     String propertyCount = '0';
//     if (logement['user'] != null &&
//         logement['user']['logements_count'] != null) {
//       propertyCount = logement['user']['logements_count'].toString();
//     }

//     final String description =
//         logement['description'] ?? 'Aucune description disponible.';

//     // ✅ Nouvelle logique pour déterminer si "Voir plus" est nécessaire, basée sur la longueur du texte.
//     // Cette valeur est arbitraire, ajustez-la en fonction de la longueur moyenne de vos descriptions.
//     final bool showSeeMoreButton =
//         (description.length > 100); // Par exemple, si plus de 100 caractères.

//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Stack(
//                       children: [
//                         WidgetAnimation2(
//                           imageUrls: _allImageUrls,
//                           initialImageUrl:
//                               _currentlySelectedImageUrl ?? _allImageUrls[0],
//                         ),
//                         SizedBox(
//                           height: screenHeight * .47,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Expanded(
//                                 child: WidgetPropertyTopNavBar(
//                                   title: 'Détails',
//                                 ),
//                               ),
//                               const Spacer(),
//                               WidgetHouseTextInfos2(logementData: logement),
//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           WidgetHouseSpecs(
//                             bed:
//                                 logement['nombre_chambres']?.toString() ??
//                                 'N/A',
//                             bath:
//                                 logement['nombre_douches']?.toString() ?? 'N/A',
//                             wifi: logement['wifi'] == 1,
//                             parking: logement['parking'] == 1,
//                             generator: logement['groupe_electrogene'] == 1,
//                             climatisation: logement['climatisation'] == 1,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       height: screenHeight * .30,
//                       child: ListView(
//                         padding: EdgeInsets.zero,
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               // --- ✅ Début de la partie DESCRIPTION AJUSTÉE ---
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(
//                                     width: screenWidth,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const Text(
//                                           'Description',
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w700,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                         // Afficher "Voir plus" seulement si le texte est potentiellement long
//                                         if (showSeeMoreButton) // ✅ Condition d'affichage basée sur la longueur du texte
//                                           GestureDetector(
//                                             onTap: () {
//                                               setState(() {
//                                                 _isDescriptionExpanded =
//                                                     !_isDescriptionExpanded; // Bascule l'état
//                                               });
//                                             },
//                                             child: Container(
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: 8,
//                                                 vertical: 5,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.blue,
//                                                 borderRadius:
//                                                     BorderRadius.circular(9),
//                                               ),
//                                               child: Text(
//                                                 _isDescriptionExpanded
//                                                     ? 'Voir moins'
//                                                     : 'Voir plus', // Texte dynamique
//                                                 style: const TextStyle(
//                                                   fontSize: 10,
//                                                   fontWeight: FontWeight.w800,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     description,
//                                     style: const TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w400,
//                                       color: Color(0xff404040),
//                                     ),
//                                     maxLines:
//                                         _isDescriptionExpanded
//                                             ? null
//                                             : 2, // ✅ Utilise _isDescriptionExpanded
//                                     overflow:
//                                         _isDescriptionExpanded
//                                             ? TextOverflow.visible
//                                             : TextOverflow
//                                                 .ellipsis, // ✅ Utilise _isDescriptionExpanded
//                                   ),
//                                 ],
//                               ),

//                               // --- ✅ Fin de la partie DESCRIPTION AJUSTÉE ---
//                               const SizedBox(height: 15),
//                               const Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Images Complètes',
//                                     style: TextStyle(
//                                       color: Color(0xff010101),
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 14),
//                               // Affichage des logement
//                               SizedBox(
//                                 height:
//                                     (colonneGWidgets.length >
//                                                 colonneDWidgets.length
//                                             ? colonneGWidgets.length *
//                                                 (220.0 + 8.0)
//                                             : colonneDWidgets.length *
//                                                 (305.0 + 8.0))
//                                         .toDouble(),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: ListView.builder(
//                                         padding: EdgeInsets.zero,
//                                         itemCount: colonneGWidgets.length,
//                                         itemBuilder:
//                                             (context, index) =>
//                                                 colonneGWidgets[index],
//                                         shrinkWrap: true,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Expanded(
//                                       child: ListView.builder(
//                                         padding: EdgeInsets.zero,
//                                         itemCount: colonneDWidgets.length,
//                                         itemBuilder:
//                                             (context, index) =>
//                                                 colonneDWidgets[index],
//                                         shrinkWrap: true,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 100),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           // Ancien Bottom infos
//           Positioned(
//             bottom: 0,
//             child: Container(
//               padding: const EdgeInsets.only(
//                 bottom: 20,
//                 top: 10,
//                 left: 10,
//                 right: 10,
//               ),
//               height: 100,
//               width: screenWidth,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     offset: Offset(0, -2),
//                     blurRadius: 12,
//                     spreadRadius: 2,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               child: WidgetOwnerProfile(
//                 imgOwner:
//                     (logement['user'] != null &&
//                             logement['user']['profile_image'] != null)
//                         ? '$API_BASE_URL/storage/${logement['user']['profile_image']}'
//                         : 'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg?t=st=1752401142~exp=1752404742~hmac=6b43b692930935ffccf1b7b5d664b102f36c&w=1380',
//                 ownerName:
//                     (logement['user'] != null &&
//                             logement['user']['name'] != null)
//                         ? logement['user']['name']
//                         : 'Inconnu',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
