import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:animated_switcher_plus/animated_switcher_plus.dart';

class WidgetAnimatedSwitcher extends StatefulWidget {
  const WidgetAnimatedSwitcher({super.key});

  @override
  State<WidgetAnimatedSwitcher> createState() => _WidgetAnimatedSwitcherState();
}

class _WidgetAnimatedSwitcherState extends State<WidgetAnimatedSwitcher> {
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _images = [
    'assets/images/img04.jpg',
    'assets/images/img03.jpg',
  ];

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _nextImage();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final inAnimation = Tween<Offset>(
              begin: const Offset(-1.0, 0.0), // de la gauche vers la droite
              end: Offset.zero,
            ).animate(animation);

            return SlideTransition(position: inAnimation, child: child);
          },
          child: Stack(
            key: ValueKey<String>(_images[_currentIndex]),
            children: [
              Image.asset(
                _images[_currentIndex],
                width: double.infinity,
                height: screenHeight * .45,
                fit: BoxFit.cover,
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
            ],
          ),
        ),
      ],
    );
  }
}





// Ancien code manuel


// import 'package:flutter/material.dart';
// import 'package:animated_switcher_plus/animated_switcher_plus.dart';

// class WidgetAnimatedSwitcher extends StatefulWidget {
//   const WidgetAnimatedSwitcher({super.key});

//   @override
//   State<WidgetAnimatedSwitcher> createState() => _WidgetAnimatedSwitcherState();
// }

// class _WidgetAnimatedSwitcherState extends State<WidgetAnimatedSwitcher> {
//   int _currentIndex = 0;

//   final List<String> _images = [
//     'assets/images/img01.jpg',
//     'assets/images/img02.jpg',
//     'assets/images/img03.jpg',
//   ];
//   void _nextImage() {
//     setState(() {
//       _currentIndex = (_currentIndex + 1) % _images.length;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         AnimatedSwitcher(
//           duration: Duration(seconds: 1),
//           transitionBuilder: (child, animation) {
//             return ScaleTransition(
//               scale: animation,
//               child: FadeTransition(opacity: animation, child: child),
//             );
//           },
//           child: Image.asset(
//             _images[_currentIndex],
//             key: ValueKey<String>(_images[_currentIndex]),
//             width: 300,
//             height: 300,
//             fit: BoxFit.cover,
//           ),
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: _nextImage,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//           ),
//           child: const Text('Suivant'),
//         ),
//       ],
//     );
//   }
// }
