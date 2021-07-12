import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/PeriodModel.dart';
import 'package:teish/Screens/Auth/Checkdata.dart';
class LastPeriodScreen extends StatefulWidget {

  @override
  _LastPeriodScreenState createState() => _LastPeriodScreenState();
}

class _LastPeriodScreenState extends State<LastPeriodScreen> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addData(BuildContext context) async{

    print(sdate.millisecondsSinceEpoch);
    // return;
    PeriodModel model = PeriodModel(sdate.millisecondsSinceEpoch);

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference()
        .child("Period").child(FirebaseAuth.instance.currentUser!.uid);

    databaseReference.set(model.toMap()).then((value){
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx)=> Home()), (route) => false);

      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) => CheckData()),
          ModalRoute.withName('/'));
    }).catchError((error){
      setState(() {
        isadding = false;
      });

      Fluttertoast.showToast(msg: "Something went wrong");
    });

    return;

    await firestore.collection('Period').doc(FirebaseAuth.instance.currentUser!.uid)
        .set(model.toMap()).then((value) => {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) => CheckData()),
          ModalRoute.withName('/')),
    }).catchError((error){
      setState(() {
        isadding = false;
      });
      print(error);
    });
  }

  DateTime sdate = DateTime.now();
  Widget _cal(){
    return Container(
      height: 350,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        initialDateTime: DateTime.now(),
        minimumDate: DateTime.now().subtract(Duration(days: 30)),
        maximumDate: DateTime.now(),
        onDateTimeChanged: (DateTime newDateTime) {
          sdate = newDateTime;
        },
      ),
    );
  }
  bool isadding = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(

          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02,),
                    GestureDetector(
                      onTap: ()=> Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back ,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    SizedBox(height: height * 0.02,),
                    Text('When did your last period start?' , style: TextStyle(
                      color: CColors.textblack,
                      fontSize: 22,
                      fontFamily: 'fh',
                    ),),
                    SizedBox(height: height * 0.01,),
                    Text('We calculate it using a 28-day menstural cycle.' ,style: TextStyle(
                      fontSize: 15,
                      color: Color(0x80000000),
                      fontFamily: 'fm',
                    ),),

                    SizedBox(height: height * 0.01,),

                    _cal(),

                    SizedBox(height: height * 0.01,),

                    isadding ?
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    ) :
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape:  StadiumBorder(),
                        ),

                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            child: Text('Next',style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: "fh"
                            ),
                            ),
                          ),
                          onPressed: (){
                            setState(() {
                              isadding = true;
                            });
                            addData(context);
                          }),
                    ),

                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}