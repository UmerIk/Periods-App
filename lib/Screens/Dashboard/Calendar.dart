import 'dart:collection';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/PeriodModel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teish/Widgets/NumberPicker.dart';

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
  Widget datawidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
            ),
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: height * 0.025),
              child: Column(
                children: [
                  _tableCalendar(),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            if(days > 0){
                              setState(() {
                                days --;
                              });
                            }
                          },
                          child: Image(
                              image: AssetImage('assets/icons/pre.png'),
                            width: 60,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: NumberPicker(
                              itemCount: 1,
                              axis: Axis.horizontal,
                              itemHeight: 100,
                              itemWidth: width * 0.5,
                              minValue: 0,
                              maxValue: 4,
                              value: days,
                              onChanged: (val){
                                setState(() {
                                  this.days = val;
                                });
                              },
                              options: seasons,
                              selectedTextStyle: TextStyle(
                                color: days == 0 ? CColors.pink : days == 1 ?
                                CColors.blue : days == 2 ? CColors.yellow :days == 3 ? CColors.brown : CColors.darkestgray,
                                fontSize: 30,
                                fontFamily: 'fh',
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(days < 4){
                              setState(() {
                                days ++;
                              });
                            }
                          },
                          child: Image(
                            image: AssetImage('assets/icons/next.png'),
                            width: 60,
                          ),
                        ),


                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: height * 0.01,),
          days == 4 ? SizedBox() :
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.03),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text('Populate Calendar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'fh',
                    ),
                  ),
                  SizedBox(height: height * 0.005,),
                  Text('By doing this all the information of this season will be updated on your calendar.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'fm',
                    ),
                  ),
                  SizedBox(height: height * 0.005,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: days == 0 ? CColors.pink : days == 1 ?
                        CColors.blue : days == 2 ? CColors.yellow : days == 3 ? CColors.brown : CColors.darkestgray,
                      ),
                      onPressed: (){
                        String title;
                        DateTime sdt = DateTime.now();
                        DateTime edt = DateTime.now();
                        DateTime dt = DateTime.fromMillisecondsSinceEpoch(model.date);

                        if(days == 0){
                           title = 'Inner Winter';
                           sdt = dt;
                           edt = dt.add(Duration(days: model.iwinter - 1));
                        }else if(days == 1){
                          title = 'Inner Spring';


                          sdt = dt.add(Duration(days: model.iwinter));
                          edt = dt.add(Duration(days: (model.iwinter + model.ispring) - 1));
                        }else if(days == 2){
                          title = 'Inner Summer';

                          sdt = dt.add(Duration(days: model.iwinter + model.ispring));
                          edt = dt.add(Duration(
                              days: (model.iwinter + model.ispring + model.isummer) - 1)
                          );
                        }else{
                          title = 'Inner Fall';

                          sdt = dt.add(Duration(days: model.iwinter + model.ispring + model.isummer));
                          edt = dt.add(Duration(
                              days: (model.iwinter + model.ispring + model.isummer + model.ifall) - 1)
                          );
                        }
                        Event event = Event(
                          title: title,
                          description: '',
                          startDate: sdt,
                          endDate: edt,
                          iosParams: IOSParams(
                            reminder: Duration(/* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
                          ),
                          androidParams: AndroidParams(
                            emailInvites: [], // on Android, you can add invite emails to your event.
                          ),
                        );
                        // Add2Calendar.addEvent2Cal(event);
                      },
                      child: Text('Populate',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  List<String> seasons = [
    'Inner Winter',
    'Inner Spring',
    'Inner Summer',
    'Inner Fall',
    'Crossover Days'
  ];

  Widget _tableCalendar(){
    DateTime lpdate = DateTime.fromMillisecondsSinceEpoch(model.date);
    DateTime cdate = DateTime.now();
    DateTime mfdate = DateFormat('dd-MM-yyyy').parse('01-${cdate.month}-${cdate.year}');
    // int diff = cdate.difference(lpdate).inDays;
    int cycle = model.iwinter + model.ispring + model.isummer + model.ifall;
    DateTime ldate = Jiffy(mfdate).add(months: 2).dateTime;
    int d = ldate.difference(mfdate).inDays;
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

    crossdays = LinkedHashSet<DateTime>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    int counter = 0;
    for(int i = 1 ; i <= d ; i ++){
      var element = DateFormat('dd-MM-yyyy').parse('$i-${cdate.month}-${cdate.year}');
      int dd = element.difference(lpdate).inDays + 1;
      if(dd < 0){
        dd = 0;
      }
      int ta = model.iwinter + model.isummer + model.ispring + model.ifall;

      int dayac = getday(dd, cycle);
      if(dayac != 0 && counter < ta){
        counter ++;
        if(dayac <= model.iwinter){
          iwinterdays.add(element);
        }else if(dayac <= (model.iwinter + model.ispring)){
          ispringdays.add(element);
        }else if(dayac <= (model.iwinter + model.ispring + model.isummer)){
          isummerdays.add(element);
        }else{
          ifalldays.add(element);
        }
      }


    }

    crossdays.add(iwinterdays.last);
    crossdays.add(isummerdays.last);
    crossdays.add(ispringdays.last);
    crossdays.add(ifalldays.last);

    return TableCalendar(
      // eventLoader: _getEventsForDay,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.black,
        ),
        weekendStyle: TextStyle(
          color: days == 0 ? CColors.pink : days == 1 ?
          CColors.blue : days == 2 ? CColors.yellow : days == 3 ? CColors.brown : CColors.darkestgray,
        ),
      ),

      selectedDayPredicate: (day) {
        return days == 0 ? iwinterdays.contains(day) :
        days == 1 ? ispringdays.contains(day) :
        days == 2 ? isummerdays.contains(day) : days == 3 ? ifalldays.contains(day)
            : crossdays.contains(day);
      },

      calendarStyle: CalendarStyle(
        todayTextStyle: TextStyle(
            color: Colors.black
        ),
        todayDecoration:  BoxDecoration(
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: days == 0 ? CColors.pink : days == 1 ?
          CColors.blue : days == 2 ? CColors.yellow : days == 3 ? CColors.brown : CColors.darkestgray,
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
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.month,

      onDaySelected: (day, day1){


        DateTime fdate = DateFormat('dd-MM-yyyy').parse(DateFormat('dd-MM-yyyy').format(day));
        DateTime cdate = DateFormat('dd-MM-yyyy').parse(DateFormat('dd-MM-yyyy').format(DateTime.now()));

        if(fdate.millisecondsSinceEpoch > cdate.millisecondsSinceEpoch){
          return;
        }
        int season = 0;

        if(iwinterdays.isNotEmpty && iwinterdays.last == fdate){
          season = 1;
        }else if(ispringdays.isNotEmpty && ispringdays.last == fdate){
          season = 2;
        }else if(isummerdays.isNotEmpty  && isummerdays.last == fdate){
          season = 3;
        }else if(ifalldays.isNotEmpty && ifalldays.last == fdate){
          season = 4;
        }
        _showPicker(context, fdate, season: season);
      },
      headerVisible: true,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: days == 0 ? CColors.pink : days == 1 ?
          CColors.blue : days == 2 ? CColors.yellow : days == 3 ? CColors.brown : CColors.darkestgray,
          fontFamily: 'fh',
          fontSize: 18
        ),
        headerPadding: EdgeInsets.only(bottom: height * 0.04)
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

  late Set<DateTime> iwinterdays, ispringdays, isummerdays, ifalldays , crossdays;

  int days = 0;

  int getday(int day , int cycle){
    if(day > cycle){
      return getday(day - cycle, cycle);
    }else{
      return day;
    }
  }
  void _showPicker(context, DateTime dateTime, {int season = 0}) {
    print(dateTime);
    int days = 0;
    if(season == 1){
      days = model.iwinter;
    }else if(season == 2){
      days = model.ispring;
    }else if(season == 3){
      days = model.isummer;
    }else if(season == 4){
      days = model.ifall;
    }
    var seasons = ['' ,'iwinter' , 'ispring', 'isummer', 'ifall'];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Period start Date',style: TextStyle(
                          color: Colors.black
                      ),),
                      onTap: () {
                        // print(DateFormat('dd-MM-yyyy').parse(DateFormat('dd-MM-yyyy').format(dateTime)));
                        setStart(dateTime);
                        Navigator.of(context).pop();
                      }),

                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Period end Date',style: TextStyle(
                      color: Colors.black
                    ),),
                    onTap: () {
                      DateTime date = dateTime.subtract(Duration(days: model.iwinter - 1));

                      setEnd(date);
                      Navigator.of(context).pop();
                    },
                  ),

                  season != 0 && days < 9?
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Move Forward',style: TextStyle(
                      color: Colors.black
                    ),),
                    onTap: () {
                      if(season == 1){
                        movecrossover(model.iwinter + 1, seasons[season]);
                      }else if(season == 2){
                        movecrossover(model.ispring + 1, seasons[season]);
                      }else if(season == 3){
                        movecrossover(model.isummer + 1, seasons[season]);
                      }else if(season == 4){
                        movecrossover(model.ifall + 1, seasons[season]);
                      }
                      Navigator.of(context).pop();
                    },
                  )
                      :
                  Container(),
                  season != 0 && days > 2?
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Move Backward',style: TextStyle(
                      color: Colors.black
                    ),),
                    onTap: () {

                      if(season == 1){
                        movecrossover(model.iwinter - 1, seasons[season]);
                      }else if(season == 2){
                        movecrossover(model.ispring - 1, seasons[season]);
                      }else if(season == 3){
                        movecrossover(model.isummer - 1, seasons[season]);
                      }else if(season == 4){
                        movecrossover(model.ifall - 1, seasons[season]);
                      }

                      Navigator.of(context).pop();
                    },
                  )
                      :
                  Container(),
                ],
              ),
            ),
          );
        }
    );
  }
  setStart(DateTime dateTime){
    print(dateTime);
    ref.update({
      'date' : dateTime.millisecondsSinceEpoch
    });
  }
  setEnd(DateTime dateTime){
    ref.update({
      'date' : dateTime.millisecondsSinceEpoch
    });
  }
  movecrossover(int days , String season){
    ref.update({
      season : days
    });
  }
}