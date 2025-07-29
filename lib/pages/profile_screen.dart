import 'package:flutter/material.dart';
import 'package:kunft/pages/SplashScreen.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // Liste des widgets principaux à afficher dans ListView.separated
    final List<Widget> items = [
      // ⬅️ Retour et titre
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Icon(Icons.arrow_circle_left_rounded),
            ),
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
      _buildTile(LucideIcons.calendarDays, 'Mes réservations'),
      _buildTile(LucideIcons.wallet, 'Paiements'),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Divider(
          color: Colors.grey,
          thickness: 0.3, // épaisseur de la ligne
          // indent: 8.0, // retrait gauche
          // endIndent: 8.0, // retrait droit
          // height: 24.0, // espace vertical
        ),
      ),

      // 🔧 Autres options
      _buildTile(LucideIcons.user, 'Profile'),
      _buildTile(LucideIcons.bell, 'Notification'),
      _buildTile(LucideIcons.shieldCheck, 'Sécurité'),
      _buildTileWithTrailing(
        icon: LucideIcons.globe,
        title: 'Langue',
        trailing: Text('Anglais (US)', style: TextStyle(color: Colors.black26)),
      ),
      _buildTileWithSwitch(
        icon: LucideIcons.eye,
        title: 'Mode sombre',
        value: false,
        onChanged: (v) {},
      ),
      _buildTile(LucideIcons.helpCircle, 'Centre d\'aide'),
      _buildTile(LucideIcons.users, 'Inviter vos Amis'),

      // 🚪 Bouton de déconnexion
      ElevatedButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
          }
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
  static Widget _buildTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  /// 🔹 Tuile avec texte à droite (comme pour langue)
  static Widget _buildTileWithTrailing({
    required IconData icon,
    required String title,
    required Widget trailing,
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
      onTap: () {},
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
      // trailing: Switch(value: value, onChanged: onChanged),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white, // Couleur du "bouton" actif
        activeTrackColor: Colors.blue, // Couleur de la piste active
        inactiveThumbColor: Colors.white, // Bouton inactif
        inactiveTrackColor: Color(0x40009fe3), // Piste inactive
      ),
    );
  }
}
