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
