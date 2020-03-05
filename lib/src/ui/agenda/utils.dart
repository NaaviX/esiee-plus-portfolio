import 'package:flutter/material.dart';

class AgendaUtils{

  static bool sameDay(DateTime date, [DateTime target]) {
    target = target ?? DateTime.now();
    return date != null && target.year == date.year && target.month == date.month && target.day == date.day;
  }
  static addLeadingZero(int number) => (number < 10 ? '0' : '') + number.toString();
  static dateFormatter(int year, int month, int day) => addLeadingZero(day);
  static hourFormatter(int hour, int minute) => addLeadingZero(hour) + ':' + addLeadingZero(minute);
}

class DayBar extends StatelessWidget{
  DateTime date;

  DayBar({
    @required DateTime date
  }) : date = DateTime(date.year, date.month, date.day);

  Color backgroundColor = Colors.white70;
  static DateTime now = DateTime.now();
  static DateTime today = DateTime(now.year, now.month, now.day);

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: _DayBar(
          date: this.date
      )
    );
  }
  
  Widget _DayBar({DateTime date}){

    return Container(
      height: 40,
      width: 100,
      color: backgroundColor,
      child: Center(
        child: Text(
          AgendaUtils.dateFormatter(date.year, date.month, date.day),
          style: TextStyle(
            color: AgendaUtils.sameDay(date) ? Colors.blue[800] : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class HourBar extends StatelessWidget{
  Color backgroundColor = Colors.white70;

  @override
  Widget build(BuildContext context) => Container(
    height: 24*60.0,
    width: 50,
    color: backgroundColor,
    child: Stack(
      children: List.generate(
        13, (hour) => Positioned(
          top: (hour + 1) * 50 - ((TextStyle(color: Colors.black54)?.fontSize ?? 14) / 2),
          left: 0,
          right: 0,
          child: Text(
            AgendaUtils.hourFormatter(7 + hour + 1, 0),
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}

typedef TopOffsetCalculator = double Function(int hour);
class EventsColumnBackgroundPainter extends CustomPainter {
  /// The color.
  final Color backgroundColor;

  /// The rules color.
  final Color rulesColor;

  /// The top offset calculator.
  /// The day view state will give it its real value.
  TopOffsetCalculator topOffsetCalculator = defaultTopOffsetCalculator;

  /// Creates a new events column background painter.
  EventsColumnBackgroundPainter({
    this.backgroundColor,
    this.rulesColor = const Color(0x1A000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (backgroundColor != null) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = backgroundColor);
    }

    if (rulesColor != null) {
      for (int hour = 1; hour < 24; hour++) {
        double topOffset = topOffsetCalculator(hour);
        canvas.drawLine(Offset(0, topOffset), Offset(size.width, topOffset), Paint()..color = rulesColor);
      }
    }
  }

  @override
  bool shouldRepaint(EventsColumnBackgroundPainter oldDayViewBackgroundPainter) {
    return backgroundColor != oldDayViewBackgroundPainter.backgroundColor || rulesColor != oldDayViewBackgroundPainter.rulesColor || topOffsetCalculator != oldDayViewBackgroundPainter.topOffsetCalculator;
  }

  /// The default top offset calculator.
  static double defaultTopOffsetCalculator(int hour) => hour * 60.0;
}

class DayView extends StatelessWidget {

  final double hourBarWidth;
  final DateTime dayDate;

  DayView({
    @required double hourBarWidth,
    DateTime dayDate
  }) : hourBarWidth = 50, dayDate = DateTime(dayDate.year, dayDate.month, dayDate.day);

  static DateTime now = DateTime.now();
  static DateTime date = DateTime(now.year, now.month, now.day);

  double calculateTopOffset(int hour, [int minute = 0, double hourRowHeight]) => (hour - 9 + (minute / 60)) * (hourRowHeight ?? 60);
  double calculateHeight([double hourRowHeight]) => calculateTopOffset(24, 0, hourRowHeight);
  final EventsColumnBackgroundPainter eventsColumnBackgroundPainter = EventsColumnBackgroundPainter(
      backgroundColor: AgendaUtils.sameDay(date)
          ? const Color(0xFFE3F5FF)
          : const Color(0xFFF2F2F2));


  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    children.add(
      Positioned.fill(
          child: CustomPaint(
              painter: eventsColumnBackgroundPainter
          )
      )
    );
    if (dayDate != null && AgendaUtils.sameDay(dayDate)){
      children.add(
        Positioned(
          top: calculateTopOffset(now.hour, now.minute),
          left: 0,
          right: 0,
          child: Container(
            height: 1,
            color: Colors.pink,
          ),
        ),
      );
      children.add(
        Positioned(
          top: calculateTopOffset(now.hour, now.minute) - (15 / 2),
          left: 0,
          child: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return Stack(
    children: [
      Padding(
        padding: EdgeInsets.only(top: 40),
          child: SizedBox(
            width: (MediaQuery.of(context).size.width - 50) / 5,
            height: calculateHeight(),
            child: Stack(
                children: children
            ),
          ),
        ),
        DayBar(
          date: this.dayDate
      )]);
  }
}

class weekView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 0,
            left: 50,
            child: new DayView(dayDate: DateTime.now().subtract(Duration(days: 1)))),
        Positioned(
        top: 0,
        left: ((MediaQuery.of(context).size.width - 50) / 5)+50,
        child: new DayView(dayDate: DateTime.now())),
        Positioned(
        top: 0,
        left: 2*((MediaQuery.of(context).size.width - 50) / 5)+50,
        child: new DayView(dayDate: DateTime.now().add(Duration(days: 1)))),
        Positioned(
            top: 0,
            left: 3*((MediaQuery.of(context).size.width - 50) / 5)+50,
            child: new DayView(dayDate: DateTime.now().add(Duration(days: 2)))),
        Positioned(
            top: 0,
            left: 4*((MediaQuery.of(context).size.width - 50) / 5)+50,
            child: new DayView(dayDate: DateTime.now().add(Duration(days: 3)))),
        Positioned(
          top: 0,
          left: 0,
          child: HourBar(),
        ),
      ],
    );
  }

}