// ---- Nouveau code okay

import 'package:flutter/material.dart';
import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:kunft/pages/property_detail.dart';
import 'package:kunft/provider/logement_provider.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000';

class WidgetAnimation extends StatefulWidget {
  const WidgetAnimation({super.key});

  @override
  State<WidgetAnimation> createState() => _WidgetAnimationState();
}

class _WidgetAnimationState extends State<WidgetAnimation> {
  int _currentIndex = 0;
  Timer? _timer;
  List<String> _imageUrls = [];
  String? _currentDisplayImageUrl;

  // On ne gère plus les données ici, elles viennent du provider

  @override
  void initState() {
    super.initState();
    // On ne fait rien ici car les données sont gérées par le Consumer
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _extractAndPrepareImages(Map<String, dynamic>? logementData) {
    _imageUrls = [];
    if (logementData != null && logementData['images'] is List) {
      for (var image in logementData['images']) {
        if (image['image_path'] != null) {
          _imageUrls.add('$API_BASE_URL/storage/${image['image_path']}');
        }
      }
    }

    if (_imageUrls.isEmpty) {
      _imageUrls.add(
        'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg',
      );
    }

    if (_currentIndex >= _imageUrls.length || _imageUrls.isEmpty) {
      _currentIndex = 0;
    }
  }

  void _setInitialDisplayImage() {
    if (_imageUrls.isNotEmpty) {
      _currentDisplayImageUrl = _imageUrls[0];
      _currentIndex = 0;
    } else {
      _currentDisplayImageUrl = null;
    }
  }

  void _startImageAutoScroll() {
    _stopTimer();
    if (_imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _imageUrls.length;
          _currentDisplayImageUrl = _imageUrls[_currentIndex];
        });
      });
    }
  }

  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _navigateToPropertyDetail(Map<String, dynamic> logementData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetail(logementData: logementData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<LogementProvider>(
      builder: (context, logementProvider, child) {
        if (logementProvider.isLoadingLastLogement) {
          return _buildLoadingState(screenHeight);
        }

        if (logementProvider.errorLastLogement != null) {
          return _buildErrorState(
            screenHeight,
            logementProvider.errorLastLogement!,
          );
        }

        final lastLogement = logementProvider.lastLogement;

        if (lastLogement == null) {
          return _buildNoDataState(screenHeight);
        }

        // On s'assure que la logique d'images est appelée avec les dernières données
        _extractAndPrepareImages(lastLogement);
        if (_currentDisplayImageUrl == null) {
          _setInitialDisplayImage();
          _startImageAutoScroll();
        }

        return GestureDetector(
          onTap: () => _navigateToPropertyDetail(lastLogement),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcherPlus.zoomOut(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  key: ValueKey<String>(
                    _currentDisplayImageUrl ?? 'default_key',
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: screenHeight * .47,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Image.network(
                            _currentDisplayImageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('Erreur de chargement d\'image'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.only(right: 10),
                          height: screenHeight * .17,
                          width: screenWidth * .95,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color(0xbf000000)],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Positioned(
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: List.generate(_imageUrls.length, (
                                  index,
                                ) {
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          (_currentIndex == index)
                                              ? Colors.white
                                              : const Color(0x66ffffff),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
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

  // Fonctions d'aide pour l'affichage de l'état
  Widget _buildLoadingState(double screenHeight) {
    return Container(
      height: screenHeight * .47,
      decoration: _getBoxDecoration(),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(double screenHeight, String error) {
    return Container(
      height: screenHeight * .47,
      decoration: _getBoxDecoration(),
      child: Center(
        child: Text(
          'Erreur: $error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildNoDataState(double screenHeight) {
    return Container(
      height: screenHeight * .47,
      decoration: _getBoxDecoration(),
      child: const Center(
        child: Text(
          'Aucun logement récent disponible.',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[300],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    );
  }
}

// -- Ancien Code independant

// import 'package:flutter/material.dart';
// import 'package:animated_switcher_plus/animated_switcher_plus.dart';
// import 'dart:async';

// import 'package:kunft/pages/property_detail.dart';

// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class WidgetAnimation extends StatefulWidget {
//   final Map<String, dynamic>? logementData;

//   const WidgetAnimation({super.key, this.logementData});

//   @override
//   State<WidgetAnimation> createState() => _WidgetAnimationState();
// }

// class _WidgetAnimationState extends State<WidgetAnimation> {
//   int _currentIndex = 0;
//   Timer? _timer;
//   List<String> _imageUrls = [];
//   String? _currentDisplayImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _extractAndPrepareImages();
//     _setInitialDisplayImage();
//     _startImageAutoScroll();
//   }

//   @override
//   void didUpdateWidget(covariant WidgetAnimation oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.logementData != oldWidget.logementData) {
//       _extractAndPrepareImages();
//       _setInitialDisplayImage();
//       _startImageAutoScroll();
//     }
//   }

//   void _extractAndPrepareImages() {
//     _imageUrls = [];
//     if (widget.logementData != null && widget.logementData!['images'] is List) {
//       for (var image in widget.logementData!['images']) {
//         if (image['image_path'] != null) {
//           _imageUrls.add('$API_BASE_URL/storage/${image['image_path']}');
//         }
//       }
//     }

//     if (_imageUrls.isEmpty) {
//       _imageUrls.add(
//         'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg',
//       );
//     }

//     if (_currentIndex >= _imageUrls.length || _imageUrls.isEmpty) {
//       _currentIndex = 0;
//     }
//   }

//   void _setInitialDisplayImage() {
//     if (_imageUrls.isNotEmpty) {
//       _currentDisplayImageUrl = _imageUrls[0];
//       _currentIndex = 0;
//     } else {
//       _currentDisplayImageUrl = null;
//     }
//   }

//   void _startImageAutoScroll() {
//     _stopTimer();
//     if (_imageUrls.length > 1) {
//       _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
//         setState(() {
//           _currentIndex = (_currentIndex + 1) % _imageUrls.length;
//           _currentDisplayImageUrl = _imageUrls[_currentIndex];
//         });
//       });
//     }
//   }

//   void _stopTimer() {
//     if (_timer != null && _timer!.isActive) {
//       _timer!.cancel();
//       _timer = null;
//     }
//   }

//   @override
//   void dispose() {
//     _stopTimer();
//     super.dispose();
//   }

//   // Fonction pour naviguer vers PropertyDetail
//   void _navigateToPropertyDetail() {
//     if (widget.logementData != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => PropertyDetail(logementData: widget.logementData!),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     if (_currentDisplayImageUrl == null || _currentDisplayImageUrl!.isEmpty) {
//       return Container(
//         height: screenHeight * .47,
//         decoration: BoxDecoration(
//           color: Colors.grey[300],
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(50),
//             topRight: Radius.circular(50),
//             bottomLeft: Radius.circular(30),
//             bottomRight: Radius.circular(30),
//           ),
//         ),
//         child: const Center(
//           child: Text(
//             'Aucune image disponible.',
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: _navigateToPropertyDetail, // Gérer le tap pour la navigation
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           AnimatedSwitcherPlus.zoomOut(
//             duration: const Duration(milliseconds: 800),
//             child: Container(
//               key: ValueKey<String>(_currentDisplayImageUrl!),
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(5)),
//               ),
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     height: screenHeight * .47,
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(50),
//                         topRight: Radius.circular(50),
//                         bottomLeft: Radius.circular(30),
//                         bottomRight: Radius.circular(30),
//                       ),
//                       child: Image.network(
//                         _currentDisplayImageUrl!,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: Colors.grey[300],
//                             child: const Center(
//                               child: Text('Erreur de chargement d\'image'),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),

//                   // Positioned.fill(
//                   //   child: Container(
//                   //     decoration: const BoxDecoration(
//                   //       borderRadius: BorderRadius.only(
//                   //         topLeft: Radius.circular(50),
//                   //         topRight: Radius.circular(50),
//                   //         bottomLeft: Radius.circular(30),
//                   //         bottomRight: Radius.circular(30),
//                   //       ),
//                   //       gradient: LinearGradient(
//                   //         begin: Alignment.topCenter,
//                   //         end: Alignment.bottomCenter,
//                   //         colors: [Colors.transparent, Color(0xb3101010)],
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   Positioned(
//                     bottom: 0,
//                     child: Container(
//                       padding: EdgeInsets.only(right: 10),
//                       height: screenHeight * .2,
//                       width: screenWidth * .95,
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           // topLeft: Radius.circular(50),
//                           // topRight: Radius.circular(50),
//                           bottomLeft: Radius.circular(30),
//                           bottomRight: Radius.circular(30),
//                         ),
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Colors.transparent, Color(0xd9000000)],
//                         ),
//                       ),
//                       child: Align(
//                         alignment: Alignment.bottomRight,
//                         child: Positioned(
//                           left: 0,
//                           right: 0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: List.generate(_imageUrls.length, (index) {
//                               return Container(
//                                 width: 8.0,
//                                 height: 8.0,
//                                 margin: const EdgeInsets.symmetric(
//                                   horizontal: 4,
//                                   vertical: 20,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color:
//                                       (_currentIndex == index)
//                                           ? Colors.white
//                                           : Color(0x66ffffff),
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Boiton suivi de slide
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
