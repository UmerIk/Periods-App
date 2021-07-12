import 'package:flutter/material.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Screens/Dashboard/Calendar.dart';
import 'package:teish/Screens/Dashboard/Home.dart';
import 'package:teish/Screens/Dashboard/Journal.dart';
import 'package:teish/Screens/Dashboard/Symptoms.dart';

import '../../main.dart';
import 'ProfileScreen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedpageindex = 0;
  void _selectpage(int index){
    setState(() {
      _selectedpageindex = index;
    });
  }
  List<Widget> _pages = [
    HomeScreen() ,
    Calendar(),
    SymptomsScreen(),
    JournalScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: CColors.bg,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectpage,
        backgroundColor: Colors.white,
        unselectedItemColor: CColors.darkestgray,
        selectedItemColor: CColors.blue,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedpageindex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                  AssetImage('assets/icons/home.png')
              ),
              label: 'Home'
          ),

          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(

                  AssetImage('assets/icons/calendar.png')
              ),
              label: 'Calendar'
          ),

          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                  AssetImage('assets/icons/sanitary-towel.png')
              ),
              label: 'Symptoms'
          ),
          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                  AssetImage('assets/icons/journal.png')
              ),
              label: 'Journal'
          ),

          BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                  AssetImage('assets/icons/user.png')
              ),
              label: 'Profile'
          ),
        ],
      ),
      body: Container(
        padding: MediaQuery.of(context).padding,
          child: _pages[_selectedpageindex]
      ),
    );
  }
}
