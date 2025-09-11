import 'package:flutter/material.dart';

class WidgetHouseImage1 extends StatelessWidget {
  final String imgHouse;
  final String houseName;
  final String price;
  final String locate;
  final String ownerName;
  final String time;
  final Function(String) onTapImage;
  final bool isSelected; // ✅ NOUVEAU PARAMÈTRE

  const WidgetHouseImage1({
    super.key,
    required this.imgHouse,
    required this.houseName,
    required this.price,
    required this.locate,
    required this.ownerName,
    required this.time,
    required this.onTapImage,
    this.isSelected = false, // ✅ Initialisé à false par défaut
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapImage(imgHouse),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(23.0),
          // ✅ Ajout d'une bordure si sélectionné
          border:
              isSelected
                  ? Border.all(color: const Color(0xcc2196F3), width: 2.0)
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                imgHouse,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 90,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text(
                        'Image non trouvée',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),

            //
            // Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         houseName,
            //         style: const TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16.0,
            //         ),
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //       const SizedBox(height: 4.0),
            //       Text(
            //         price,
            //         style: const TextStyle(
            //           color: Colors.green,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 14.0,
            //         ),
            //       ),
            //       const SizedBox(height: 4.0),
            //       Row(
            //         children: [
            //           const Icon(
            //             Icons.location_on,
            //             size: 16.0,
            //             color: Colors.grey,
            //           ),
            //           const SizedBox(width: 4.0),
            //           Expanded(
            //             child: Text(
            //               locate,
            //               style: const TextStyle(
            //                 color: Colors.grey,
            //                 fontSize: 12.0,
            //               ),
            //               maxLines: 1,
            //               overflow: TextOverflow.ellipsis,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 4.0),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             ownerName,
            //             style: const TextStyle(
            //               color: Colors.blueAccent,
            //               fontSize: 12.0,
            //             ),
            //           ),
            //           Text(
            //             time,
            //             style: const TextStyle(
            //               color: Colors.grey,
            //               fontSize: 10.0,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
