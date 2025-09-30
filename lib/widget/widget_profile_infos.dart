import 'package:flutter/material.dart';
import 'package:kunft/pages/chat/messaging_page2.dart';
import 'package:kunft/pages/profile_screen/elements/notifications_page.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/UserProvider.dart'; // Assurez-vous d'importer votre UserProvider

class WidgetProfileInfos extends StatefulWidget {
  const WidgetProfileInfos({super.key});

  @override
  State<WidgetProfileInfos> createState() => _WidgetProfileInfosState();
}

class _WidgetProfileInfosState extends State<WidgetProfileInfos> {
  @override
  Widget build(BuildContext context) {
    // Utiliser un Consumer pour écouter les changements dans UserProvider
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Obtenir l'utilisateur à partir du provider
        final user = userProvider.user;

        // Si l'utilisateur n'est pas encore chargé, afficher un widget temporaire (ou rien)
        if (user == null) {
          return const SizedBox.shrink();
        }

        // Afficher le widget principal une fois que les données de l'utilisateur sont disponibles
        return Positioned(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // photo de profile ici
                    Container(
                      padding: const EdgeInsets.all(3),
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          // ✅ Utiliser l'image de profil de l'utilisateur si disponible, sinon une image par défaut
                          user['profileImage'] ?? // La colonne en base est encore donc ceci n'est pas encore sur
                              'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg?t=st=1752401142~exp=1752404742~hmac=6b43b692930935ffccf129f98ed7ece809f4fd70644cfdc1b7b5d664b102f36c&w=1380',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Text(
                          // salutation
                          'Good morning',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Text(
                          // ✅ Nom de l'utilisateur
                          user['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Linker sur la page messagerie
                    GestureDetector(
                      onTap: () {
                        // ✅ Obtenir l'ID de l'utilisateur actuel
                        final currentUserId = user['id'];
                        // TODO: Remplacez cette valeur par l'ID de l'utilisateur destinataire
                        final receiverId = 2;

                        // ✅ Navigation vers la page de messagerie en passant les IDs nécessaires
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessagePage(
                              // Les IDs sont maintenant dynamiques
                              conversationId: currentUserId,
                              receiverId: receiverId,
                            ),
                          ),
                        );
                      },
                      child: const Icon(Icons.message, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    // page de notifs
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Notifications(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}





// -------- Okay mais sans liaison dynamique ----------


// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/chat/messaging_page2.dart';
// import 'package:kunft/pages/profile_screen/elements/notifications_page.dart';
// import 'package:provider/provider.dart';
// import 'package:kunft/provider/UserProvider.dart'; // Assurez-vous d'importer votre UserProvider

// class WidgetProfileInfos extends StatefulWidget {
//   const WidgetProfileInfos({super.key});

//   @override
//   State<WidgetProfileInfos> createState() => _WidgetProfileInfosState();
// }

// class _WidgetProfileInfosState extends State<WidgetProfileInfos> {
//   @override
//   Widget build(BuildContext context) {
//     // Utiliser un Consumer pour écouter les changements dans UserProvider
//     return Consumer<UserProvider>(
//       builder: (context, userProvider, child) {
//         // Obtenir l'utilisateur à partir du provider
//         final user = userProvider.user;

//         // Si l'utilisateur n'est pas encore chargé, afficher un widget temporaire (ou rien)
//         if (user == null) {
//           return const SizedBox.shrink();
//         }

//         // Afficher le widget principal une fois que les données de l'utilisateur sont disponibles
//         return Positioned(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     // photo de profile ici
//                     Container(
//                       padding: const EdgeInsets.all(3),
//                       height: 56,
//                       width: 56,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(100),
//                       ),
//                       child: CircleAvatar(
//                         backgroundImage: NetworkImage(
//                           // ✅ Utiliser l'image de profil de l'utilisateur si disponible, sinon une image par défaut
//                           user['profileImage'] ?? // La colonne en base est encore donc ceci n'est pas encore sur
//                               'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg?t=st=1752401142~exp=1752404742~hmac=6b43b692930935ffccf129f98ed7ece809f4fd70644cfdc1b7b5d664b102f36c&w=1380',
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 5),
//                         const Text(
//                           // salutation
//                           'Good morning',
//                           style: TextStyle(fontSize: 12, color: Colors.white),
//                         ),
//                         Text(
//                           // ✅ Nom de l'utilisateur
//                           user['name'] ?? '',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     // Linker sur la page messagerie
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const MessagePage(
//                               // Remplacez ces valeurs par les ID dynamiques de votre application
//                               conversationId: 1,
//                               receiverId: 2,
//                               // initialMessageWidget est facultatif,
//                               // vous pouvez le laisser de côté si vous n'en avez pas besoin.
//                               // initialMessageWidget: Text('Bienvenue dans le chat !'),
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Icon(Icons.message, color: Colors.white),
//                     ),
//                     const SizedBox(width: 10),
//                     // page de notifs
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const Notifications(),
//                           ),
//                         );
//                       },
//                       child: const Icon(
//                         Icons.notifications,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }




// -------- Code statique --------



// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/chat/messaging_page2.dart';
// import 'package:kunft/pages/profile_screen/elements/notifications_page.dart';

// class WidgetProfileInfos extends StatefulWidget {
//   const WidgetProfileInfos({super.key});

//   @override
//   State<WidgetProfileInfos> createState() => _WidgetProfileInfosState();
// }

// class _WidgetProfileInfosState extends State<WidgetProfileInfos> {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       // top: 0,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 // photo de profile ici
//                 Container(
//                   padding: const EdgeInsets.all(3),
//                   height: 56,
//                   width: 56,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: const CircleAvatar(
//                     backgroundImage: NetworkImage(
//                       'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg?t=st=1752401142~exp=1752404742~hmac=6b43b692930935ffccf129f98ed7ece809f4fd70644cfdc1b7b5d664b102f36c&w=1380',
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 5),
//                     Text(
//                       // salutation
//                       'Good morning',
//                       style: TextStyle(fontSize: 12, color: Colors.white),
//                     ),
//                     Text(
//                       // Nom du user
//                       'Charlotte Anderson',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 // Linker sur la page messagerie
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const MessagingPage2(),
//                       ),
//                     );
//                   },
//                   child: const Icon(Icons.message, color: Colors.white),
//                 ),

//                 const SizedBox(width: 10),
//                 // page de notifs
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Notifications(),
//                       ),
//                     );
//                   },
//                   child: const Icon(Icons.notifications, color: Colors.white),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
