import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

class WidgetBookingCalendar extends StatefulWidget {
  const WidgetBookingCalendar({super.key});

  @override
  State<WidgetBookingCalendar> createState() => _WidgetBookingCalendarState();
}

class _WidgetBookingCalendarState extends State<WidgetBookingCalendar> {
  // Date de début et de fin possibles dans le calendrier
  final DateTime _firstDate = DateTime.now();
  final DateTime _lastDate = DateTime.now().add(
    const Duration(days: 30),
  ); // Limite du nombre de mois

  // Plage de dates sélectionnée (initialement vide)
  dp.DatePeriod? _selectedPeriod;

  // Liste des dates à désactiver (exemple : réservées)
  final List<DateTime> _reservedDates = [
    // DateTime.now().add(const Duration(days: 3)),
    // DateTime.now().add(const Duration(days: 4)),
    // DateTime.now().add(const Duration(days: 10)),
  ];

  // Prédicat pour désactiver certaines dates
  bool _isSelectable(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return !_reservedDates.any(
      (d) => d.year == date.year && d.month == date.month && d.day == date.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = dp.DatePickerRangeStyles(
      selectedPeriodLastDecoration: BoxDecoration(
        color: const Color(0xFF007AFF),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      selectedPeriodStartDecoration: BoxDecoration(
        color: const Color(0xFF007AFF),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      selectedPeriodMiddleDecoration: BoxDecoration(
        color: Colors.blueGrey.shade300,
        shape: BoxShape.rectangle,
      ),
      selectedDateStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      defaultDateTextStyle: const TextStyle(color: Colors.black87),
      disabledDateStyle: const TextStyle(color: Colors.grey),
      dayHeaderStyle: const dp.DayHeaderStyle(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );

    return Column(
      children: [
        // Calendrier avec aucune pré-sélection
        Container(
          width: double.infinity,
          height: 370,
          decoration: BoxDecoration(
            // color: const Color(0xFFF0F4FF), // Fond de Calendrier
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: dp.RangePicker(
            selectedPeriod:
                _selectedPeriod ?? dp.DatePeriod(_firstDate, _firstDate),
            onChanged: (dp.DatePeriod newPeriod) {
              final start = newPeriod.start;
              final end = newPeriod.end;

              // On ne met à jour que si deux dates sont sélectionnées
              if (start != null && end != null && start != end) {
                bool hasDisabledDate = false;
                for (
                  DateTime date = start;
                  !date.isAfter(end);
                  date = date.add(const Duration(days: 1))
                ) {
                  if (!_isSelectable(date)) {
                    hasDisabledDate = true;
                    break;
                  }
                }

                if (hasDisabledDate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Plage invalide : contient des dates réservées.",
                      ),
                    ),
                  );
                  return;
                }

                setState(() {
                  _selectedPeriod = newPeriod;
                });
              }
            },

            firstDate: _firstDate,
            lastDate: _lastDate,
            datePickerStyles: styles,
            datePickerLayoutSettings: const dp.DatePickerLayoutSettings(
              showPrevMonthEnd: false,
              showNextMonthStart: false,
            ),
            selectableDayPredicate: _isSelectable,
            initiallyShowDate: DateTime.now(),
          ),
        ),
        const SizedBox(height: 35),
        // Champs Check-in / Check-out
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildDateField("Check in", _selectedPeriod?.start),
            buildDateField("Check out", _selectedPeriod?.end),
          ],
        ),
      ],
    );
  }

  Widget buildDateField(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFF2F2F2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date != null ? "${date.month}/${date.day}/${date.year}" : label,
                style: TextStyle(
                  fontSize: 14,
                  color: date != null ? Colors.black87 : Colors.grey,
                ),
              ),
              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}

// Ancien code simple

// import 'package:flutter/material.dart';
// import 'package:calendar_date_picker2/calendar_date_picker2.dart';

// class WidgetBookingCalendar extends StatefulWidget {
//   const WidgetBookingCalendar({super.key});

//   @override
//   State<WidgetBookingCalendar> createState() => _WidgetBookingCalendarState();
// }

// class _WidgetBookingCalendarState extends State<WidgetBookingCalendar> {
//   DateTime? checkIn;
//   DateTime? checkOut;

//   final config = CalendarDatePicker2WithActionButtonsConfig(
//     calendarType: CalendarDatePicker2Type.range,
//     selectedDayHighlightColor: Color(0xFF007AFF),
//     dayTextStyle: TextStyle(fontSize: 14, color: Colors.black87),
//     weekdayLabelTextStyle: TextStyle(
//       fontWeight: FontWeight.bold,
//       color: Colors.black54,
//     ),
//     firstDayOfWeek: 1, // Lundi
//     // centerAlignModePickerButton: true,
//     selectedRangeHighlightColor: Color(0xFF007AFF).withOpacity(0.15),
//     controlsTextStyle: TextStyle(color: Colors.black, fontSize: 16),
//     dayBorderRadius: BorderRadius.circular(8),
//   );

//   Future<void> showCalendar() async {
//     final results = await showCalendarDatePicker2Dialog(
//       context: context,
//       config: config,
//       dialogSize: const Size(325, 400),
//       borderRadius: BorderRadius.circular(20),
//       value: [checkIn, checkOut],
//     );

//     if (results != null && results.length >= 2) {
//       setState(() {
//         checkIn = results[0];
//         checkOut = results[1];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Calendrier affiché (optionnel)
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             // color: const Color(0xFFF2F6FF),
//             color: Colors.amber,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: CalendarDatePicker2(
//             config: config.copyWith(
//               calendarType: CalendarDatePicker2Type.single,
//             ),
//             value: [checkIn],
//             onValueChanged: (dates) {},
//           ),
//         ),
//         const SizedBox(height: 24),
//         // Champs Check-in / Check-out
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             buildDateField(
//               label: "Check in",
//               date: checkIn,
//               onTap: showCalendar,
//             ),
//             buildDateField(
//               label: "Check out",
//               date: checkOut,
//               onTap: showCalendar,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget buildDateField({
//     required String label,
//     DateTime? date,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: 140,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: const Color(0xFFF2F2F2),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   date != null
//                       ? "${date.day}/${date.month}/${date.year}"
//                       : label,
//                   style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 ),
//                 const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
