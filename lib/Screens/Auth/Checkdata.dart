import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference()
        .child("Users").child(user.uid);

    databaseReference.get().then((value){
      if(value == null){
        print("error");
        return;
      }
      if(value.value != null){
        print(value.value);
        getUserPData(context);
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
          return BuildProfileScreen();
        }));
      }
      // if((value.value)
    }).catchError((error){
      print(error);
    });
    // await FirebaseFirestore.instance
    //     .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
    //
    //
    //   print(1111);
    //
    //   if(value.exists){
    //     getUserPData(context);
    //   }else{
    //
    //   }
    // },onError: (error){
    //       print(1111);
    //       print(error.toString());
    // });
  }

  Future getUserPData(BuildContext context) async {
    print(222);


    DatabaseReference databaseReference = FirebaseDatabase.instance.reference()
        .child("Period").child(user.uid);

    databaseReference.get().then((value){
      if(value == null){
        return;
      }
      if(value.value != null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => Dashboard()));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:
            (ctx) => LastPeriodScreen()));
      }
    }).catchError((eror){
      print(eror.toString());
    });

    return;
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