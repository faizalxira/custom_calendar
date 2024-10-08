// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class CalendarScreen1 extends StatefulWidget {
//   const CalendarScreen1({super.key});

//   @override
//   _CalendarScreen1State createState() => _CalendarScreen1State();
// }

// class _CalendarScreen1State extends State<CalendarScreen1> {
//   DateTime _currentDate = DateTime.now();
//   List<DateTime> _daysInMonth = [];
//   // ignore: prefer_final_fields
//   PageController _pageController =
//       PageController(initialPage: DateTime.now().month - 1);

//   @override
//   void initState() {
//     super.initState();
//     _generateDaysInMonth();
//   }

//   void _generateDaysInMonth() {
//     final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
//     final lastDayOfMonth =
//         DateTime(_currentDate.year, _currentDate.month + 1, 0);
//     final daysBefore =
//         firstDayOfMonth.weekday - 1; // Days before the first day of the month
//     final daysAfter =
//         7 - lastDayOfMonth.weekday; // Days after the last day of the month

//     final totalDays = lastDayOfMonth.day + daysBefore + daysAfter;
//     _daysInMonth = List.generate(totalDays, (index) {
//       if (index < daysBefore) {
//         return firstDayOfMonth.subtract(Duration(days: daysBefore - index));
//       } else if (index >= daysBefore + lastDayOfMonth.day) {
//         return lastDayOfMonth
//             .add(Duration(days: index - daysBefore - lastDayOfMonth.day + 1));
//       } else {
//         return DateTime(
//             _currentDate.year, _currentDate.month, index - daysBefore + 1);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _pageController.addListener(() {
//       // _pageController.
//       print(_currentDate.month);
//       print(_pageController.page);
//       setState(() {
//         if (_currentDate.month > _pageController.page!.round()) {
//           _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
//         } else {
//           _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
//         }
//         _generateDaysInMonth();
//       });
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Custom Calendar'),
//       ),
//       body: Column(
//         children: [
//           _buildHeader(),
//           _buildDaysOfWeek(),
//           Expanded(
//               child: PageView.builder(
//             controller: _pageController,
//             itemCount: 12 * 10, // Show 10 years, adjust this count as needed
//             // onPageChanged: (value) {
//             //   debugPrint('value $value');
//             //   setState(() {
//             //     _generateDaysInMonth();
//             //   });
//             // },
//             itemBuilder: (context, index) {
//               return _buildCalendar();
//             },
//           )),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             setState(() {
//               _currentDate =
//                   DateTime(_currentDate.year, _currentDate.month - 1, 1);
//               _generateDaysInMonth();
//             });
//           },
//         ),
//         Text(
//           DateFormat('MMMM yyyy').format(_currentDate),
//           style: const TextStyle(fontSize: 20),
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward),
//           onPressed: () {
//             setState(() {
//               _currentDate =
//                   DateTime(_currentDate.year, _currentDate.month + 1, 1);
//               _generateDaysInMonth();
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildDaysOfWeek() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: List.generate(7, (index) {
//         return Expanded(
//           child: Center(
//             child: Text(
//               DateFormat.E().format(DateTime(
//                   2021, 1, 3 + index)), // Assuming 2021-01-03 is Sunday
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildCalendar() {
//     return GridView.builder(
//       itemCount: _daysInMonth.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 7,
//         childAspectRatio: 1.0,
//       ),
//       itemBuilder: (context, index) {
//         final date = _daysInMonth[index];
//         final isCurrentMonth = date.month == _currentDate.month;

//         return GestureDetector(
//           onTap: () {},
//           child: Container(
//             margin: const EdgeInsets.all(2),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: isCurrentMonth
//                   ? date.day == DateTime.now().day &&
//                           date.month == DateTime.now().month
//                       ? Colors.red
//                       : Colors.blueAccent.withOpacity(0.1)
//                   : Colors.grey.withOpacity(0.1),
//             ),
//             child: Center(
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle(
//                   color: isCurrentMonth ? Colors.black : Colors.grey,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
