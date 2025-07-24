import 'package:flutter/material.dart';
import 'package:kunft/pages/logements/type_logements/apparts.dart';
import 'package:kunft/pages/logements/type_logements/chambres.dart';
import 'package:kunft/pages/logements/type_logements/duplex.dart';
import 'package:kunft/pages/logements/type_logements/studio.dart';
import 'package:kunft/pages/logements/type_logements/tous_logements.dart';
import 'package:kunft/pages/logements/type_logements/villas.dart';
import 'package:kunft/widget/widget_horizontal_section_navigator.dart';

class ListLogement extends StatefulWidget {
  const ListLogement({super.key});

  @override
  State<ListLogement> createState() => _ListLogementState();
}

class _ListLogementState extends State<ListLogement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catégories Disponible'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            //
            Expanded(
              child: HorizontalSectionNavigator(
                sectionTitles: [
                  'Tous',
                  'Duplex',
                  'Villas',
                  'Appartements',
                  'Studios',
                  'Chambres',
                ],
                sectionContents: [
                  // page 1
                  TousLogements(),
                  // Autres pays
                  Duplex(),
                  // page 2
                  Villas(),
                  // page 3
                  Apparts(),
                  // page 4
                  Studio(),
                  // page 5
                  Chambres(),
                ],
                // Personnalisation optionnelle
                // navigationBarColor: Colors.deepPurple,
                // selectedTitleColor: Colors.amberAccent,
                // unselectedTitleColor: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
