import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:kunft/provider/ReservationProvider.dart';

class MyBooking2 extends StatefulWidget {
  const MyBooking2({super.key});

  @override
  State<MyBooking2> createState() => _MyBooking2State();
}

class _MyBooking2State extends State<MyBooking2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchReservations();
    });
  }

  Future<void> _fetchReservations() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.authToken;

    await Provider.of<ReservationProvider>(
      context,
      listen: false,
    ).fetchUserReservations(authToken: token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Réservations')),
      body: Consumer<ReservationProvider>(
        builder: (context, reservationProvider, child) {
          if (reservationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reservationProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  reservationProvider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (reservationProvider.reservations.isEmpty) {
            return const Center(
              child: Text('Vous n\'avez aucune réservation pour le moment.'),
            );
          }

          return ListView.builder(
            itemCount: reservationProvider.reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservationProvider.reservations[index];
              final logement = reservation['logement'];

              if (logement == null) {
                return const Card(
                  child: ListTile(
                    title: Text('Détails du logement non disponibles'),
                  ),
                );
              }

              // ✅ Add a null check for the image list
              final images = logement['images'];
              final hasImage = images != null && images.isNotEmpty;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: hasImage
                      ? SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              images[0]['url'] as String,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : null,
                  title: Text(
                    // ✅ Correct the key from 'nom' to 'titre' and add a null check
                    logement['titre'] ?? 'Titre non disponible',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Statut: ${reservation['statuts'] ?? 'N/A'}'),
                      // ✅ Correct the key from 'adresse' to 'quartier'
                      Text(
                        'Adresse: ${logement['quartier'] ?? 'Adresse non disponible'}',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// // lib/pages/my_reservations_page.dart

// import 'package:flutter/material.dart';
// import 'package:kunft/provider/UserProvider.dart';
// import 'package:provider/provider.dart';
// import 'package:kunft/provider/ReservationProvider.dart';

// class MyBooking2 extends StatefulWidget {
//   const MyBooking2({super.key});

//   @override
//   State<MyBooking2> createState() => _MyBooking2State();
// }

// class _MyBooking2State extends State<MyBooking2> {
//   @override
//   void initState() {
//     super.initState();
//     _fetchReservations();
//   }

//   // ✅ Récupère les réservations en utilisant le token du UserProvider
//   Future<void> _fetchReservations() async {
//     // 1. Accédez à l'instance de UserProvider
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     // 2. Récupérez le token via son getter
//     final token = userProvider.authToken;

//     // 3. Passez le token au ReservationProvider
//     await Provider.of<ReservationProvider>(
//       context,
//       listen: false,
//     ).fetchUserReservations(authToken: token);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Écoute les changements dans ReservationProvider
//     return Scaffold(
//       appBar: AppBar(title: const Text('Mes Réservations')),
//       body: Consumer<ReservationProvider>(
//         builder: (context, reservationProvider, child) {
//           if (reservationProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (reservationProvider.errorMessage != null) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   reservationProvider.errorMessage!,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             );
//           }

//           if (reservationProvider.reservations.isEmpty) {
//             return const Center(
//               child: Text('Vous n\'avez aucune réservation pour le moment.'),
//             );
//           }

//           // Affiche la liste des réservations
//           return ListView.builder(
//             itemCount: reservationProvider.reservations.length,
//             itemBuilder: (context, index) {
//               final reservation = reservationProvider.reservations[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title: Text(
//                     'Réservation #${reservation['id']}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text('Statut: ${reservation['status']}'),
//                   // Ajoutez d'autres détails ici
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
