// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthLocalService {
//   static const String _uidKey = 'firebase_uid';

//   /// Sauvegarde l'UID dans shared_preferences après inscription ou connexion
//   static Future<void> saveUidLocally(String uid) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_uidKey, uid);
//     print('✅ UID sauvegardé localement : $uid');
//   }

//   /// Récupère l'UID localement pour vérifier si l'utilisateur est connecté
//   static Future<String?> getStoredUid() async {
//     final prefs = await SharedPreferences.getInstance();
//     final uid = prefs.getString(_uidKey);
//     print('📥 UID récupéré localement : $uid');
//     return uid;
//   }

//   /// Supprime l'UID stocké et déconnecte Firebase
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_uidKey);

//     await FirebaseAuth.instance.signOut();

//     print('🚪 Déconnexion réussie');
//   }

//   /// Vérifie si un utilisateur est déjà connecté (en local)
//   static Future<bool> isLoggedIn() async {
//     final uid = await getStoredUid();
//     return uid != null;
//   }
// }
