import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:teish/Models/PeriodModel.dart';
import 'package:teish/Screens/Auth/BuildProfileScreen.dart';
import 'package:teish/Screens/Auth/Checkdata.dart';
import 'package:workmanager/workmanager.dart';
// import 'package:workmanager/workmanager.dart';

import 'Extras/CustomColors.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager().initialize(callbackdispatcher , isInDebugMode: true);
  await Workmanager().registerPeriodicTask("s", "dailynoti",
    existingWorkPolicy: ExistingWorkPolicy.replace,
    frequency: Duration(hours: 1),
    initialDelay: Duration(seconds: 5),
    constraints: Constraints(networkType: NetworkType.connected),
  );
  runApp(MyApp());
}
showNotification(String v ,FlutterLocalNotificationsPlugin flp) async {
  var android = AndroidNotificationDetails(
    "channelId",
    "channelName",
    "channelDescription",
    priority: Priority.high,
    importance: Importance.max,
  );
  var ios = IOSNotificationDetails();
  var platform = NotificationDetails(android: android , iOS: ios);
  await flp.show(1, "Crossover Day", v, platform);

}
void callbackdispatcher(){

  Workmanager().executeTask((taskName, inputData) async{
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android , iOS: ios);
    flp.initialize(initSettings);

    if(FirebaseAuth.instance.currentUser == null){
      return Future.value(true);
    }else{
      try{
        var ref = await FirebaseFirestore.instance
            .collection('Period')
            .doc(FirebaseAuth.instance.currentUser!.uid).get();

        var value = ref;
        if(value.exists){
          PeriodModel model = PeriodModel.fromMap(value.data() as Map<String, dynamic>);
          List<DateTime> cdays = [];

          DateTime dt = DateTime.fromMillisecondsSinceEpoch(model.date);

          cdays.add(dt.add(Duration(days: model.iwinter - 1)));
          cdays.add(dt.add(Duration(days: (model.iwinter + model.ispring) - 1)));
          cdays.add(dt.add(Duration(
              days: (model.iwinter + model.ispring + model.isummer) - 1)
          ));
          cdays.add(dt.add(Duration(
              days: (model.iwinter + model.ispring + model.isummer + model.ifall) - 1)
          ));

          cdays.forEach((element) {
            int diff = element.difference(DateFormat('dd-MM-yyyy').parse(DateFormat('dd-MM-yyyy').format(DateTime.now()))).inDays;
            if(diff <= 2 && diff > 0){
              showNotification('Your crossover day will start in $diff days', flp);
            }
          });
        }

        return Future.value(true);


      }catch(e){
        return Future.value(true);
      }
    }
  });

}
class MyApp extends StatelessWidget {

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Period Tracking',
      theme: ThemeData(
        primarySwatch: MaterialColor(CColors.blue.value, CColors.getSwatch(CColors.blue),),
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if(user == null){
      return BuildProfileScreen();
    }else{
      return CheckData();
    }
  }
}
