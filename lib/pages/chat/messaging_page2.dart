import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kunft/provider/UserProvider.dart'; // Assurez-vous d'importer votre UserProvider

class MessagePage extends StatefulWidget {
  final Widget? initialMessageWidget;
  // TODO: Ajoutez ici les IDs pour la conversation et l'interlocuteur
  final int conversationId;
  final int receiverId;

  const MessagePage({
    super.key,
    this.initialMessageWidget,
    required this.conversationId,
    required this.receiverId,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ✅ Liste des messages provenant de l'API
  final List<Map<String, dynamic>> _messages = [];

  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // ✅ Charger les messages initiaux au démarrage
    _fetchMessages();
    _scrollController.addListener(() {
      // ✅ Si l'utilisateur a atteint le haut de la liste, charger la page précédente
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMore &&
          !_isLoading) {
        _fetchMessages();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ Méthode pour charger les messages depuis l'API, avec pagination
  Future<void> _fetchMessages() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newMessages = await userProvider.getConversationMessages(
      widget.conversationId,
      _currentPage,
    );

    if (newMessages != null && newMessages.isNotEmpty && mounted) {
      setState(() {
        _messages.insertAll(0, newMessages.reversed.toList());
        _currentPage++;
        if (newMessages.length < 20) {
          _hasMore = false;
        }
      });
    } else {
      if (mounted) {
        setState(() {
          _hasMore = false;
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ Méthode pour envoyer un message
  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    // ✅ Ajout optimiste du message à la liste
    final tempMessage = {
      'content': text,
      'sender_id': Provider.of<UserProvider>(
        context,
        listen: false,
      ).user!['id'],
      'created_at': DateTime.now().toIso8601String(),
    };
    setState(() {
      _messages.insert(0, tempMessage);
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.sendMessage(widget.receiverId, text);

    if (!success) {
      // Gérer l'échec de l'envoi si nécessaire
      // Par exemple, enlever le message temporaire de la liste ou afficher une erreur.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir l'ID de l'utilisateur actuel
    final currentUserId = Provider.of<UserProvider>(context).user!['id'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messagerie',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF256AFD),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // Affiche les messages du bas vers le haut
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _hasMore) {
                  return const Center(child: CircularProgressIndicator());
                }

                final message = _messages[_messages.length - 1 - index];

                // Vérifier si le message est un widget (initialMessageWidget)
                if (index == _messages.length - 1 &&
                    widget.initialMessageWidget != null) {
                  return Align(
                    alignment: Alignment.center,
                    child: widget.initialMessageWidget,
                  );
                }

                // Vérifier si c'est un message envoyé par l'utilisateur actuel
                final bool isMe = message['sender_id'] == currentUserId;
                final DateTime messageTime = DateTime.parse(
                  message['created_at'],
                );

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0x26256AFD)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['content'] ?? '',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          DateFormat('hh:mm a').format(messageTime),
                          style: TextStyle(
                            color: isMe ? Colors.black54 : Colors.grey.shade600,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Zone de saisie du message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrire un message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  backgroundColor: const Color(0xFF256AFD),
                  mini: true,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ------- Ancien code moins bien -----------

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// // Définition de la classe Message pour structurer nos données de message
// class Message {
//   final String? text;
//   final Widget? widget;
//   final bool isMe;
//   final DateTime time;

//   Message({this.text, this.widget, required this.isMe, required this.time});
// }

// class MessagePage extends StatefulWidget {
//   final Widget? initialMessageWidget;

//   const MessagePage({super.key, this.initialMessageWidget});

//   @override
//   State<MessagePage> createState() => _MessagePageState();
// }

// class _MessagePageState extends State<MessagePage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Message> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialMessageWidget != null) {
//       // Ajoute le widget initial comme un message spécial
//       _messages.add(
//         Message(
//           widget: widget.initialMessageWidget,
//           isMe: false, // Ce message est envoyé par l'interlocuteur
//           time: DateTime.now(),
//         ),
//       );
//     }
//   }

//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       setState(() {
//         _messages.add(
//           Message(
//             text: _messageController.text.trim(),
//             isMe: true,
//             time: DateTime.now(),
//           ),
//         );
//       });
//       _messageController.clear();
//     }
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Messagerie',
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color(0xFF256AFD),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               padding: const EdgeInsets.all(8.0),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[_messages.length - 1 - index];

//                 // Si le message est un widget, on l'affiche directement
//                 if (message.widget != null) {
//                   return Align(
//                     alignment: Alignment.center,
//                     child: message.widget,
//                   );
//                 }

//                 // Sinon, on affiche un message texte standard
//                 return Align(
//                   alignment: message.isMe
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   child: Container(
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.75,
//                     ),
//                     margin: const EdgeInsets.symmetric(
//                       vertical: 4.0,
//                       horizontal: 8.0,
//                     ),
//                     padding: const EdgeInsets.all(12.0),
//                     decoration: BoxDecoration(
//                       color: message.isMe
//                           ? const Color(0x26256AFD)
//                           : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(16.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: message.isMe
//                           ? CrossAxisAlignment.end
//                           : CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           message.text!,
//                           style: const TextStyle(
//                             color: Colors.black87,
//                             fontSize: 16.0,
//                           ),
//                         ),
//                         const SizedBox(height: 4.0),
//                         Text(
//                           DateFormat('hh:mm a').format(message.time),
//                           style: TextStyle(
//                             color: message.isMe
//                                 ? Colors.black54
//                                 : Colors.grey.shade600,
//                             fontSize: 10.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _messageController,
//                         decoration: InputDecoration(
//                           hintText: 'Écrire un message...',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.0),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16.0,
//                             vertical: 8.0,
//                           ),
//                         ),
//                         onSubmitted: (_) => _sendMessage(),
//                       ),
//                     ),
//                     const SizedBox(width: 8.0),
//                     FloatingActionButton(
//                       onPressed: _sendMessage,
//                       backgroundColor: Color(0xFF256AFD),
//                       mini: true,
//                       child: const Icon(Icons.send, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// Ancien code

// import 'package:flutter/material.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';

// // Définition de la classe Message pour structurer nos données de message
// class Message {
//   final String text;
//   final bool isMe; // Indique si le message est envoyé par l'utilisateur actuel
//   final DateTime time; // Horodatage du message

//   Message({required this.text, required this.isMe, required this.time});
// }

// class MessagePage extends StatefulWidget {
//   const MessagePage({super.key, required WidgetHouseInfos3Bis initialMessageWidget});

//   @override
//   State<MessagePage> createState() => _MessagePageState();
// }

// class _MessagePageState extends State<MessagePage> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Message> _messages =
//       []; // Liste des messages affichés dans le chat

//   // Fonction pour envoyer un nouveau message
//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       setState(() {
//         _messages.add(
//           Message(
//             text: _messageController.text.trim(),
//             isMe:
//                 true, // Pour cet exemple, tous les messages envoyés sont par "moi"
//             time: DateTime.now(),
//           ),
//         );
//       });
//       _messageController.clear(); // Efface le champ de texte après l'envoi
//     }
//   }

//   @override
//   void dispose() {
//     _messageController.dispose(); // Libère le contrôleur de texte
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Messagerie',
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color(0xFF256AFD), // Couleur d'en-tête de l'application
//       ),
//       body: Column(
//         children: [
//           // Liste des messages (prend l'espace restant)
//           Expanded(
//             child: ListView.builder(
//               reverse: true, // Affiche les nouveaux messages en bas
//               padding: const EdgeInsets.all(8.0),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message =
//                     _messages[_messages.length -
//                         1 -
//                         index]; // Pour afficher du plus récent au plus ancien
//                 return Align(
//                   alignment:
//                       message.isMe
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       vertical: 4.0,
//                       horizontal: 8.0,
//                     ),
//                     padding: const EdgeInsets.all(12.0),
//                     decoration: BoxDecoration(
//                       color:
//                           message.isMe
//                               ? Color(0xFF256AFD).shade100
//                               : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(16.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment:
//                           message.isMe
//                               ? CrossAxisAlignment.end
//                               : CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           message.text,
//                           style: TextStyle(
//                             color:
//                                 message.isMe ? Colors.black87 : Colors.black87,
//                             fontSize: 16.0,
//                           ),
//                         ),
//                         const SizedBox(height: 4.0),
//                         Text(
//                           '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}',
//                           style: TextStyle(
//                             color:
//                                 message.isMe
//                                     ? Colors.black54
//                                     : Colors.grey.shade600,
//                             fontSize: 10.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Champ de saisie de message
//           Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _messageController,
//                         decoration: InputDecoration(
//                           hintText: 'Écrire un message...',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15.0),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16.0,
//                             vertical: 8.0,
//                           ),
//                         ),
//                         onSubmitted:
//                             (_) =>
//                                 _sendMessage(), // Envoyer en appuyant sur Entrée
//                       ),
//                     ),
//                     const SizedBox(width: 8.0),
//                     FloatingActionButton(
//                       onPressed: _sendMessage,
//                       backgroundColor: Color(0xFF256AFD),
//                       mini: true, // Rendre le bouton plus petit
//                       child: const Icon(
//                         Icons.send,
//                         color: Colors.white,
//                         // size: 36,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               //
//               SizedBox(height: 40),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
