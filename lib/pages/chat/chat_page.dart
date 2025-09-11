import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // appBar: AppBar(title: Text('Logout Example')),
    Center(
      child: ElevatedButton(
        onPressed: () {
          showLogoutDialog(context);
        },
        child: Text('Show Logout Dialog'),
      ),
    );
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔴 Titre
              const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // 📝 Texte de confirmation
              const Text(
                "Are you sure you want to log out?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // 🔘 Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ❌ Annuler
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Ferme le dialogue
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF0F3FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF4362F8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // ✅ Déconnexion
                  ElevatedButton(
                    onPressed: () {
                      // 👉 Action de déconnexion ici
                      Navigator.of(context).pop(); // Ferme la boîte
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E5BFE), // Bleu foncé
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Yes, Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'message.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _controller = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   void _envoyerMessage() async {
//     final contenu = _controller.text.trim();
//     if (contenu.isEmpty) return;

//     final message = Message(
//       auteur: 'Moi', // ou récupéré via FirebaseAuth
//       contenu: contenu,
//       heure: DateTime.now(),
//     );

//     await _firestore.collection('messages').add(message.toMap());
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Messagerie')),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream:
//                   _firestore
//                       .collection('messages')
//                       .orderBy('heure', descending: false)
//                       .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const CircularProgressIndicator();

//                 final messages =
//                     snapshot.data!.docs.map((doc) {
//                       return Message.fromMap(
//                         doc.data()! as Map<String, dynamic>,
//                       );
//                     }).toList();

//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final m = messages[index];
//                     return ListTile(
//                       title: Text(m.contenu),
//                       subtitle: Text(
//                         '${m.auteur} - ${m.heure.hour}:${m.heure.minute}',
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: 'Écrivez un message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _envoyerMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
