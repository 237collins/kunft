// ----- Nouveau code avec Callback

import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class WidgetBookingCalendar extends StatefulWidget {
  // Déclaration de la fonction de callback
  final Function(DateTime? startDate, DateTime? endDate) onDatesSelected;

  const WidgetBookingCalendar({
    super.key,
    required this.onDatesSelected,
    required void Function(DateTime? startDate, DateTime? endDate)
    onDateRangeSelected, // Rendez-la obligatoire
  });

  @override
  State<WidgetBookingCalendar> createState() => _WidgetBookingCalendarState();
}

class _WidgetBookingCalendarState extends State<WidgetBookingCalendar> {
  List<DateTime?> _selectedDates = [];

  bool _isSelectable(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkedDay = DateTime(day.year, day.month, day.day);
    return checkedDay.isAfter(today) || checkedDay.isAtSameMomentAs(today);
  }

  late final config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.range,
    firstDayOfWeek: 1, // Lundi
    selectedDayHighlightColor: const Color(0xFF007AFF),
    selectedRangeHighlightColor: const Color(0x40007AFF),
    dayTextStyle: const TextStyle(fontSize: 14, color: Colors.black87),
    weekdayLabelTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
    ),
    dayBorderRadius: BorderRadius.circular(30),
    selectableDayPredicate: _isSelectable,
    selectedDayTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    selectedRangeDayTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final DateTime? checkIn =
        _selectedDates.isNotEmpty ? _selectedDates[0] : null;
    final DateTime? checkOut =
        _selectedDates.length > 1 ? _selectedDates[1] : null;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 290,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(25),
          ),
          child: CalendarDatePicker2(
            config: config,
            value: _selectedDates,
            onValueChanged: (dates) {
              setState(() {
                _selectedDates = dates;
              });

              // Appelez la fonction de callback ici
              final DateTime? startDate =
                  _selectedDates.isNotEmpty ? _selectedDates[0] : null;
              final DateTime? endDate =
                  _selectedDates.length > 1 ? _selectedDates[1] : null;
              widget.onDatesSelected(startDate, endDate);
            },
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildDateField("Date début", checkIn),
            buildDateField("Date fin", checkOut),
          ],
        ),
      ],
    );
  }

  Widget buildDateField(String label, DateTime? date) {
    String displayText = label;
    if (date != null) {
      displayText = DateFormat('dd-MM-yyyy').format(date);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 10),
        Container(
          width: 160,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFF2F2F2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 15,
                  color: date != null ? Colors.black87 : Colors.grey,
                  fontWeight: FontWeight.w700,
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

// ------ Ancien code statique

// import 'package:flutter/material.dart';
// import 'package:calendar_date_picker2/calendar_date_picker2.dart';
// import 'package:intl/intl.dart';

// class WidgetBookingCalendar extends StatefulWidget {
//   const WidgetBookingCalendar({super.key});

//   @override
//   State<WidgetBookingCalendar> createState() => _WidgetBookingCalendarState();
// }

// class _WidgetBookingCalendarState extends State<WidgetBookingCalendar> {
//   // Plage de dates sélectionnée
//   List<DateTime?> _selectedDates = [];

//   // Prédicat pour désactiver les jours passés
//   bool _isSelectable(DateTime day) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final checkedDay = DateTime(day.year, day.month, day.day);
//     return checkedDay.isAfter(today) || checkedDay.isAtSameMomentAs(today);
//   }

//   // Configuration du sélecteur de dates
//   late final config = CalendarDatePicker2Config(
//     calendarType: CalendarDatePicker2Type.range,
//     firstDayOfWeek: 1, // Lundi
//     selectedDayHighlightColor: const Color(0xFF007AFF),
//     selectedRangeHighlightColor: const Color(0x40007AFF),
//     dayTextStyle: const TextStyle(fontSize: 14, color: Colors.black87),
//     weekdayLabelTextStyle: const TextStyle(
//       fontWeight: FontWeight.bold,
//       color: Colors.black54,
//     ),
//     dayBorderRadius: BorderRadius.circular(30),
//     selectableDayPredicate: _isSelectable,

//     // --- NOUVEAUX STYLES AJUSTÉS POUR LES JOURS SÉLECTIONNÉS ---
//     selectedDayTextStyle: const TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.bold,
//     ),
//     selectedRangeDayTextStyle: const TextStyle(
//       color: Colors.white,
//       fontWeight: FontWeight.bold,
//     ),
//     // -----------------------------------------------------------
//   );

//   @override
//   Widget build(BuildContext context) {
//     final DateTime? checkIn =
//         _selectedDates.isNotEmpty ? _selectedDates[0] : null;
//     final DateTime? checkOut =
//         _selectedDates.length > 1 ? _selectedDates[1] : null;

//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           height: 300,
//           decoration: BoxDecoration(
//             color: Colors.blue.shade100,
//             borderRadius: BorderRadius.circular(25),
//           ),
//           child: CalendarDatePicker2(
//             config: config,
//             value: _selectedDates,
//             onValueChanged: (dates) {
//               setState(() {
//                 _selectedDates = dates;
//               });
//             },
//           ),
//         ),
//         const SizedBox(height: 25),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             buildDateField("Date début", checkIn),
//             buildDateField("Date fin", checkOut),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget buildDateField(String label, DateTime? date) {
//     String displayText = label;
//     if (date != null) {
//       displayText = DateFormat('dd-MM-yyyy').format(date);
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           width: 160,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: const Color(0xFFF2F2F2),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 displayText,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: date != null ? Colors.black87 : Colors.grey,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// Ancien code avec flutter_date_pickers

// import 'package:flutter/material.dart';
// import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

// class WidgetBookingCalendar extends StatefulWidget {
//   const WidgetBookingCalendar({super.key});

//   @override
//   State<WidgetBookingCalendar> createState() => _WidgetBookingCalendarState();
// }

// class _WidgetBookingCalendarState extends State<WidgetBookingCalendar> {
//   // Date de début et de fin possibles dans le calendrier
//   final DateTime _firstDate = DateTime.now();
//   final DateTime _lastDate = DateTime.now().add(
//     const Duration(days: 40),
//   ); // Limite du nombre de mois

//   // Plage de dates sélectionnée (initialement vide)
//   dp.DatePeriod? _selectedPeriod;

//   // Liste des dates à désactiver (exemple : réservées)
//   final List<DateTime> _reservedDates = [
//     // DateTime.now().add(const Duration(days: 3)),
//     // DateTime.now().add(const Duration(days: 4)),
//     // DateTime.now().add(const Duration(days: 10)),
//   ];

//   // Prédicat pour désactiver certaines dates
//   bool _isSelectable(DateTime day) {
//     final date = DateTime(day.year, day.month, day.day);
//     return !_reservedDates.any(
//       (d) => d.year == date.year && d.month == date.month && d.day == date.day,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final styles = dp.DatePickerRangeStyles(
//       selectedPeriodLastDecoration: BoxDecoration(
//         color: const Color(0xFF007AFF),
//         borderRadius: const BorderRadius.only(
//           topRight: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       selectedPeriodStartDecoration: BoxDecoration(
//         color: const Color(0xFF007AFF),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(30),
//           bottomLeft: Radius.circular(30),
//         ),
//       ),
//       selectedPeriodMiddleDecoration: BoxDecoration(
//         color: Colors.blueGrey.shade300,
//         shape: BoxShape.rectangle,
//       ),
//       selectedDateStyle: const TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//       ),
//       defaultDateTextStyle: const TextStyle(color: Colors.black87),
//       disabledDateStyle: const TextStyle(color: Colors.grey),
//       dayHeaderStyle: const dp.DayHeaderStyle(
//         textStyle: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.black54,
//         ),
//       ),
//     );

//     return Column(
//       children: [
//         // Calendrier avec aucune pré-sélection
//         Container(
//           width: double.infinity,
//           height: 350,
//           decoration: BoxDecoration(
//             // color: const Color(0xFFF0F4FF), // Fond de Calendrier
//             color: Colors.blue.shade100,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: dp.RangePicker(
//             selectedPeriod:
//                 _selectedPeriod ?? dp.DatePeriod(_firstDate, _firstDate),
//             onChanged: (dp.DatePeriod newPeriod) {
//               final start = newPeriod.start;
//               final end = newPeriod.end;

//               // On ne met à jour que si deux dates sont sélectionnées
//               if (start != null && end != null && start != end) {
//                 bool hasDisabledDate = false;
//                 for (
//                   DateTime date = start;
//                   !date.isAfter(end);
//                   date = date.add(const Duration(days: 1))
//                 ) {
//                   if (!_isSelectable(date)) {
//                     hasDisabledDate = true;
//                     break;
//                   }
//                 }

//                 if (hasDisabledDate) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         "Plage invalide : contient des dates réservées.",
//                       ),
//                     ),
//                   );
//                   return;
//                 }

//                 setState(() {
//                   _selectedPeriod = newPeriod;
//                 });
//               }
//             },

//             firstDate: _firstDate,
//             lastDate: _lastDate,
//             datePickerStyles: styles,
//             datePickerLayoutSettings: const dp.DatePickerLayoutSettings(
//               showPrevMonthEnd: false,
//               showNextMonthStart: false,
//             ),
//             selectableDayPredicate: _isSelectable,
//             initiallyShowDate: DateTime.now(),
//           ),
//         ),
//         const SizedBox(height: 25),
//         // Champs Check-in / Check-out
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             buildDateField("Check in", _selectedPeriod?.start),
//             buildDateField("Check out", _selectedPeriod?.end),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget buildDateField(String label, DateTime? date) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           width: 160,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: const Color(0xFFF2F2F2),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 date != null ? "${date.month}/${date.day}/${date.year}" : label,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: date != null ? Colors.black87 : Colors.grey,
//                 ),
//               ),
//               const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

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
