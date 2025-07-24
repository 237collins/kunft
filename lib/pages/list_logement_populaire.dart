import 'package:flutter/material.dart';
import 'package:kunft/pages/logements/populaires/apparts.dart';
import 'package:kunft/pages/logements/populaires/chambres.dart';
import 'package:kunft/pages/logements/populaires/duplex.dart';
import 'package:kunft/pages/logements/populaires/studio.dart';
import 'package:kunft/pages/logements/populaires/tous_logements.dart';
import 'package:kunft/pages/logements/populaires/villas.dart';
import 'package:kunft/widget/widget_horizontal_section_navigator.dart';

class ListLogementPopulaire extends StatefulWidget {
  const ListLogementPopulaire({super.key});

  @override
  State<ListLogementPopulaire> createState() => _ListLogementPopulaireState();
}

class _ListLogementPopulaireState extends State<ListLogementPopulaire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meublés Populaires'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            //
            // SizedBox(height: 15),

            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: const [
            //       WidgetPropertyCategory(number: '01', name: 'Duplex'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '02', name: 'Villas'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '03', name: 'Appartements'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '04', name: 'Studio'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '03', name: 'Chambres'),
            //     ],
            //   ),
            // ),
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
