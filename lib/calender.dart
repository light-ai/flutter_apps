import 'package:flutter/material.dart';
import 'package:flutter_app/schedulePage.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_app/schedule_model.dart';
import 'package:flutter_app/schedule.dart';
import 'package:provider/provider.dart';

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
  DateTime time = DateTime.now();

  void onDayPressed(DateTime dates, List<Event> events) {
    //Schedule schedule = context.select<ScheduleModel, Schedule>((model) => model.schedule);

    String monthDecide(){
      String monthEnglish;
      if(dates.month == 1){
        monthEnglish = "Jan";
      }else if(dates.month == 2){
        monthEnglish = "Feb";
      }
      else if(dates.month == 3){
        monthEnglish = "Mar";
      }
      else if(dates.month == 4){
        monthEnglish = "Apr";
      }
      else if(dates.month == 5){
        monthEnglish = "May";
      }
      else if(dates.month == 6){
        monthEnglish = "Jun";
      }
      else if(dates.month == 7){
        monthEnglish = "Jul";
      }
      else if(dates.month == 8){
        monthEnglish = "Aug";
      }
      else if(dates.month == 9){
        monthEnglish = "Sep";
      }
      else if(dates.month == 10){
        monthEnglish = "Oct";
      }
      else if(dates.month == 11){
        monthEnglish = "Nov";
      }
      else if(dates.month == 12){
        monthEnglish = "Dec";
      }
      return monthEnglish;
    }

    String year = dates.year.toString();
    String month = dates.month.toString();
    String day = dates.day.toString();
    String monthEnglish = monthDecide();

    this.setState(() => {
      _currentDate =  monthEnglish + " " + day + ", " + year,
      time = dates,
    },
    );
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        // 引数からユーザー情報を渡す
        ScheduleModel(_currentDate);
        return SchedulePage(_currentDate);
      }),
    );
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
              selectedDateTime: time,
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