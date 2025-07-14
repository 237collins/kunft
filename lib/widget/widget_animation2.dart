import 'package:flutter/material.dart';
import 'package:animated_switcher_plus/animated_switcher_plus.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000';

class WidgetAnimation2 extends StatefulWidget {
  final List<String> imageUrls; // Reçoit toutes les URLs
  final String
  initialImageUrl; // Reçoit l'URL de l'image à afficher initialement

  const WidgetAnimation2({
    super.key,
    required this.imageUrls,
    required this.initialImageUrl,
  });

  @override
  State<WidgetAnimation2> createState() => _WidgetAnimation2State();
}

class _WidgetAnimation2State extends State<WidgetAnimation2> {
  late int _currentIndex;
  late String _currentDisplayImageUrl;

  @override
  void initState() {
    super.initState();
    _initializeImages();
  }

  @override
  void didUpdateWidget(covariant WidgetAnimation2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si l'image initiale change ou la liste d'images change, mettez à jour.
    if (widget.initialImageUrl != oldWidget.initialImageUrl ||
        !_areListsEqual(widget.imageUrls, oldWidget.imageUrls)) {
      _initializeImages();
    }
  }

  bool _areListsEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  void _initializeImages() {
    _currentDisplayImageUrl = widget.initialImageUrl;
    _currentIndex = widget.imageUrls.indexOf(widget.initialImageUrl);
    if (_currentIndex == -1 && widget.imageUrls.isNotEmpty) {
      _currentIndex = 0;
      _currentDisplayImageUrl = widget.imageUrls[0];
    } else if (widget.imageUrls.isEmpty) {
      _currentDisplayImageUrl =
          'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';
      _currentIndex = 0;
    }
  }

  void _nextImage() {
    if (widget.imageUrls.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.imageUrls.length;
      _currentDisplayImageUrl = widget.imageUrls[_currentIndex];
    });
  }

  void _previousImage() {
    if (widget.imageUrls.isEmpty) return;
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.imageUrls.length) %
          widget.imageUrls.length;
      _currentDisplayImageUrl = widget.imageUrls[_currentIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.imageUrls.isEmpty && _currentDisplayImageUrl.isEmpty) {
      return Container(
        height: screenHeight * .47,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: const Center(
          child: Text(
            'Aucune image disponible.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSwitcherPlus.zoomIn(
          duration: const Duration(milliseconds: 800),
          child: Container(
            key: ValueKey<String>(_currentDisplayImageUrl),
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
                      _currentDisplayImageUrl,
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

                // Positioned.fill(
                //   child: Container(
                //     decoration: const BoxDecoration(
                //       borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(50),
                //         topRight: Radius.circular(50),
                //         bottomLeft: Radius.circular(30),
                //         bottomRight: Radius.circular(30),
                //       ),
                //       gradient: LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [Colors.transparent, Colors.black],
                //       ),
                //     ),
                //   ),
                // ),

                // Boutons de navigation manuelle
                // if (widget.imageUrls.length > 1)
                //   Positioned(
                //     left: 10,
                //     top: 0,
                //     bottom: 0,
                //     child: IconButton(
                //       icon: const Icon(
                //         Icons.arrow_back_ios,
                //         color: Colors.white,
                //         size: 30,
                //       ),
                //       onPressed: _previousImage,
                //     ),
                //   ),
                // if (widget.imageUrls.length > 1)
                //   Positioned(
                //     right: 10,
                //     top: 0,
                //     bottom: 0,
                //     child: IconButton(
                //       icon: const Icon(
                //         Icons.arrow_forward_ios,
                //         color: Colors.white,
                //         size: 30,
                //       ),
                //       onPressed: _nextImage,
                //     ),
                //   ),

                // Suivi de la slide
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    height: screenHeight * .2,
                    width: screenWidth * .95,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xb3000000)],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Positioned(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(widget.imageUrls.length, (
                            index,
                          ) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    (_currentIndex == index)
                                        ? Colors.white
                                        : Color(0x66ffffff),
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
    );
  }
}
