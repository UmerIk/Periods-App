import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Extras/SymptomData.dart';
import 'package:teish/Models/SymptomModel.dart';
import 'package:teish/Screens/Others/AddSymtoms.dart';
import 'package:table_calendar/table_calendar.dart';

class SymptomsScreen extends StatefulWidget {


  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  late double width , height;

  DateFormat sdf = DateFormat('MMM dd,yyyy');

  @override
  void initState() {
    dateTime = DateTime.now();
    date = sdf.format(dateTime);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            return AddSymtoms();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: CColors.yellow,
      ),
      body: Container(
        child: Column(
          children: [
            _tableCalendar(),
            Expanded(
                child: StreamBuilder<Event>(
                  stream: FirebaseDatabase.instance.reference().child("Users")
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .child("Symptoms").child(date).onValue,
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      FirebaseException e = snapshot.error as FirebaseException;
                      return Center(child: Text(e.message.toString()),);
                    }if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.hasData && snapshot.data!.snapshot.value != null){

                      SymptomModel model = SymptomModel.fromData(snapshot.data!.snapshot.value as Map<dynamic , dynamic>);
                      // return ListView.builder(
                      //   itemBuilder: (ctx , i){
                      //     return SymptomWidget(list[i]);
                      //   },
                      //   itemCount: list.length,
                      // );
                      return SymptomWidget(model);
                    }else{
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text('You didn\'t enter any record on this date, but you can enter now.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                  }
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableCalendar(){
    return TableCalendar(
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: CColors.pink,
        ),
        weekendStyle: TextStyle(
          color: CColors.pink,
        ),
      ),


      calendarStyle: CalendarStyle(
        selectedDecoration:  BoxDecoration(
          color: CColors.pink,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(),
        todayTextStyle: TextStyle(),
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },

      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      headerVisible: true,
      firstDay: DateTime.fromMillisecondsSinceEpoch(0),
      lastDay: DateTime.now(),
      focusedDay: dateTime,

      selectedDayPredicate: (date){
        return isSameDay(dateTime , date);
      },
      onDaySelected: (dt , dtt){
        setState(() {
          dateTime = dtt;
          date = sdf.format(dateTime);

          print(date);
        });
      },
    );
  }

  late String date;
  late DateTime dateTime;
}

class SymptomWidget extends StatelessWidget {
  late double width , height;

  SymptomModel model;

  SymptomWidget(this.model);

  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.05)
            ),
            margin: EdgeInsets.symmetric(horizontal: width * 0.05 ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.03),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: width * 0.3,
                            child: Column(
                              children: [
                                Text('Symptoms',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'fb',
                                ),),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                                  width: width * 0.2,
                                  height: width * 0.2,
                                  padding: EdgeInsets.all(width * 0.025),
                                  decoration: BoxDecoration(
                                    color: CColors.pink,
                                    shape: BoxShape.circle
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                      SymptomData.symptoms[model.symptom],
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(SymptomData.symptomsh[model.symptom],style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'fb',
                                ),),

                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: width * 0.3,
                            child: Column(
                              children: [
                                Text('Mood',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'fb',
                                ),),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                                  width: width * 0.2,
                                  height: width * 0.2,
                                  padding: EdgeInsets.all(width * 0.025),
                                  decoration: BoxDecoration(
                                    color: CColors.yellow,
                                    shape: BoxShape.circle
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                      SymptomData.mood[model.mood],
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(SymptomData.moodh[model.mood],style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'fb',
                                ),),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03,),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: width * 0.3,
                            child: Column(
                              children: [
                                Text('Sex',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'fb',
                                ),),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                                  width: width * 0.2,
                                  height: width * 0.2,
                                  padding: EdgeInsets.all(width * 0.025),
                                  decoration: BoxDecoration(
                                    color: CColors.blue,
                                    shape: BoxShape.circle
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                      SymptomData.sex[model.sex],
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(SymptomData.sexh[model.sex],style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'fb',
                                ),),

                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(

                            child: Column(
                              children: [
                                Text('Vaginal Discharge',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'fb',
                                ),),

                                Container(
                                  margin: EdgeInsets.symmetric(vertical: height * 0.01),
                                  width: width * 0.2,
                                  height: width * 0.2,
                                  padding: EdgeInsets.all(width * 0.025),
                                  decoration: BoxDecoration(
                                    color: CColors.brown,
                                    shape: BoxShape.circle
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                      SymptomData.vd[model.vd],
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(SymptomData.vdh[model.vd],style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'fb',
                                ),),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          model.note.trim() == "" ? SizedBox() :
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: height * 0.01),
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: Text(model.note,style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'fb',
                  fontSize: 17
                ),)
            ),
          ),
        ],
      ),
    );
  }
}