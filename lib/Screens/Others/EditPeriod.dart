import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Extras/functions.dart';
import 'package:teish/Models/PeriodModel.dart';

class EditPeriod extends StatefulWidget {

  PeriodModel model;

  EditPeriod(this.model);

  @override
  _EditPeriodState createState() => _EditPeriodState();
}

class _EditPeriodState extends State<EditPeriod> {
  late double width, height;

  late PeriodModel model;
  @override
  void initState() {
    // TODO: implement initState
    model = widget.model;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: CColors.bg,
      body: Container(
        padding: MediaQuery.of(context).padding,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [

                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.02),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(
                          onTap: ()=> Navigator.of(context).pop(),
                          child: ImageIcon(
                            AssetImage('assets/icons/back.png'
                            )
                            , color: Colors.black,
                          )
                      ),

                      Text('Update Crossover Days',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'fh',

                        ),
                      ),


                      ImageIcon(
                        AssetImage('assets/icons/back.png'
                        )
                        , color: Colors.transparent,
                      ),
                    ],
                  ),
                ),

                Card(
                  margin: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
                    child: Column(
                      children: [
                        Text('Inner Winter',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'fh'
                          ),
                        ),

                        SizedBox(height: height * 0.015,),

                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                                child: NumberPicker(
                                  itemCount: 3,
                                  value: model.iwinter,
                                  minValue: 2,
                                  maxValue: 9,
                                  axis: Axis.horizontal,
                                  itemHeight: width * 0.15,
                                  itemWidth: width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),

                                    border: Border.all(color: CColors.blue),
                                  ),

                                  selectedTextStyle: TextStyle(
                                      color: CColors.blue
                                  ),
                                  onChanged: (value) => setState((){
                                    model.iwinter = value;
                                  }),
                                ),
                              ),
                              SizedBox(height: height * 0.01,),
                              Text('Days',style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'fb',
                                  fontSize: 15
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  margin: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.02),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
                    child: Column(
                      children: [
                        Text('Inner Spring',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'fh'
                          ),
                        ),

                        SizedBox(height: height * 0.015,),

                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                                child: NumberPicker(
                                  itemCount: 3,
                                  value: model.ispring,
                                  minValue: 2,
                                  maxValue: 9,
                                  axis: Axis.horizontal,
                                  itemHeight: width * 0.15,
                                  itemWidth: width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),

                                    border: Border.all(color: CColors.blue),
                                  ),

                                  selectedTextStyle: TextStyle(
                                      color: CColors.blue
                                  ),
                                  onChanged: (value) => setState((){
                                    model.ispring = value;
                                  }),
                                ),
                              ),
                              SizedBox(height: height * 0.01,),
                              Text('Days',style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'fb',
                                  fontSize: 15
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  margin: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.02),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
                    child: Column(
                      children: [
                        Text('Inner Summer',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'fh'
                          ),
                        ),

                        SizedBox(height: height * 0.015,),

                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                                child: NumberPicker(
                                  itemCount: 3,
                                  value: model.isummer,
                                  minValue: 2,
                                  maxValue: 9,
                                  axis: Axis.horizontal,
                                  itemHeight: width * 0.15,
                                  itemWidth: width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),

                                    border: Border.all(color: CColors.blue),
                                  ),

                                  selectedTextStyle: TextStyle(
                                      color: CColors.blue
                                  ),
                                  onChanged: (value) => setState((){
                                    model.isummer = value;
                                  }),
                                ),
                              ),
                              SizedBox(height: height * 0.01,),
                              Text('Days',style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'fb',
                                  fontSize: 15
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  margin: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.02),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
                    child: Column(
                      children: [
                        Text('Inner Fall',
                          style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'fh'
                          ),
                        ),

                        SizedBox(height: height * 0.015,),

                        Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                                child: NumberPicker(
                                  itemCount: 3,
                                  value: model.ifall,
                                  minValue: 2,
                                  maxValue: 9,
                                  axis: Axis.horizontal,
                                  itemHeight: width * 0.15,
                                  itemWidth: width * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),

                                    border: Border.all(color: CColors.blue),
                                  ),

                                  selectedTextStyle: TextStyle(
                                      color: CColors.blue
                                  ),
                                  onChanged: (value) => setState((){
                                    model.ifall = value;
                                  }),
                                ),
                              ),
                              SizedBox(height: height * 0.01,),
                              Text('Days',style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'fb',
                                  fontSize: 15
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.02),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: height * 0.015),
                      shape: StadiumBorder(),
                    ),
                      onPressed: (){
                        //update
                        update();
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                  ),
                )
              ],
            ),

          ),
        ),
      ),
    );
  }
  update(){
    print(model.toMap());
    Functions().showLoaderDialog(context, text: "Updating data");
    FirebaseFirestore.instance.collection('Period')
        .doc(FirebaseAuth.instance.currentUser!.uid).update(model.toMap()).then((value){
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 10)).then((value){
            Navigator.of(context).pop();
          });
    }).catchError((error){
      FirebaseException e = error;
      print(e.message.toString());
    });
  }
}
