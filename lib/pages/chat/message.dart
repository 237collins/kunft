// class Message {
//   final String auteur;
//   final String contenu;
//   final DateTime heure;

//   Message({required this.auteur, required this.contenu, required this.heure});

//   factory Message.fromMap(Map<String, dynamic> data) {
//     return Message(
//       auteur: data['auteur'] ?? 'Inconnu',
//       contenu: data['contenu'] ?? '',
//       heure: (data['heure'] as Timestamp).toDate(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {'auteur': auteur, 'contenu': contenu, 'heure': heure};
//   }
// }
