import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/JournalModel.dart';
import 'package:teish/Screens/Journal/AddJournal.dart';
import 'package:teish/Screens/Journal/JournalDetail.dart';

class JournalScreen extends StatelessWidget {

  late double width , height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _bottomsheetdate(context),
        backgroundColor: CColors.yellow,
        child: Icon(Icons.add),
      ),
      body: Container(
        // padding: ,
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('Journal')
                      .orderBy("date" , descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasError){
                      FirebaseException e = snapshot.error as FirebaseException;
                      return Center(
                        child: Text(e.message.toString(),
                          style: TextStyle(
                            fontFamily: 'fm',
                            fontSize: 15,
                          ),
                        ),
                      );
                    }else if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else if(!snapshot.hasData || snapshot.data!.size ==0){
                      return Center(
                        child: Text('No data found',
                          style: TextStyle(
                            fontFamily: 'fm',
                            fontSize: 15,
                          ),
                        ),
                      );
                    }

                    List<JournalModel> jlist = [];
                    snapshot.data!.docs.forEach((element) {
                      JournalModel model = JournalModel.fromMap(element.data() as Map<String , dynamic>);
                      jlist.add(model);
                    });
                    return ListView.builder(itemBuilder: (ctx, i){
                      return JournalWidget(jlist[i]);
                    },
                      itemCount: jlist.length,
                    );
                  }
                )
            ),
          ],
        ),
      ),
    );
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
                  onPressed: (){
                    Navigator.of(context).pop();

                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                      return AddJournal(dateTime);
                    }));

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
class JournalWidget extends StatelessWidget {

  JournalModel model;

  JournalWidget(this.model);

  late double width , height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: ()=> _bottomsheetjournal(context, model),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: height * 0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04 , vertical: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.title,style: TextStyle(
                color: Colors.black,
                fontFamily: 'fb',
                fontSize: 15,
              ),),
              SizedBox(height: height * 0.01,),
              Text(DateFormat('dd MMM,yyyy').format(DateTime.fromMillisecondsSinceEpoch(model.date)),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'fh',
                  fontSize: 18,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



  void _bottomsheetjournal(BuildContext context , JournalModel model){

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) => JournalDetail(model),);
  }
}
