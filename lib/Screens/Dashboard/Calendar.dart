import 'dart:collection';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/PeriodModel.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late PeriodModel model;
  late double width , height;
  DocumentReference ref = FirebaseFirestore.instance.collection('Period')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
              stream: ref.snapshots(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Center(child: Text('${snapshot.error.toString()}'),);
                }else if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                else if(!snapshot.hasData || !snapshot.data!.exists){
                  return Center(child: Text('No data found'),);
                }else{
                  model = PeriodModel.fromMap(snapshot.data!.data() as Map<String , dynamic>);
                  return datawidget();
                }

              }
          ),
        ),
      ),
    );
  }

  Container datawidget() {
    return Container(
      child: Column(
        children: [
          _tableCalendar(),


          Row(
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.015),

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: CColors.pink
                      ),
                      onPressed: () {
                        if(days == 0){
                          return;
                        }
                        setState(() {
                          days = 0;
                        });
                      },
                      child: Text('Inner Winter',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: CColors.blue
                      ),
                      onPressed: () {
                        if(days == 1){
                          return;
                        }
                        setState(() {
                          days = 1;
                        });
                      },
                      child: Text('Inner Spring',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: CColors.yellow
                      ),
                      onPressed: () {
                        if(days == 2){
                          return;
                        }
                        setState(() {
                          days = 2;
                        });
                      },
                      child: Text('Inner Summer',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  )
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.015),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: CColors.brown
                      ),
                      onPressed: () {
                        if(days == 3){
                          return;
                        }
                        setState(() {
                          days = 3;
                        });
                      },
                      child: Text('Inner Fall',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar(){


    DateTime lpdate = DateTime.fromMillisecondsSinceEpoch(model.date);
    DateTime cdate = DateTime.now();
    DateTime mfdate = DateFormat('dd-MM-yyyy').parse('01-${cdate.month}-${cdate.year}');

    int diff = cdate.difference(lpdate).inDays;


    int cycle = model.iwinter + model.ispring + model.isummer + model.ifall;


    DateTime ldate;
    if(mfdate.month == 12){
      ldate = DateFormat('dd-MM-yyyy').parse('01-01-${cdate.year + 1}');
    }else{
      ldate = DateFormat('dd-MM-yyyy').parse('01-${cdate.month + 1}-${cdate.year}');
    }


    int d = ldate.difference(mfdate).inDays;
    List<DateTime> dates = [];

    ifalldays = LinkedHashSet<DateTime>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    iwinterdays = LinkedHashSet<DateTime>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    isummerdays = LinkedHashSet<DateTime>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    ispringdays = LinkedHashSet<DateTime>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    for(int i = 1 ; i <= d ; i ++){
      var date = DateFormat('dd-MM-yyyy').parse('$i-${cdate.month}-${cdate.year}');
      dates.add(date);
    }
    dates.forEach((element) {
      int dd = element.difference(lpdate).inDays + 1;
      if(dd < 0){
        dd = 0;
      }
      int dayac = getday(dd, cycle);

      if(dayac != 0){
        if(dayac <= model.iwinter){
          iwinterdays.add(element);
        }else if(dayac <= model.iwinter + model.ispring){
          ispringdays.add(element);
        }else if(dayac <= model.iwinter + model.ispring + model.isummer){
          isummerdays.add(element);
        }else{
          ifalldays.add(element);
        }
      }
    });

    return TableCalendar<Event>(
      // eventLoader: _getEventsForDay,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.black,
        ),
        weekendStyle: TextStyle(
          color: days == 0 ? CColors.pink : days == 1 ?
          CColors.blue : days == 2 ? CColors.yellow : CColors.brown,
        ),
      ),

      selectedDayPredicate: (day) {
        return days == 0 ? iwinterdays.contains(day) :
        days == 1 ? ispringdays.contains(day) :
        days == 2 ? isummerdays.contains(day) : ifalldays.contains(day);
      },

      calendarStyle: CalendarStyle(
        todayTextStyle: TextStyle(
            color: Colors.black
        ),
        todayDecoration:  BoxDecoration(
          // color: CColors.pink,
          // shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: days == 0 ? CColors.pink : days == 1 ?
          CColors.blue : days == 2 ? CColors.yellow : CColors.brown,
        ),
        selectedTextStyle: TextStyle(
            color: Colors.white
        ),
        markerDecoration: BoxDecoration(
            color: CColors.pink,
            shape: BoxShape.circle
        ),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.none,
      calendarFormat: CalendarFormat.month,

      onDaySelected: (day, day1){
        print(day);
      },
      headerVisible: true,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        titleCentered: true
      ),
      lastDay: ldate.subtract(Duration(days: 1)),
      firstDay: mfdate,
      focusedDay: DateTime.now(),
    );
  }

  late DateTime rsdate;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  late Set<DateTime> iwinterdays, ispringdays, isummerdays, ifalldays;

  int days = 0;

  int getday(int day , int cycle){
    if(day > cycle){
      return getday(day - cycle, cycle);
    }else{
      return day;
    }
  }

  Event event = Event(
    title: 'Event title',
    description: 'Event description',
    location: 'Event location',
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    iosParams: IOSParams(
      reminder: Duration(/* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
    ),
    androidParams: AndroidParams(
      emailInvites: [], // on Android, you can add invite emails to your event.
    ),
  );
}