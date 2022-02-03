import 'package:flutter/material.dart';
import 'package:teish/Extras/CustomColors.dart';

class Advice extends StatelessWidget {
  late double width, height;

  int index;
  Advice(this.index);

  List<String> sc = [
    'Take a break, rest, let go of the doing.',
    'Don’t move too fast in this season. Don’t take on too many responsibilities. Remain open and curious without over working yourself.',
    'Get social if you feel like it. Spoil yourself, get spontaneous.',
    'Acknowledge and respect the wisdom from this season.  Remember that the inner critic is not running your life. Embody the authority shining through. Don’t forget to slow down.',
  ];

  List<String> wp = [
    'Don’t schedule meetings or networking events during this time. Take time for you instead and step away from the screens. ',
    'Explore new concepts, plan, build systems, brain dump, contemplate. This is a great time to bookmark skills that you want to learn. ',
    'Book speaking engagements and sales meetings. Socialize and network. ',
    'Make and implement lists, evaluate the state of your business. Say no. Dive into finances. Do the work, Tie up loose ends!',
  ];
  @override
  Widget build(BuildContext context) {
    print(index);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text('Coaching Advice',style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'fh',
                  ),),
                  ImageIcon(AssetImage('assets/icons/backios.png'),color: Colors.transparent,),
                ],
              ),


              SizedBox(height: height * 0.02,),
              Text('Best Self Care Practice:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'fh'
                ),
              ),

              SizedBox(height: height * 0.01,),

              Text(sc[index],style: TextStyle(
                color: CColors.textblack,
                fontFamily: 'fm',
                fontSize: 15
              ),),

              SizedBox(height: height * 0.02,),
              Text('Best Work Practice:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'fh'
                ),
              ),

              SizedBox(height: height * 0.01,),

              Text(wp[index],style: TextStyle(
                  color: CColors.textblack,
                  fontFamily: 'fm',
                  fontSize: 15
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
