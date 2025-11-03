import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen1/home_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:kunft/provider/ReservationProvider.dart';
import 'package:kunft/widget/widget_book/widget_booking_card.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reservationProvider = Provider.of<ReservationProvider>(
        context,
        listen: false,
      );
      if (reservationProvider.reservations.isEmpty &&
          !reservationProvider.isLoading) {
        _fetchReservations();
      }
    });
  }

  Future<void> _fetchReservations() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.authToken;
    if (token != null) {
      await Provider.of<ReservationProvider>(
        context,
        listen: false,
      ).fetchUserReservations(authToken: token);
    } else {
      Provider.of<ReservationProvider>(
        context,
        listen: false,
      ).setErrorMessage('Veuillez vous connecter pour voir vos réservations.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Mes Réservations'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'En cours'),
              Tab(text: 'Confirmées'),
            ],
            padding: EdgeInsets.symmetric(horizontal: 16),
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            labelColor: Color(0xFF256AFD),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Color(0xFF256AFD), width: 4),
            ),
          ),
        ),
        backgroundColor: const Color(0x1A898989),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<ReservationProvider>(
            builder: (context, reservationProvider, child) {
              if (reservationProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
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

              final ongoingReservations = reservationProvider.reservations
                  .where((res) => res['status'] == 'En attente')
                  .toList();
              final confirmedReservations = reservationProvider.reservations
                  .where((res) => res['status'] == 'Confirmée')
                  .toList();

              return TabBarView(
                children: [
                  // ✅ Ajout du RefreshIndicator pour la première vue
                  RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: const Color(0xFF256AFD),
                    // Ajuste la position de l'indicateur
                    displacement: 40.0,
                    // Ajuste l'épaisseur du cercle de l'indicateur
                    strokeWidth: 3.0,
                    onRefresh: _fetchReservations,
                    child: _buildReservationList(
                      ongoingReservations,
                      'En attente',
                    ),
                  ),
                  // ✅ Ajout du RefreshIndicator pour la deuxième vue
                  RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: const Color(0xFF256AFD),
                    displacement: 40.0,
                    // Ajuste l'épaisseur du cercle de l'indicateur
                    strokeWidth: 3.0,
                    onRefresh: _fetchReservations,
                    child: _buildReservationList(
                      confirmedReservations,
                      'confirmée',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        // Bouton flottant de renvoie a Home
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          backgroundColor: const Color(0xFF256AFD),
          child: const Icon(LucideIcons.home, color: Colors.white),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        // --------------------------
      ),
    );
  }

  Widget _buildReservationList(List<dynamic> reservations, String status) {
    if (reservations.isEmpty) {
      String message = status == 'En attente'
          ? 'Aucune réservation en cours pour le moment.'
          : 'Aucune réservation confirmée pour le moment.';
      return Center(child: Text(message, textAlign: TextAlign.center));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        final logement = reservation['logement'];

        if (logement == null) {
          return const SizedBox.shrink();
        }

        final DateTime? dateDebut = reservation['date_debut'] != null
            ? DateTime.parse(reservation['date_debut'])
            : null;
        final DateTime? dateFin = reservation['date_fin'] != null
            ? DateTime.parse(reservation['date_fin'])
            : null;

        if (dateDebut == null || dateFin == null) {
          return const SizedBox.shrink();
        }

        // Utilisez toujours la première image (index 0) du logement, pas l'index de la réservation
        final images = logement['images'];
        String imageUrl = 'https://placehold.co/600x400';
        if (images != null && images.isNotEmpty) {
          imageUrl = images[0]['image_paths'] ?? imageUrl;
        }

        final price = reservation['prix_total'];

        return WidgetBookingCard(
          reservationData:
              reservation, // ✅ Passez l'objet de réservation complet ici
          imageUrl: imageUrl,
          title: logement['titre'] ?? 'Nom du logement inconnu',
          location: logement['quartier'] ?? 'Adresse inconnue',
          price: price.toString(),
          reservationstatus: reservation['status'] ?? 'Statut inconnu',
          dateDebut: dateDebut,
          dateFin: dateFin,
        );
      },
    );
  }
}



// -------------- Ancien Okay mais sans refresh ------------



// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:kunft/provider/UserProvider.dart';
// import 'package:kunft/provider/ReservationProvider.dart';
// import 'package:kunft/widget/widget_book/widget_booking_card.dart';

// class MyBooking extends StatefulWidget {
//   const MyBooking({super.key});

//   @override
//   State<MyBooking> createState() => _MyBookingState();
// }

// class _MyBookingState extends State<MyBooking> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // ✅ Check if reservations are already loaded
//       final reservationProvider = Provider.of<ReservationProvider>(
//         context,
//         listen: false,
//       );
//       if (reservationProvider.reservations.isEmpty &&
//           !reservationProvider.isLoading) {
//         _fetchReservations();
//       }
//     });
//   }

//   Future<void> _fetchReservations() async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final token = userProvider.authToken;
//     if (token != null) {
//       await Provider.of<ReservationProvider>(
//         context,
//         listen: false,
//       ).fetchUserReservations(authToken: token);
//     } else {
//       Provider.of<ReservationProvider>(
//         context,
//         listen: false,
//       ).setErrorMessage('Veuillez vous connecter pour voir vos réservations.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text('Mes Réservations'),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'En cours'),
//               Tab(text: 'Confirmées'),
//             ],
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             unselectedLabelColor: Colors.grey,
//             labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//             labelColor: Color(0xFF256AFD),
//             indicatorSize: TabBarIndicatorSize.tab,
//             indicator: UnderlineTabIndicator(
//               borderSide: BorderSide(color: Color(0xFF256AFD), width: 4),
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Consumer<ReservationProvider>(
//             builder: (context, reservationProvider, child) {
//               // Note: L'état de chargement et l'erreur sont gérés par le Provider,
//               // mais ils ne devraient apparaître que lors du premier chargement après le login.
//               if (reservationProvider.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (reservationProvider.errorMessage != null) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       reservationProvider.errorMessage!,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 );
//               }

//               final ongoingReservations = reservationProvider.reservations
//                   .where((res) => res['status'] == 'En attente')
//                   .toList();
//               final confirmedReservations = reservationProvider.reservations
//                   .where((res) => res['status'] == 'confirmée')
//                   .toList();

//               return TabBarView(
//                 children: [
//                   _buildReservationList(ongoingReservations, 'En attente'),
//                   _buildReservationList(confirmedReservations, 'confirmée'),
//                 ],
//               );
//             },
//           ),
//         ),
//         // ✅ Bouton d'action flottant
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             // ✅ La logique de navigation vers la page HomeScreen
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//             );
//           },
//           // Le style du bouton
//           backgroundColor: const Color(0xFF256AFD),
//           child: const Icon(LucideIcons.home, color: Colors.white),
//         ),

//         // ✅ Positionnement du bouton
//         floatingActionButtonLocation:
//             FloatingActionButtonLocation.miniEndDocked,
//       ),
//     );
//   }

//   Widget _buildReservationList(List<dynamic> reservations, String status) {
//     if (reservations.isEmpty) {
//       String message = status == 'En attente'
//           ? 'Aucune réservation en cours pour le moment.'
//           : 'Aucune réservation confirmée pour le moment.';
//       return Center(child: Text(message, textAlign: TextAlign.center));
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.only(top: 20),
//       itemCount: reservations.length,
//       itemBuilder: (context, index) {
//         final reservation = reservations[index];
//         final logement = reservation['logement'];

//         if (logement == null) {
//           return const SizedBox.shrink();
//         }

//         final DateTime? dateDebut = reservation['date_debut'] != null
//             ? DateTime.parse(reservation['date_debut'])
//             : null;
//         final DateTime? dateFin = reservation['date_fin'] != null
//             ? DateTime.parse(reservation['date_fin'])
//             : null;

//         if (dateDebut == null || dateFin == null) {
//           return const SizedBox.shrink();
//         }

//         // ✅ Corrected image and price retrieval
//         final images = logement['images'];
//         final imageUrl =
//             images[index]['image_paths'] ?? 'https://placehold.co/600x400';

//         final price = reservation['prix_total'];

//         return WidgetBookingCard(
//           imageUrl: imageUrl.toString(),
//           title: logement['titre'] ?? 'Nom du logement inconnu',
//           location: logement['quartier'] ?? 'Adresse inconnue',
//           price: price.toString(),
//           reservationstatus: reservation['status'] ?? 'Statut inconnu',
//           dateDebut: dateDebut,
//           dateFin: dateFin,
//         );
//       },
//     );
//   }
// }

