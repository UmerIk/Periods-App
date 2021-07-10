import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:teish/Screens/Auth/BuildProfileScreen.dart';
import 'package:teish/Screens/Auth/Checkdata.dart';
// import 'package:workmanager/workmanager.dart';

import 'Extras/CustomColors.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Workmanager().initialize(callbackdispatcher , isInDebugMode: false);
  // await Workmanager().registerPeriodicTask("s", "dailynoti",
  //   existingWorkPolicy: ExistingWorkPolicy.replace,
  //   frequency: Duration(minutes: 15),
  //   initialDelay: Duration(seconds: 5),
  //   constraints: Constraints(networkType: NetworkType.not_required),
  // );
  runApp(MyApp());
}
// showNotification(String v ,FlutterLocalNotificationsPlugin flp) async {
//   print(1);
//   var android = AndroidNotificationDetails(
//     "channelId",
//     "channelName",
//     "channelDescription",
//     priority: Priority.high,
//     importance: Importance.max,
//   );
//   var ios = IOSNotificationDetails();
//   var platform = NotificationDetails(android: android , iOS: ios);
//
//   print(1);
//   await flp.show(1, "title", "body", platform);
//   print(1);
//
// }
// void callbackdispatcher(){
//   print(11);
//
//   Workmanager().executeTask((taskName, inputData) async{
//     print(taskName);
//     print(11);
//
//     FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
//     var android = AndroidInitializationSettings("@mipmap/ic_launcher");
//     var ios = IOSInitializationSettings();
//     var initSettings = InitializationSettings(android: android , iOS: ios);
//     flp.initialize(initSettings);
//
//     showNotification("Hello", flp);
//
//     return Future.value(true);
//   });
//
// }
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
