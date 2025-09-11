import 'package:flutter/material.dart';
// import 'package:kunft/pages/SplashScreen.dart';
import 'package:kunft/pages/auth/login_page.dart';
import 'package:kunft/pages/profile_screen/elements/my_booking.dart';
import 'package:kunft/pages/profile_screen/elements/notifications_settings.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:lucide_icons/lucide_icons.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
// --- Placeholders pour les pages de navigation ---
// Remplacez ces classes par vos pages réelles lorsque vous les créerez.

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Mes Réservations')),
      body: const Center(
        child: MyBooking(),
        // Text('Contenu de Mes Réservations')
      ),
    );
  }
}

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiements')),
      body: const Center(child: Text('Contenu des Paiements')),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier le Profil')),
      body: const Center(
        child: Text('Contenu de la page de modification de profil'),
      ),
    );
  }
}

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return NotificationsSettings();
    // Scaffold(
    //   appBar: AppBar(title: const Text('Notifications')),
    //   body: const Center(child: Text('Contenu des paramètres de notification')),
    // );
  }
}

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sécurité')),
      body: const Center(child: Text('Contenu des paramètres de sécurité')),
    );
  }
}

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres de Langue')),
      body: const Center(child: Text('Contenu des paramètres de langue')),
    );
  }
}

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Centre d\'aide')),
      body: const Center(child: Text('Contenu du centre d\'aide')),
    );
  }
}

class InviteFriendsPage extends StatelessWidget {
  const InviteFriendsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inviter vos Amis')),
      body: const Center(
        child: Text('Contenu de la page d\'invitation d\'amis'),
      ),
    );
  }
}
// --- Fin des placeholders ---

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // État pour le mode sombre (pour l'interrupteur)
  bool _isDarkModeEnabled = false;

  // Ancienne fonction
  // ✅ AJOUTÉ : Fonction pour afficher la boîte de dialogue de déconnexion
  // void _showLogoutDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Déconnexion'), // Titre de la boîte de dialogue
  //         content: const Text(
  //           'Êtes-vous sûr de vouloir vous déconnecter ?',
  //         ), // Message de confirmation
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Ferme la boîte de dialogue
  //             },
  //             child: const Text('Annuler'), // Bouton Annuler
  //           ),
  //           TextButton(
  //             onPressed: () async {
  //               Navigator.of(
  //                 context,
  //               ).pop(); // Ferme la boîte de dialogue avant de déconnecter
  //               // ✅ LOGIQUE DE DÉCONNEXION DÉPLACÉE ICI
  //               SharedPreferences prefs = await SharedPreferences.getInstance();
  //               await prefs.remove('token'); // Supprime le token
  //               if (context.mounted) {
  //                 // Vérifie si le widget est toujours monté avant de naviguer
  //                 Navigator.pushReplacement(
  //                   // Redirige vers l'écran de splash
  //                   context,
  //                   MaterialPageRoute(builder: (context) => const LoginPage()),
  //                 );
  //               }
  //             },
  //             child: const Text(
  //               'Oui, Déconnexion',
  //               style: TextStyle(color: Colors.red),
  //             ), // Bouton de confirmation
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  //

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Utilisation d'un nouveau BuildContext pour éviter les problèmes
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // On utilise le 'dialogContext' pour pop la boîte de dialogue
                Navigator.of(dialogContext).pop();

                // On accède à l'instance de votre UserProvider
                // 'listen: false' est crucial pour ne pas reconstruire le widget
                // quand la valeur change, ce qui est inutile ici.
                final userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );

                // On appelle la méthode de déconnexion du provider
                await userProvider.logout();

                if (context.mounted) {
                  // On navigue vers la page de connexion
                  // On utilise le 'context' initial, pas le 'dialogContext'
                  // car le 'dialogContext' sera invalidé après le pop.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              child: const Text(
                'Oui, Déconnexion',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Liste des widgets principaux à afficher dans ListView.separated
    final List<Widget> items = [
      // ⬅️ Retour et titre
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(Icons.logo_dev_outlined),
            SizedBox(width: 20),
            Text(
              'Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      // 👤 Avatar et nom d'utilisateur
      Column(
        children: const [
          CircleAvatar(
            radius: 65,
            backgroundImage: AssetImage('assets/images/img07.png'),
          ),
          SizedBox(height: 10),
          Text(
            'Andrew Aisnley',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Divider(
          color: Colors.grey,
          thickness: 0.3, // épaisseur de la ligne
        ),
      ),
      // 🗓 Réservations et Paiements
      _buildTile(
        LucideIcons.calendarDays,
        'Mes réservations',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyReservationsPage(),
            ), // Page test
          );
        },
      ),
      _buildTile(
        LucideIcons.wallet,
        'Paiements',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentsPage()),
          );
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Divider(
          color: Colors.grey,
          thickness: 0.3, // épaisseur de la ligne
        ),
      ),
      // 🔧 Autres options
      _buildTile(
        LucideIcons.user,
        'Profile',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfilePage()),
          );
        },
      ),
      _buildTile(
        LucideIcons.bell,
        'Notification',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationSettingsPage(),
            ),
          );
        },
      ),
      _buildTile(
        LucideIcons.shieldCheck,
        'Sécurité',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecurityPage()),
          );
        },
      ),
      _buildTileWithTrailing(
        icon: LucideIcons.globe,
        title: 'Langue',
        trailing: const Text(
          'Anglais (US)',
          style: TextStyle(color: Colors.black26),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LanguageSettingsPage(),
            ),
          );
        },
      ),
      _buildTileWithSwitch(
        icon: LucideIcons.eye,
        title: 'Mode sombre',
        value: _isDarkModeEnabled,
        onChanged: (v) {
          setState(() {
            _isDarkModeEnabled = v;
            // Ici, vous implémenteriez la logique réelle pour changer le thème de l'application
            // Par exemple, en utilisant un Provider ou un InheritedWidget pour gérer le thème.
            print('Mode sombre activé: $_isDarkModeEnabled');
          });
        },
      ),
      _buildTile(
        LucideIcons.helpCircle,
        'Centre d\'aide',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpCenterPage()),
          );
        },
      ),
      _buildTile(
        LucideIcons.users,
        'Inviter vos Amis',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InviteFriendsPage()),
          );
        },
      ),
      // 🚪 Bouton de déconnexion
      ElevatedButton(
        onPressed: () {
          // ✅ MODIFIÉ : Appelle la fonction _showLogoutDialog
          _showLogoutDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.logout_outlined, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            // 👇 ListView avec séparation entre chaque élément
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 1),
                itemBuilder: (context, index) => items[index],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Tuile simple avec icône, titre et flèche
  static Widget _buildTile(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 🔹 Tuile avec texte à droite (comme pour langue)
  static Widget _buildTileWithTrailing({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          trailing,
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  /// 🔹 Tuile avec interrupteur (Dark mode)
  static Widget _buildTileWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white, // Couleur du "bouton" actif
        activeTrackColor: Colors.blue, // Couleur de la piste active
        inactiveThumbColor: Colors.white, // Bouton inactif
        inactiveTrackColor: const Color(0x40009fe3), // Piste inactive
      ),
      // Pas de onTap pour la ListTile entière ici, car l'action est gérée par le Switch
    );
  }
}

// Code sans navigation

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/SplashScreen.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // Liste des widgets principaux à afficher dans ListView.separated
//     final List<Widget> items = [
//       // ⬅️ Retour et titre
//       Padding(
//         padding: const EdgeInsets.only(left: 15, right: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(Icons.logo_dev_outlined),
//             SizedBox(width: 20),
//             Text(
//               'Profile',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(height: 10),

//       // 👤 Avatar et nom d'utilisateur
//       Column(
//         children: const [
//           CircleAvatar(
//             radius: 65,
//             backgroundImage: AssetImage('assets/images/img07.png'),
//           ),
//           SizedBox(height: 10),
//           Text(
//             'Andrew Aisnley',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//           ),
//         ],
//       ),
//       const SizedBox(height: 10),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: const Divider(
//           color: Colors.grey,
//           thickness: 0.3, // épaisseur de la ligne
//         ),
//       ),

//       // 🗓 Réservations et Paiements
//       _buildTile(LucideIcons.calendarDays, 'Mes réservations'),
//       _buildTile(LucideIcons.wallet, 'Paiements'),

//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: const Divider(
//           color: Colors.grey,
//           thickness: 0.3, // épaisseur de la ligne
//           // indent: 8.0, // retrait gauche
//           // endIndent: 8.0, // retrait droit
//           // height: 24.0, // espace vertical
//         ),
//       ),

//       // 🔧 Autres options
//       _buildTile(LucideIcons.user, 'Profile'),
//       _buildTile(LucideIcons.bell, 'Notification'),
//       _buildTile(LucideIcons.shieldCheck, 'Sécurité'),
//       _buildTileWithTrailing(
//         icon: LucideIcons.globe,
//         title: 'Langue',
//         trailing: Text('Anglais (US)', style: TextStyle(color: Colors.black26)),
//       ),
//       _buildTileWithSwitch(
//         icon: LucideIcons.eye,
//         title: 'Mode sombre',
//         value: false,
//         onChanged: (v) {},
//       ),
//       _buildTile(LucideIcons.helpCircle, 'Centre d\'aide'),
//       _buildTile(LucideIcons.users, 'Inviter vos Amis'),

//       // 🚪 Bouton de déconnexion
//       ElevatedButton(
//         onPressed: () async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.remove('token');

//           if (context.mounted) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const SplashScreen()),
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//         ),
//         child: const Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Icon(Icons.logout_outlined, color: Colors.red, size: 28),
//             SizedBox(width: 10),
//             Text(
//               'Déconnexion',
//               style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//       ),
//     ];

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 60),
//         child: Column(
//           children: [
//             // 👇 ListView avec séparation entre chaque élément
//             Expanded(
//               child: ListView.separated(
//                 padding: EdgeInsets.zero,
//                 itemCount: items.length,
//                 separatorBuilder: (context, index) => const SizedBox(height: 1),
//                 itemBuilder: (context, index) => items[index],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔹 Tuile simple avec icône, titre et flèche
//   static Widget _buildTile(IconData icon, String title) {
//     return ListTile(
//       leading: Icon(icon, size: 24),
//       title: Text(title, style: const TextStyle(fontSize: 16)),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: () {},
//     );
//   }

//   /// 🔹 Tuile avec texte à droite (comme pour langue)
//   static Widget _buildTileWithTrailing({
//     required IconData icon,
//     required String title,
//     required Widget trailing,
//   }) {
//     return ListTile(
//       leading: Icon(icon, size: 24),
//       title: Text(title, style: const TextStyle(fontSize: 16)),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           trailing,
//           const SizedBox(width: 8),
//           const Icon(Icons.chevron_right),
//         ],
//       ),
//       onTap: () {},
//     );
//   }

//   /// 🔹 Tuile avec interrupteur (Dark mode)
//   static Widget _buildTileWithSwitch({
//     required IconData icon,
//     required String title,
//     required bool value,
//     required Function(bool) onChanged,
//   }) {
//     return ListTile(
//       leading: Icon(icon, size: 24),
//       title: Text(title, style: const TextStyle(fontSize: 16)),
//       // trailing: Switch(value: value, onChanged: onChanged),
//       trailing: Switch(
//         value: value,
//         onChanged: onChanged,
//         activeColor: Colors.white, // Couleur du "bouton" actif
//         activeTrackColor: Colors.blue, // Couleur de la piste active
//         inactiveThumbColor: Colors.white, // Bouton inactif
//         inactiveTrackColor: Color(0x40009fe3), // Piste inactive
//       ),
//     );
//   }
// }
