import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teish/Extras/CustomColors.dart';

import 'LastPeriodDate.dart';


class CycleLengthScreen extends StatefulWidget {
  int day;
  CycleLengthScreen(this.day);
  @override
  _CycleLengthScreenState createState() => _CycleLengthScreenState();
}

class _CycleLengthScreenState extends State<CycleLengthScreen> {

  int _currentValue = 28;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).padding,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.03,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back ,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: height * 0.03,),
                  Text('How long is your cycle' , style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'fh',
                    fontSize: 22,
                  ),),
                  SizedBox(height: height * 0.03,),
                  Text('Make your best guess, you can always update it any time',style: TextStyle(
                      color: CColors.textblack1,
                      fontSize: 15,
                      fontFamily: 'fb'
                  ),),

                  SizedBox(height: height * 0.05,),

                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                          child: NumberPicker(
                            itemCount: 3,
                            value: _currentValue,
                            minValue: 20,
                            maxValue: 40,
                            axis: Axis.horizontal,
                            itemHeight: width * 0.15,
                            itemWidth: width * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: CColors.blue),
                            ),

                            selectedTextStyle: TextStyle(
                                color: CColors.blue,
                                fontSize: 22
                            ),
                            onChanged: (value) => setState(() => _currentValue = value),
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

              Column(
                children: [
                  SizedBox(height: height * 0.03,),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape:  StadiumBorder(),
                      ),


                        child: Text('Next',style: TextStyle(
                            color: Colors.white
                          ),
                        ),

                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                            return LastPeriodScreen();
                          }));

                        }),
                  ),
                  SizedBox(height: height * 0.1,),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
