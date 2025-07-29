import 'package:flutter/material.dart';
import 'package:kunft/pages/explore_screen.dart';
import 'package:kunft/pages/favorites.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// Importez vos pages réelles ici
import 'package:kunft/pages/home_screen.dart'; // Assurez-vous que ce chemin est correct
import 'package:kunft/pages/profile_screen.dart'; // Assurez-vous que ce chemin est correct

// --- Placeholders pour les pages Likes et Search (à remplacer par vos pages réelles) ---
class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Page des Favoris',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Page de Recherche',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
// -----------------------------------------------------------------------------------

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({
    super.key,
  }); // Ajout du super.key pour les bonnes pratiques

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  var _currentIndex = 0;

  // ✅ Liste des pages correspondant aux éléments de la barre de navigation
  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    Favorites(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Le Scaffold doit être le widget racine pour avoir une barre de navigation
      body: IndexedStack(
        // ✅ Utilise IndexedStack pour afficher la page sélectionnée
        index: _currentIndex, // L'index de la page à afficher
        children: _pages, // La liste de toutes les pages
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap:
            (i) => setState(
              () => _currentIndex = i,
            ), // Met à jour l'index de la page
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home), // Ajout de const
            title: const Text("Home"), // Ajout de const
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border), // Ajout de const
            title: const Text("Likes"), // Ajout de const
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.search), // Ajout de const
            title: const Text("Search"), // Ajout de const
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person), // Ajout de const
            title: const Text("Profile"), // Ajout de const
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}


// Ancien code statique

// import 'package:flutter/material.dart';
// import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// class CustomNavBar extends StatefulWidget {
//   @override
//   _CustomNavBarState createState() => _CustomNavBarState();
// }

// class _CustomNavBarState extends State<CustomNavBar> {
//   var _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Scaffold(
//           bottomNavigationBar: SalomonBottomBar(
//             currentIndex: _currentIndex,
//             onTap: (i) => setState(() => _currentIndex = i),
//             items: [
//               /// Home
//               SalomonBottomBarItem(
//                 icon: Icon(Icons.home),
//                 title: Text("Home"),
//                 selectedColor: Colors.purple,
//               ),
        
//               /// Likes
//               SalomonBottomBarItem(
//                 icon: Icon(Icons.favorite_border),
//                 title: Text("Likes"),
//                 selectedColor: Colors.pink,
//               ),
        
//               /// Search
//               SalomonBottomBarItem(
//                 icon: Icon(Icons.search),
//                 title: Text("Search"),
//                 selectedColor: Colors.orange,
//               ),
        
//               /// Profile
//               SalomonBottomBarItem(
//                 icon: Icon(Icons.person),
//                 title: Text("Profile"),
//                 selectedColor: Colors.teal,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
