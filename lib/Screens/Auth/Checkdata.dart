import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teish/Screens/Auth/LastPeriodDate.dart';
import 'package:teish/Screens/Auth/PeriodlengthScreen.dart';
import 'package:teish/Screens/Dashboard/DashboardScreen.dart';

import 'BuildProfileScreen.dart';


class CheckData extends StatelessWidget {


  late User user;
  Future getUserDataP(BuildContext context) async {
    user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {


      print(1111);

      if(value.exists){
        getUserPData(context);
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
          return BuildProfileScreen();
        }));
      }
    },onError: (error){
          print(1111);
          print(error.toString());
    });
  }

  Future getUserPData(BuildContext context) async {
    print(222);
    await FirebaseFirestore.instance
        .collection('Period').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => {
      if(value.exists){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Dashboard()))
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:
        (ctx) => LastPeriodScreen()))
      }
    },onError: (error){
      print(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    getUserDataP(context);
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}