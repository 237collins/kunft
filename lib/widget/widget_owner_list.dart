import 'package:flutter/material.dart';
import 'package:kunft/pages/broker_details.dart'; // Assurez-vous que ce chemin est correct
// Importez la constante API_BASE_URL depuis votre LogementProvider
import 'package:kunft/provider/logement_provider.dart' show API_BASE_URL;

class WidgetOwnerList extends StatefulWidget {
  final Map<String, dynamic>
  ownerData; // ✅ MODIFIÉ : Passe toutes les données du propriétaire
  final bool withSpacing;

  const WidgetOwnerList({
    Key? superkey,
    required this.ownerData, // Requis : toutes les données du propriétaire
    this.withSpacing = true,
  }) : super(key: superkey);

  @override
  State<WidgetOwnerList> createState() => _WidgetOwnerListState();
}

class _WidgetOwnerListState extends State<WidgetOwnerList> {
  @override
  Widget build(BuildContext context) {
    // Extraire les données nécessaires de ownerData pour l'affichage local
    final String imgUrl =
        (widget.ownerData['profile_image'] != null &&
                widget.ownerData['profile_image'].isNotEmpty)
            ? '$API_BASE_URL/storage/${widget.ownerData['profile_image']}'
            : 'https://placehold.co/600x400/png';

    // final String name = widget.ownerData['name'] ?? 'Inconnu'; // Affichage du nom tel au'en base
    final String name = (widget.ownerData['name'] ?? 'Inconnu').toUpperCase();

    // Premiere lettre en majuscule
    // String rawName = widget.ownerData['name'] ?? 'Inconnu';
    // final String name =
    //     rawName.isNotEmpty
    //         ? rawName[0].toUpperCase() + rawName.substring(1).toLowerCase()
    //         : 'Inconnu';

    // Assurez-vous que 'logements_count' est bien la clé pour le nombre de propriétés
    final String number = (widget.ownerData['logements_count'] ?? 0).toString();

    return GestureDetector(
      onTap: () {
        // ✅ MODIFIÉ : Redirige vers BrokerDetails en passant toutes les données du propriétaire
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrokerDetails(ownerData: widget.ownerData),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10), // Ajout de const
        width: 100,
        height: 100,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ), // Ajout de const
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xffd9d9d9), // Ajout de const
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    name,
                    style: const TextStyle(
                      // Ajout de const
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Affichage de nombre de propriétés
                    Text(
                      number,
                      style: const TextStyle(
                        // Ajout de const
                        color: Color(0xcc010101),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      ' Logements',
                      style: TextStyle(
                        color: Color(0xcc010101),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.withSpacing) const SizedBox(width: 15), // Ajout de const
          ],
        ),
      ),
    );
  }
}


// Code Statique


// import 'package:flutter/material.dart';
// import 'package:kunft/pages/broker_details.dart';

// class WidgetOwnerList extends StatefulWidget {
//   final String img;
//   final String number;
//   final String name;
//   final bool withSpacing;

//   const WidgetOwnerList({
//     Key? key,
//     Key? superkey,
//     required this.img,
//     required this.number,
//     required this.name,
//     this.withSpacing = true,
//   }) : super(key: superkey);

//   @override
//   State<WidgetOwnerList> createState() => _WidgetOwnerListState();
// }

// class _WidgetOwnerListState extends State<WidgetOwnerList> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const BrokerDetails()),
//         );
//       },
//       child: Container(
//         margin: EdgeInsets.only(right: 10),
//         width: 100,
//         height: 100,
//         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               // padding: EdgeInsets.all(3),
//               decoration: BoxDecoration(
//                 color: Color(0xffd9d9d9),
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                 child: Image.network(widget.img, fit: BoxFit.cover),
//               ),
//             ),
//             SizedBox(height: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   widget.name,
//                   style: TextStyle(
//                     color: Color(0xff010101),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Affichage de nombre de propriétés
//                     Text(
//                       widget.number,
//                       // '01',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 8,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       ' Property',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 8,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             if (widget.withSpacing) SizedBox(width: 15),
//           ],
//         ),
//       ),
//     );
//   }
// }
