import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/pages/explore_screen.dart';
import 'package:kunft/pages/favorites.dart';
import 'package:kunft/pages/profile_screen/profile_screen.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    Favorites(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fond global
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeInOut,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 🎨 Couleur de fond de la navbar
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            /// Accueil
            SalomonBottomBarItem(
              icon: const Icon(LucideIcons.home),
              title: const Text("Accueil"),
              selectedColor: const Color(0xFF007BFF), // Bleu custom
            ),

            /// Explore
            SalomonBottomBarItem(
              icon: const Icon(LucideIcons.search),
              title: const Text("Explore"),
              selectedColor: const Color(0xFF5C6BC0), // Indigo
            ),

            /// Social
            SalomonBottomBarItem(
              icon: const Icon(LucideIcons.messageCircle),
              title: const Text("Social"),
              selectedColor: const Color(0xFF26A69A), // Vert turquoise
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(LucideIcons.userCircle),
              title: const Text("Profil"),
              selectedColor: const Color(0xFFAB47BC), // Violet
            ),
          ],
        ),
      ),
    );
  }
}





// Ancien okay 

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/explore_screen.dart';
// import 'package:kunft/pages/favorites.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// // Importez vos pages réelles ici
// import 'package:kunft/pages/home_screen.dart'; // Assurez-vous que ce chemin est correct
// import 'package:kunft/pages/profile_screen.dart'; // Assurez-vous que ce chemin est correct

// // --- Placeholders pour les pages Likes et Search (à remplacer par vos pages réelles) ---
// class LikesPage extends StatelessWidget {
//   const LikesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Page des Favoris',
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// class SearchPage extends StatelessWidget {
//   const SearchPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text(
//         'Page de Recherche',
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
// // -----------------------------------------------------------------------------------

// class CustomNavBar extends StatefulWidget {
//   const CustomNavBar({
//     super.key,
//   }); // Ajout du super.key pour les bonnes pratiques

//   @override
//   _CustomNavBarState createState() => _CustomNavBarState();
// }

// class _CustomNavBarState extends State<CustomNavBar> {
//   var _currentIndex = 0;

//   // ✅ Liste des pages correspondant aux éléments de la barre de navigation
//   final List<Widget> _pages = const [
//     HomeScreen(),
//     ExploreScreen(),
//     Favorites(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Le Scaffold doit être le widget racine pour avoir une barre de navigation
//       body: IndexedStack(
//         // ✅ Utilise IndexedStack pour afficher la page sélectionnée
//         index: _currentIndex, // L'index de la page à afficher
//         children: _pages, // La liste de toutes les pages
//       ),
//       bottomNavigationBar: SalomonBottomBar(
//         currentIndex: _currentIndex,
//         onTap:
//             (i) => setState(
//               () => _currentIndex = i,
//             ), // Met à jour l'index de la page
//         items: [
//           /// Home
//           SalomonBottomBarItem(
//             icon: const Icon(LucideIcons.home), // Ajout de const
//             title: const Text("Accueil"), // Ajout de const
//             selectedColor: const Color.fromRGBO(33, 150, 243, 1),
//           ),

//           /// Likes
//           SalomonBottomBarItem(
//             icon: const Icon(LucideIcons.search), // Ajout de const
//             title: const Text("Explore"), // Ajout de const
//             selectedColor: Colors.blue,
//           ),

//           /// Search
//           SalomonBottomBarItem(
//             icon: const Icon(LucideIcons.messageCircle), // Ajout de const
//             title: const Text("Social"), // Ajout de const
//             selectedColor: Colors.blue,
//           ),

//           /// Profile
//           SalomonBottomBarItem(
//             icon: const Icon(LucideIcons.userCircle), // Ajout de const
//             title: const Text("Profile"), // Ajout de const
//             selectedColor: Colors.blue,
//           ),
//         ],
//       ),
//     );
//   }
// }
