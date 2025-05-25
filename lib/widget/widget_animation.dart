import 'package:flutter/material.dart';
import 'package:animated_switcher_plus/animated_switcher_plus.dart';

class WidgetAnimation extends StatefulWidget {
  const WidgetAnimation({super.key});

  @override
  State<WidgetAnimation> createState() => _WidgetAnimationState();
}

class _WidgetAnimationState extends State<WidgetAnimation> {
  bool _showFirstChild = true;
  int _currentIndex = 0;
  // Timer? _timer;

  final List<String> _images = [
    'assets/images/img04.jpg',
    'assets/images/img03.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSwitcherPlus.zoomOut(
          duration: const Duration(seconds: 1),
          child: Container(
            key: ValueKey(_showFirstChild),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Stack(
              key: ValueKey<String>(_images[_currentIndex]),
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  height: screenHeight * .47,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      _showFirstChild
                          ? 'assets/images/img01.jpg'
                          : 'assets/images/img04.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 25,
                  child: SizedBox(
                    // height: screenHeight * .46,
                    // width: screenwidth * .40,
                    child: Row(
                      children: [
                        SizedBox(width: 5),
                        // const Spacer(),
                        Center(
                          child:
                          // ElevatedButton(
                          //   onPressed:
                          //       () => setState(() {
                          //         _showFirstChild = !_showFirstChild;
                          //       }),
                          //   child: const Text(
                          //     'Nest',
                          //     style: TextStyle(fontSize: 12),
                          //   ),
                          // ),
                          ElevatedButton(
                            onPressed:
                                () => setState(() {
                                  _showFirstChild = !_showFirstChild;
                                }),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black26,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),

                              minimumSize:
                                  Size.zero, // empêche un minimum implicite trop grand
                              tapTargetSize:
                                  MaterialTapTargetSize
                                      .shrinkWrap, // réduit la zone cliquable
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
          ),
        ),
      ],
    );
  }
}
