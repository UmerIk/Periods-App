import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/PeriodModel.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {

  late PeriodModel model;
  late double width , height;

  DocumentReference ref = FirebaseFirestore.instance.collection('Period')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
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
              return Container(
                child: Column(
                  children: [
                    _tableCalendar(),
                  ],
                ),
              );
            }

          }
      ),
    );
  }


  Widget _tableCalendar(){


    DateTime lpdate = DateTime.fromMillisecondsSinceEpoch(model.date);
    DateTime cdate = DateTime.now();
    DateTime ddate = DateFormat('dd-MM-yyyy').parse('01-${cdate.month}-${cdate.year}');

    int diff = cdate.difference(lpdate).inDays;
    print(diff);

    int cycle = model.iwinter + model.ispring + model.isummer + model.ifall;

    int cycles = (diff~/cycle);
    print(cycles);

    int remaining = diff % cycle;
    print(remaining);


    if(lpdate.add(Duration(days: ((cycles + 1) * cycle) + (cycle~/2))).month == cdate.month){
      ovulatindate = lpdate.add(Duration(days: ((cycles + 1) * cycle) + (cycle~/2)));
    }else{
      ovulatindate = lpdate.add(Duration(days: (cycles * cycle) + (cycle~/2)) );
    }

    if(lpdate.add(Duration(days: ((cycles + 1) * cycle))).month == cdate.month){
      rsdate = lpdate.add(Duration(days: ((cycles + 1) * cycle)));
    }else{
      rsdate = lpdate.add(Duration(days: (cycles * cycle)));
    }

    DateTime ldate;
    if(ddate.month == 12){
      ldate = DateFormat('dd-MM-yyyy').parse('01-01-${cdate.year + 1}');
    }else{
      ldate = DateFormat('dd-MM-yyyy').parse('01-${cdate.month + 1}-${cdate.year}');
    }






    //--------------------------
    _selectedDays = LinkedHashSet<DateTime>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    Map<DateTime , List<Event>> map = Map();
    for(int i = 0 ;i < 7 ; i ++){
      map[ ovulatindate.add(Duration(days: i))] = [Event('Event $i')];
      _selectedDays.add(rsdate.add(Duration(days: i)));
    }
    _kEventSource = Map.fromIterable(List.generate(0, (index) => index),
        key: (item) => DateTime.utc(2020, 10, item * 5),
        value: (item) => List.generate(
            item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
      ..addAll(map);


    kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);





    //--------------------------




    return TableCalendar<Event>(
      eventLoader: _getEventsForDay,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: CColors.pink,
        ),
        weekendStyle: TextStyle(
          color: CColors.pink,
        ),
      ),

      selectedDayPredicate: (day) {

        // Use values from Set to mark multiple days as selected
        return _selectedDays.contains(day);
      },

      // rangeStartDay: rsdate,
      // rangeEndDay: rsdate.add(Duration(days: model.day)),



      calendarStyle: CalendarStyle(
        todayTextStyle: TextStyle(
            color: Colors.black
        ),
        todayDecoration:  BoxDecoration(
          // color: CColors.pink,
          // shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(

        ),
        selectedTextStyle: TextStyle(
            color: CColors.blue
        ),
        markerDecoration: BoxDecoration(
            color: CColors.pink,
            shape: BoxShape.circle
        ),

      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.month,

      headerVisible: false,
      lastDay: cdate.month == rsdate.add(Duration(days: 7)).month ?
      ldate.subtract(Duration(days: 1)) : rsdate.add(Duration(days: 7 - 1)),
      firstDay: ddate,
      focusedDay: DateTime.now(),
    );
  }


  late DateTime rsdate , ovulatindate;

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  var kEvents;

  var _kEventSource;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  late Set<DateTime> _selectedDays;
}
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}