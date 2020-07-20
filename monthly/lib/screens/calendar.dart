import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:monthly/constants.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    final _selectedDay = DateTime.now();

    _events = {
      _selectedDay.subtract(Duration(days: 4)): [
        [1, 'SBUX', 'starbucks', 100000],
        [0, 'SBUX', 'starbucks', 100000],
        [1, 'SBUX', 'starbucks', 100000],
      ],
      _selectedDay.subtract(Duration(days: 2)): [
        [1, 'SBUX', 'starbucks', 100000],
        [0, 'SBUX', 'starbucks', 100000],
        [1, 'SBUX', 'starbucks', 100000],
        [1, 'SBUX', 'starbucks', 100000],
        [0, 'SBUX', 'starbucks', 100000],
        [1, 'SBUX', 'starbucks', 100000],
      ],
      _selectedDay: [
        [1, 'SBUX', 'starbucks', 10000],
        [0, 'APPL', 'apple', 34000],
      ],
      _selectedDay.add(Duration(days: 1)): [
        [1, 'SBUX', 'starbucks', 100000],
        [0, 'SBUX', 'starbucks', 100000],
        [1, 'SBUX', 'starbucks', 100000],
      ],
      _selectedDay.add(Duration(days: 7)): [
        [1, 'SBUX', 'starbucks', 100000],
        [0, 'SBUX', 'starbucks', 100000],
        [1, 'SBUX', 'starbucks', 100000],
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  bool _isSameDate(DateTime other) {
    var now = DateTime.now();
    return now.year == other.year &&
        now.month == other.month &&
        now.day == other.day;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          titleSpacing: 0.0,
          centerTitle: false,
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "배당금 달력",
              style: TextStyle(
                  color: kTextColor, fontWeight: FontWeight.bold, fontSize: 27),
            ),
          ),
          floating: true,
          backgroundColor: Colors.white,
        ),
        SliverFillRemaining(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTableCalendarWithBuilders(),
                Expanded(child: _buildEventList()),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // Simple TableCalendar configuration (using Styles)

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'ko_KR',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        weekendStyle: TextStyle().copyWith(color: Colors.blueGrey),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(
          color: Colors.blueGrey,
        ),
      ),
      headerStyle: HeaderStyle(
        titleTextStyle:
            TextStyle().copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: _isSameDate(date) ? Color(0xffF2D49B) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xff84BFA4), //                   <--- border color
                width: 3.0,
              ),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Color(0xffF2D49B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 14.0),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                height: 75,
                decoration: BoxDecoration(
                  color: event[0] == 0 ? kMainColor : Color(0xffF25B7F),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(
                    event[0] == 0 ? "배당락일" : "지급일",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "티커/종목",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              '${event[1]} ${event[2]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "금액",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              '￦${event[3].round().toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Color(0xff145A6A)
            : Color(0xff248EA6),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }
}
