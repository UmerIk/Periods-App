import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Extras/SymptomData.dart';
import 'package:teish/Extras/functions.dart';
import 'package:teish/Models/SymptomModel.dart';

class AddSymtoms extends StatelessWidget {


  late double width , height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).padding,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                        child: ImageIcon(
                            AssetImage('assets/icons/backios.png')
                        )
                    ),
                    Text('Hormonal Behaviour',style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontFamily: 'fh',
                    ),),
                    ImageIcon(AssetImage('assets/icons/backios.png'),color: Colors.transparent,),
                  ],
                ),

                symptomscard(),

                textcard(),

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: height * 0.02),
                      primary: CColors.pink
                    ),
                    onPressed: (){
                      _bottomsheetdate(context);
                    },
                    child: Text('Save Symptoms',style: TextStyle(
                       color: Colors.white
                    ),)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textcard(){
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.05)
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:width * 0.05, vertical: height * 0.01),
        child: TextField(
          controller: ct,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Note'
          ),

          maxLines: 5,
          minLines: 5,
        ),
      ),
    );
  }
  Widget symptomscard() {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: height * 0.03, horizontal: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.05)
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        child: Column(
          children: [
            SizedBox(height: height * 0.01,),

            StatefulBuilder(
                builder: (ctx, setState) {
                  return Container(
                    child: Column(
                      children: [
                        Text('Symptoms', style: TextStyle(
                            color: CColors.pink,
                            fontFamily: 'fb',
                            fontSize: 18
                        ),),
                        SizedBox(height: height * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  si = 0;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.symptoms[0],
                                      ),
                                      color: si == 0 ? CColors.pink : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.symptomsh[0], style: TextStyle(
                                      color: si == 0 ? CColors.pink : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  si = 1;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.symptoms[1],
                                      ),
                                      color: si == 1 ? CColors.pink : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.symptomsh[1], style: TextStyle(
                                      color: si == 1 ? CColors.pink : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  si = 2;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.symptoms[2],
                                      ),
                                      color: si == 2 ? CColors.pink : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.symptomsh[2], style: TextStyle(
                                    color: si == 2 ? CColors.pink : CColors
                                        .icolor,
                                    fontSize: 9,
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  si = 3;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.symptoms[3],
                                      ),
                                      color: si == 3 ? CColors.pink : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.symptomsh[3], style: TextStyle(
                                      color: si == 3 ? CColors.pink : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  si = 4;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.symptoms[4],
                                      ),
                                      color: si == 4 ? CColors.pink : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.symptomsh[4], style: TextStyle(
                                      color: si == 4 ? CColors.pink : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            ),
            SizedBox(height: height * 0.02,),
            StatefulBuilder(
                builder: (ctx, setState) {
                  return Container(
                    child: Column(
                      children: [
                        Text('Mood', style: TextStyle(
                            color: CColors.yellow,
                            fontFamily: 'fb',
                            fontSize: 18
                        ),),
                        SizedBox(height: height * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 0;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.mood[0],
                                      ),
                                      color: sei == 0 ? CColors.yellow : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.moodh[0], style: TextStyle(
                                      color: sei == 0 ? CColors.yellow : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 1;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.mood[1],
                                      ),
                                      color: sei == 1 ? CColors.yellow : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.moodh[1], style: TextStyle(
                                      color: sei == 1 ? CColors.yellow : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 2;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.mood[2],
                                      ),
                                      color: sei == 2 ? CColors.yellow : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.moodh[2], style: TextStyle(
                                    color: sei == 2 ? CColors.yellow : CColors
                                        .icolor,
                                    fontSize: 9,
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 3;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.mood[3],
                                      ),
                                      color: sei == 3 ? CColors.yellow : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.moodh[3], style: TextStyle(
                                      color: sei == 3 ? CColors.yellow : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 4;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.mood[4],
                                      ),
                                      color: sei == 4 ? CColors.yellow : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.moodh[4], style: TextStyle(
                                      color: sei == 4 ? CColors.yellow : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            ),
            SizedBox(height: height * 0.02,),

            StatefulBuilder(
                builder: (ctx, setState) {
                  return Container(
                    child: Column(
                      children: [
                        Text('Sex', style: TextStyle(
                            color: CColors.brown,
                            fontFamily: 'fb',
                            fontSize: 18
                        ),),
                        SizedBox(height: height * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 0;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.sex[0],
                                      ),
                                      color: sei == 0 ? CColors.brown : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.sexh[0], style: TextStyle(
                                      color: sei == 0 ? CColors.brown : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 1;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.sex[1],
                                      ),
                                      color: sei == 1 ? CColors.brown : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.sexh[1], style: TextStyle(
                                      color: sei == 1 ? CColors.brown : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 2;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.sex[2],
                                      ),
                                      color: sei == 2 ? CColors.brown : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.sexh[2], style: TextStyle(
                                    color: sei == 2 ? CColors.brown : CColors
                                        .icolor,
                                    fontSize: 9,
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 3;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.sex[3],
                                      ),
                                      color: sei == 3 ? CColors.brown : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.sexh[3], style: TextStyle(
                                      color: sei == 3 ? CColors.brown : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  sei = 4;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.sex[4],
                                      ),
                                      color: sei == 4 ? CColors.brown : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.sexh[4], style: TextStyle(
                                      color: sei == 4 ? CColors.brown : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            ),
            SizedBox(height: height * 0.02,),

            StatefulBuilder(
                builder: (ctx, setState) {
                  return Container(
                    child: Column(
                      children: [
                        Text('Vaginal Discharge', style: TextStyle(
                            color: CColors.blue,
                            fontFamily: 'fb',
                            fontSize: 18
                        ),),
                        SizedBox(height: height * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  vdi = 0;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.vd[0],
                                      ),
                                      color: vdi == 0 ? CColors.blue : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.vdh[0], style: TextStyle(
                                      color: vdi == 0 ? CColors.blue : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  vdi = 1;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.vd[1],
                                      ),
                                      color: vdi == 1 ? CColors.blue : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.vdh[1], style: TextStyle(
                                      color: vdi == 1 ? CColors.blue : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  vdi = 2;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.vd[2],
                                      ),
                                      color: vdi == 2 ? CColors.blue : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.vdh[2], style: TextStyle(
                                    color: vdi == 2 ? CColors.blue : CColors
                                        .icolor,
                                    fontSize: 9,
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  vdi = 3;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.vd[3],
                                      ),
                                      color: vdi == 3 ? CColors.blue : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.vdh[3], style: TextStyle(
                                      color: vdi == 3 ? CColors.blue : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  vdi = 4;
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                        color: CColors.gray,
                                        shape: BoxShape.circle
                                    ),
                                    child: Image(
                                      image: AssetImage(
                                        SymptomData.vd[4],
                                      ),
                                      color: vdi == 4 ? CColors.blue : CColors
                                          .icolor,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01,),
                                  Text(SymptomData.vdh[4], style: TextStyle(
                                      color: vdi == 4 ? CColors.blue : CColors
                                          .icolor,
                                      fontSize: 9
                                  ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            ),
            SizedBox(height: height * 0.01,),

          ],
        ),
      ),
    );
  }


  int mi = 0;
  int vdi = 0;
  int sei = 0;
  int si = 0;
  var ct = TextEditingController();


  void addData(BuildContext context , DateTime dateTime){

    Functions().showLoaderDialog(context, text: 'Saving Symptom');
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String key = DateFormat('MMM dd,yyyy').format(dateTime);
        // firebaseFirestore.collection('Users').doc(uid).collection('Symptoms').doc().id;

    SymptomModel model = SymptomModel(key, ct.text, si, sei, vdi, mi , DateFormat('MMM dd,yyyy').format(dateTime));

    firebaseFirestore.collection('Users').doc(uid).collection('Symptoms')
        .doc(key).set(model.toMap()).then((value){
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 10)).then((value){
            Navigator.of(context).pop();
          });
    }).catchError((error){
      Navigator.of(context).pop();
      FirebaseException e = error;
      Fluttertoast.showToast(msg: e.message.toString());
    });
  }


  void _bottomsheetdate(BuildContext context){
    DateTime dateTime = DateTime.now();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) => Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.03 , horizontal: width * 0.1),
        child: Wrap(
          children: [
            Text('Select date ' , style: TextStyle(
              color: CColors.textblack,
              fontSize: 18,
              fontFamily: 'fh',
            ),),

            Container(
              height: 200,
              margin: EdgeInsets.symmetric(vertical: height * 0.01),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumDate: DateTime.fromMillisecondsSinceEpoch(0),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  dateTime = newDateTime;
                },
              ),
            ),

            Container(
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03,vertical: height * 0.015),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop();
                    addData(context , dateTime);
                  },
                  child: Text('Submit' , style: TextStyle(
                    color: Colors.white,
                  ),),
                ),
              ),
            )
          ],
        ),
      ),);
  }

}
