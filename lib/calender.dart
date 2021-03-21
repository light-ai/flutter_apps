import 'package:flutter/material.dart';
import 'package:flutter_app/schedulePage.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class CalenderExample extends StatefulWidget {
  CalenderExample(this.date);
  String date;
  @override
  State<StatefulWidget> createState() {
    return _CalenderExampleState(this.date);
  }
}

class _CalenderExampleState extends State<CalenderExample> {
  _CalenderExampleState(this.date);
  String _currentDate = DateTime.now().toString();
  String date;

  void onDayPressed(DateTime date, List<Event> events) {
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();
    this.setState(() => _currentDate = year + '-' + month + '-' + day);
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        // 引数からユーザー情報を渡す
        return SchedulePage(this.date);
      }),
    );*/
    print(_currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calender Example"),
        ),
        body: Container(
          child: CalendarCarousel<Event>(
              onDayPressed: onDayPressed,
              weekendTextStyle: TextStyle(color: Colors.red),
              thisMonthDayBorderColor: Colors.grey,
              weekFormat: false,
              height: 420.0,
              //selectedDateTime: _currentDate,
              daysHaveCircularBorder: false,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              markedDateShowIcon: true,
              markedDateIconMaxShown: 2,
              todayTextStyle: TextStyle(
                color: Colors.blue,
              ),
              markedDateIconBuilder: (event) {
                return event.icon;
              },
              todayBorderColor: Colors.green,
              markedDateMoreShowTotal: false),
        ));
  }
}