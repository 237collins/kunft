import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_animation3.dart';
import 'package:kunft/widget/widget_broker_infos.dart';
import 'package:kunft/widget/widget_broker_list.dart';
import 'package:kunft/widget/widget_owner_profile.dart';
import 'package:kunft/widget/widget_owner_profile2.dart';
import 'package:kunft/widget/widget_property_top_nav_bar2.dart';

class BrokerDetails extends StatefulWidget {
  const BrokerDetails({super.key});

  @override
  State<BrokerDetails> createState() => _BrokerDetailsState();
}

class _BrokerDetailsState extends State<BrokerDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WidgetPropertyTopNavBar2(title: 'Broker Detail'),
            SizedBox(height: 5),
            WidgetAnimation3(
              img:
                  'https://www.marbella-hills-homes.com/cms/wp-content/uploads/2018/04/mh2940_2_villa-at-night.jpg',
            ),

            // Ce widget est temporaire
            SizedBox(height: 10),
            WidgetOwnerProfile2(
              ownerName: 'Momo',
              imgOwner:
                  'https://images.pexels.com/photos/697509/pexels-photo-697509.jpeg?cs=srgb&dl=pexels-andrewperformance1-697509.jpg&fm=jpg',
            ),

            //
            SizedBox(height: 15),
            //
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: WidgetBrokerInfos(
                follower: '1K',
                following: '13.K',
                property: '230',
              ),
            ),
            //
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Broker’s',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xffffd055),
                  ),
                ),
              ],
            ),
            //
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Appel de Widget ici
                  WidgetBrokerList(brokerName: 'Momo', propertyNumber: '5'),
                  WidgetBrokerList(brokerName: 'Collins', propertyNumber: '3'),
                  WidgetBrokerList(brokerName: 'Loanne', propertyNumber: '15'),
                  WidgetBrokerList(brokerName: 'Anne', propertyNumber: '20'),
                ],
              ),
            ),
            //
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'logement les plus visités',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xffffd055),
                  ),
                ),
              ],
            ),
            // Afichage du Listview Widget_House_Infos 2 et 3
            Text('Afichage du Listview Widget_House_Infos 2 et 3'),
          ],
        ),
      ),
    );
  }
}
