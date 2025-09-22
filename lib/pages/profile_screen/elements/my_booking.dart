import 'package:flutter/material.dart';
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
      // ✅ Check if reservations are already loaded
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
            labelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.blue, width: 4),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Consumer<ReservationProvider>(
            builder: (context, reservationProvider, child) {
              // Note: L'état de chargement et l'erreur sont gérés par le Provider,
              // mais ils ne devraient apparaître que lors du premier chargement après le login.
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

              final ongoingReservations = reservationProvider.reservations
                  .where((res) => res['statuts'] == 'en_attente')
                  .toList();
              final confirmedReservations = reservationProvider.reservations
                  .where((res) => res['statuts'] == 'confirmée')
                  .toList();

              return TabBarView(
                children: [
                  _buildReservationList(ongoingReservations, 'en_attente'),
                  _buildReservationList(confirmedReservations, 'confirmée'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReservationList(List<dynamic> reservations, String statuts) {
    if (reservations.isEmpty) {
      String message = statuts == 'en_attente'
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

        // ✅ Corrected image and price retrieval
        final images = logement['images'];
        final imageUrl = (images != null && images.isNotEmpty)
            ? images[0]['url'] ?? 'https://placehold.co/600x400'
            : 'https://placehold.co/600x400';

        final price = (logement['prix_par_nuit'] is int)
            ? logement['prix_par_nuit']
            : 0.0;

        return WidgetBookingCard(
          imageUrl: imageUrl,
          title: logement['titre'] ?? 'Nom du logement inconnu',
          location: logement['quartier'] ?? 'Adresse inconnue',
          price: price,
          reservationStatuts: reservation['statuts'] ?? 'Statut inconnu',
          dateDebut: dateDebut,
          dateFin: dateFin,
        );
      },
    );
  }
}


// -------- Code statique


// import 'package:flutter/material.dart';
// import 'package:kunft/widget/widget_book/widget_booking_card.dart';

// class MyBooking extends StatefulWidget {
//   const MyBooking({super.key});

//   @override
//   State<MyBooking> createState() => _MyBookingState();
// }

// class _MyBookingState extends State<MyBooking> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Le nombre d'onglets
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           title: const Text('Mes Réservations'),
//           bottom: TabBar(
//             tabs: [Tab(text: 'Encours'), Tab(text: 'Confirmées')],
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             unselectedLabelColor: Colors.grey,
//             labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//             labelColor: Colors.blue,
//             indicatorSize:
//                 TabBarIndicatorSize.tab, // L'indicateur a la longueur du texte
//             indicator: UnderlineTabIndicator(
//               borderSide: BorderSide(
//                 color: Colors.blue,
//                 width: 4, // Épaisseur de l'indicateur
//               ),
//               // insets: EdgeInsets.symmetric(horizontal: 10),
//               borderRadius: BorderRadius.circular(10), // Marge horizontale
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: const TabBarView(
//             children: [
//               Center(
//                 child: Column(
//                   children: [SizedBox(height: 20), WidgetBookingCard()],
//                 ),
//               ),
//               //
//               Center(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       'Contenu des tâches terminées',
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
