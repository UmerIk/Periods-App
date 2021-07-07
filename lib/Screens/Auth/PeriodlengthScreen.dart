import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:teish/Extras/CustomColors.dart';

import 'CycleLengthScreen.dart';

class PeriodLengthScreen extends StatefulWidget {
  @override
  _PeriodLengthScreenState createState() => _PeriodLengthScreenState();
}

class _PeriodLengthScreenState extends State<PeriodLengthScreen> {
  int _currentValue = 5;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: MediaQuery.of(context).padding,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.03,),
              GestureDetector(
                onTap: ()=> Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back ,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              SizedBox(height: height * 0.03,),
              Text('How long does your period take?' , style: TextStyle(
                color: Colors.black,
                fontFamily: 'fh',
                fontSize: 22,
              ),),
              SizedBox(height: height * 0.03,),
              Text('Make your best guess, you can always update it any time',
                style: TextStyle(
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

              Container(
                margin: EdgeInsets.only(bottom: height * 0.1 , top: height * 0.03),
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
                        return CycleLengthScreen(_currentValue);
                      }));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
