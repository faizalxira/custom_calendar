import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const CalenderScreenUI(),
      // body: const CustomCalendar(),
      // body: const CalendarScreen(),
      // body: const CalendarScreen1(),
    );
  }
}

final _currentMonthProvider = StateProvider.autoDispose<DateTime>((ref) {
  return DateTime.now();
});

class CalenderScreenUI extends StatefulWidget {
  const CalenderScreenUI({super.key});

  @override
  State<CalenderScreenUI> createState() => _CalenderScreenUIState();
}

class _CalenderScreenUIState extends State<CalenderScreenUI> {
  // ignore: prefer_final_fields
  PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);

  // DateTime _currentMonth = DateTime.now();
  bool selectedcurrentyear = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              return _buildHeader(ref);
            },
          ),
          _buildWeeks(),
          Expanded(
            child: Consumer(builder: (context, ref, child) {
              final currentMonth = ref.watch(_currentMonthProvider);

              return PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  // setState(() {
                  ref.read(_currentMonthProvider.notifier).state =
                      DateTime(currentMonth.year, index + 1, 1);
                  // _currentMonth = DateTime(currentMonth.year, index + 1, 1);
                  // });
                },
                itemCount:
                    12 * 10, // Show 10 years, adjust this count as needed
                itemBuilder: (context, pageIndex) {
                  DateTime month =
                      DateTime(currentMonth.year, (pageIndex % 12) + 1, 1);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: buildCalendar(month),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    // Checks if the current month is the last month of the year (December)
    final currentMonth = ref.watch(_currentMonthProvider);

    bool isLastMonthOfYear = currentMonth.month == 12;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Moves to the previous page if the current page index is greater than 0
              if (_pageController.page! > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          // Displays the name of the current month
          Text(
            DateFormat('MMMM').format(currentMonth),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          DropdownButton<int>(
            // Dropdown for selecting a year
            value: currentMonth.year,
            onChanged: (int? year) {
              if (year != null) {
                // setState(() {
                // Sets the current month to January of the selected year
                ref.read(_currentMonthProvider.notifier).state =
                    DateTime(year, 1, 1);

                // Calculates the month index based on the selected year and sets the page
                int yearDiff = DateTime.now().year - year;
                int monthIndex = 12 * yearDiff + currentMonth.month - 1;
                _pageController.jumpToPage(monthIndex);
                // });
              }
            },
            items: [
              // Generates DropdownMenuItems for a range of years from current year to 10 years ahead
              for (int year = DateTime.now().year;
                  year <= DateTime.now().year + 10;
                  year++)
                DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              // Moves to the next page if it's not the last month of the year
              if (!isLastMonthOfYear) {
                // setState(() {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                // });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeeks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildWeekDay('Mon'),
          _buildWeekDay('Tue'),
          _buildWeekDay('Wed'),
          _buildWeekDay('Thu'),
          _buildWeekDay('Fri'),
          _buildWeekDay('Sat'),
          _buildWeekDay('Sun'),
        ],
      ),
    );
  }

  Widget _buildWeekDay(String day) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildCalendar(DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;

    int totalDaysInGrid = 42;
    int daysInPreviousMonth = 0;
    // int daysFromNextMonth = 0;

    // Determine the number of days to display from the previous month
    if (weekdayOfFirstDay > 1) {
      daysInPreviousMonth = DateTime(month.year, month.month, 0).day;
    }

    // Calculate the number of days to show from the next month
    // int totalDaysInCurrentMonthAndPrevious =
    //     daysInMonth + (weekdayOfFirstDay - 1);
    // if (totalDaysInCurrentMonthAndPrevious < totalDaysInGrid) {
    //   daysFromNextMonth = totalDaysInGrid - totalDaysInCurrentMonthAndPrevious;
    // }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.6,
      ),
      itemCount: totalDaysInGrid,
      itemBuilder: (context, index) {
        if (index < weekdayOfFirstDay - 1) {
          int previousMonthDay =
              daysInPreviousMonth - (weekdayOfFirstDay - index) + 1;
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              previousMonthDay.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
          );
        } else if (index >= weekdayOfFirstDay - 1 + daysInMonth) {
          int nextMonthDay = index - (weekdayOfFirstDay - 1 + daysInMonth) + 1;
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              nextMonthDay.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
          );
        } else {
          DateTime date =
              DateTime(month.year, month.month, index - weekdayOfFirstDay + 2);

          final currentNow = DateTime.now();
          final currentDayYear = currentNow.day == date.day &&
              currentNow.year == currentNow.year &&
              date.month == currentNow.month;

          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: date.weekday == 7
                      ? Colors.lightBlueAccent.withOpacity(.2)
                      : currentDayYear
                          ? Colors.tealAccent.withOpacity(.5)
                          : Colors.blueAccent.withOpacity(0.1)),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontWeight:
                        currentDayYear ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
