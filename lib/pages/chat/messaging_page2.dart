import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Définition de la classe Message pour structurer nos données de message
class Message {
  final String? text;
  final Widget? widget;
  final bool isMe;
  final DateTime time;

  Message({this.text, this.widget, required this.isMe, required this.time});
}

class MessagingPage2 extends StatefulWidget {
  final Widget? initialMessageWidget;

  const MessagingPage2({super.key, this.initialMessageWidget});

  @override
  State<MessagingPage2> createState() => _MessagingPage2State();
}

class _MessagingPage2State extends State<MessagingPage2> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialMessageWidget != null) {
      // Ajoute le widget initial comme un message spécial
      _messages.add(
        Message(
          widget: widget.initialMessageWidget,
          isMe: false, // Ce message est envoyé par l'interlocuteur
          time: DateTime.now(),
        ),
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            text: _messageController.text.trim(),
            isMe: true,
            time: DateTime.now(),
          ),
        );
      });
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];

                // Si le message est un widget, on l'affiche directement
                if (message.widget != null) {
                  return Align(
                    alignment: Alignment.center,
                    child: message.widget,
                  );
                }

                // Sinon, on affiche un message texte standard
                return Align(
                  alignment:
                      message.isMe
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
                      color:
                          message.isMe
                              ? Colors.blue.shade100
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          message.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text!,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          DateFormat('hh:mm a').format(message.time),
                          style: TextStyle(
                            color:
                                message.isMe
                                    ? Colors.black54
                                    : Colors.grey.shade600,
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
          Column(
            children: [
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
                      backgroundColor: Colors.blue,
                      mini: true,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}

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

// class MessagingPage2 extends StatefulWidget {
//   const MessagingPage2({super.key, required WidgetHouseInfos3Bis initialMessageWidget});

//   @override
//   State<MessagingPage2> createState() => _MessagingPage2State();
// }

// class _MessagingPage2State extends State<MessagingPage2> {
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
//         backgroundColor: Colors.blue, // Couleur d'en-tête de l'application
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
//                               ? Colors.blue.shade100
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
//                       backgroundColor: Colors.blue,
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
