// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/PeriodModel.dart';
import 'package:teish/Models/UserModel.dart';
import 'package:teish/Screens/Dashboard/Advice.dart';
import 'package:teish/Screens/Others/EditPeriod.dart';

class HomeScreen extends StatelessWidget {

  late double width , height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width *0.03, vertical: height * 0.01),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            upperRow(),
            detail(),

            SizedBox(height: height * 0.02,),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              margin: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.01),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: height * 0.015),
                child: Column(
                  children: [
                    Text('Learn about your cycle',
                        style: TextStyle(
                          color: CColors.textblack,
                          fontFamily: 'fb',
                          fontSize: 14,
                        )
                    ),
                    SizedBox(height: height * 0.015,),
                    Text('Mood and Hormones',
                        style: TextStyle(
                          color: CColors.textblack,
                          fontFamily: 'fh',
                          fontSize: 22,
                        )
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){

                Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                  var ind;
                  if(percent<=.25){
                    ind = 0;
                  }else if(percent < 0.5){
                    ind = 1;
                  }else if(percent < 0.75){
                    ind = 2;
                  }else{
                    ind = 3;
                  }
                  return Advice(ind);
                }));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                margin: EdgeInsets.only(left: width * 0.01,right: width * 0.01, bottom: height * 0.02),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: height * 0.015),
                  child: Column(
                    children: [
                      Text('Align with your cycle',
                          style: TextStyle(
                            color: CColors.textblack,
                            fontFamily: 'fb',
                            fontSize: 14,
                          )
                      ),
                      SizedBox(height: height * 0.015,),
                      Text('Coaching Advice',
                          style: TextStyle(
                            color: CColors.textblack,
                            fontFamily: 'fh',
                            fontSize: 22,
                          )
                      ),
                    ],

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget upperRow(){
    var databaseReference = FirebaseDatabase.instance.reference()
        .child("Users").child(FirebaseAuth.instance.currentUser!.uid);

    return StreamBuilder<DatabaseEvent>(
      stream: databaseReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // print();
        UserModel usermodel = UserModel.fromMap(snapshot.data!.snapshot.value as Map<dynamic , dynamic> );
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          ),
          child: Container(

            margin: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    // widget.dashboardInterface.check();
                  },
                  child: CircleAvatar(
                    radius: width * 0.07,
                    backgroundColor: CColors.blue,
                    backgroundImage: NetworkImage(usermodel.image ),
                  ),
                ),
                SizedBox(width: width * 0.02,),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, ${usermodel.name}' ,
                        style: TextStyle(
                          color: CColors.textblack,
                          fontFamily: 'fh',
                          fontSize: 22,
                        ),
                      ),
                      Text(DateFormat('dd MMM, yyyy\nhh:mm a').format(DateTime.now()) ,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  Widget detail(){
    // DocumentReference ref = FirebaseFirestore.instance.collection('Period')
    //     .doc(FirebaseAuth.instance.currentUser!.uid);


    var databaseReference = FirebaseDatabase.instance.reference()
        .child("Period").child(FirebaseAuth.instance.currentUser!.uid);


    return StreamBuilder<DatabaseEvent>(
      stream: databaseReference.onValue,
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Center(child: Text('${snapshot.error.toString()}'),);
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else if(!snapshot.hasData || snapshot.data!.snapshot.value == null){
          return Center(child: Text('No data found'),);
        }else{

          print(snapshot.data!.snapshot.value);

          // snapshot.data!.snapshot.value as Map<String, dynamic>;
          PeriodModel model = PeriodModel.fromMap(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);

          DateTime d = DateTime.now();

          DateTime cd = DateTime.fromMillisecondsSinceEpoch(model.date);

          int cycle = model.iwinter + model.ispring + model.isummer + model.ifall;
          print((d.difference(cd).inDays) );
          int days = (d.difference(cd).inDays + 1);
          int diff = days % cycle;


          if(diff == 0){
            diff = cycle;
          }
          print(diff);


          if(diff == 1 && days~/cycle > 0){
            databaseReference.update({
              'date' : DateFormat('dd-MM-yyyy').parse(DateFormat('dd-MM-yyyy').format(d)).millisecondsSinceEpoch
            });
          }


          percent = 0;
          if(diff <= model.iwinter){
            if(diff == model.iwinter){
              percent = 0.25;
            }else{
              int di = diff;
              double p = di/model.iwinter;
              double per = p * 0.25;

              percent = per;
            }
          }else if(diff <= model.iwinter + model.ispring){
            if(diff == model.iwinter + model.ispring){
              percent = 0.5;
            }else{

              int di = diff - model.iwinter;
              double p = di/model.ispring;
              double per = p * 0.25;

              percent = per + 0.25;

            }
          }else if(diff <= model.iwinter + model.ispring + model.isummer){
            if(diff == model.iwinter + model.ispring + model.isummer){
              percent = 0.75;
            }else{

              int di = diff - (model.iwinter + model.ispring);
              double p = di/model.isummer;
              double per = p * 0.25;

              percent = per + 0.5;


            }
          }else{
            if(diff >= model.iwinter + model.ispring + model.isummer + model.ifall){
              percent = 1;
            }else{

              int di = diff - (model.iwinter + model.ispring + model.isummer);
              double p = di/model.ifall;
              double per = p * 0.25;
              percent = per + 0.75;

            }
          }

          return Column(
            children: [

              Container(
                margin: EdgeInsets.symmetric(vertical: height * 0.03),
                child: Stack(
                  children: [
                    RotationTransition(
                      turns: AlwaysStoppedAnimation(
                          // percent
                        percent
                      ),
                      child: Container(
                        width: width * 0.85,
                        child: Image(
                          image: AssetImage('assets/images/phase.png'),
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(
                              0
                          ),
                          child: Container(
                            width: width * 0.45,
                            child: Image(
                              image: AssetImage('assets/images/pointer.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(child: Align(
                      alignment: Alignment.center,
                      child: ClipOval(
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          decoration: BoxDecoration(
                            color: CColors.blue,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(),
                              Text(percent <= 0.25 ? 'Inner Winter'
                                : percent <= 0.5 ? 'Inner Spring'
                                : percent <= 0.75 ? 'Inner Summer'
                                  : 'Inner Fall'

                                ,style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'fm',
                                  fontSize: width * 0.03
                              ),),
                              DottedLine(
                                dashColor: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text('Day $diff',style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'fh',
                                    fontSize: width * .05,
                                  ),),
                                  SizedBox(height: height * 0.01,),
                                  Text(DateFormat('EEEE | MMMM dd').format(DateTime.now()),style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'fm',
                                    fontSize: width * .03,
                                  ),),


                                ],
                              ),
                              DottedLine(
                                dashColor: Colors.white,
                              ),

                              InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                    return EditPeriod(model);
                                  }));
                                },
                                child: Text('Tap to change',style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'fm',
                                    fontSize: width * 0.03
                                ),),
                              ),

                              SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              Text('Day $diff of your cycle',style: TextStyle(
                  color: CColors.textblack,
                  fontSize: 15,
                  fontFamily: 'fb'
              ),),
            ],
          );
        }

      }
    );
  }

  double percent = 0;

}
