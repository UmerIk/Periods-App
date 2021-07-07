import 'package:flutter/material.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/JournalModel.dart';

class JournalDetail extends StatelessWidget {
  JournalModel model;
  JournalDetail(this.model);

  late double width , height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: height * 0.015),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02,),

            model.image == "" ? SizedBox() :
            Align(
              alignment: Alignment.center,
              child: Container(
                width: width * 0.8,
                  height: height * 0.3,
                  child: GestureDetector(
                    onTap: (){
                      _showSecondPage(context, model.image);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image(
                        image: NetworkImage(model.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ),
            ),

            model.image == "" ? SizedBox() :
            SizedBox(height: height * 0.03,),

            model.title.isEmpty ? SizedBox():
                Text(model.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'fh',
                    fontSize: 18,
                  ),
                ),

            model.title.isEmpty ? SizedBox():

            SizedBox(height: height * 0.01,),

            model.description.isEmpty ? SizedBox():
            Text(model.description,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'fb',
                fontSize: 18,
              ),
            ),

            model.description.isEmpty ? SizedBox():
            SizedBox(height: height * 0.03,),
          ],
        ),
      ),
    );
  }



  void _showSecondPage(BuildContext context , String link) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: CColors.bg,
          body: Center(
            child: Image.network(link),
          ),
        ),
      ),
    );
  }
}
