import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/widget/widget_book/widget_booking_calendar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DatePage extends StatefulWidget {
  const DatePage({super.key});

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(LucideIcons.arrowLeft),
                  ),
                ),
                SizedBox(width: 20),
                Text('reservation'),
              ],
            ),
            //
            Column(
              children: [
                Text('Selectionnez une date'),
                WidgetBookingCalendar(),
                //
                SizedBox(height: 30),
                //
                Column(
                  children: [
                    Text('Note au proprietaire'),
                    Container(
                      height: 230,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(hintText: 'Notes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
