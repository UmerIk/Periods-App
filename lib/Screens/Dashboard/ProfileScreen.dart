

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';
import 'package:teish/Alert/BaseAlert.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/UserModel.dart';
import 'package:teish/Screens/Auth/BuildProfileScreen.dart';
import 'package:teish/Screens/Dashboard/Calendar.dart';

class ProfileScreen extends StatefulWidget {


  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {

  firebasestorage.FirebaseStorage _storage = firebasestorage.FirebaseStorage.instance;
  Future<void> uploadPic(File file) async {
    Fluttertoast.showToast(msg: 'Updating image please wait');
    cuid = FirebaseAuth.instance.currentUser!.uid;
    String mills =  '${DateTime.now().millisecondsSinceEpoch}';
    var reference = await _storage.ref().child("images")
        .child(cuid)
        .child(mills).putFile(file);

    if(reference.state == firebasestorage.TaskState.success){
      String url = await _storage.ref().child("images")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(mills).getDownloadURL();

      addUser(url);
    }else{
      setState(() {
        isloading = false;
      });
    }

  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future addUser(String url , {String field = "image"}) async{

    Map<String , String> data = Map();
    data[field] = url;
    await firestore.collection('Users').doc(cuid).update(data)
        .then((value) => {

      print('userAdded')
    })
        .catchError((error) => {
      setState(() {
        isloading = false;
      }),
      print(error),
    });
  }

  bool isloading = false;


  getImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      cropOpt: CropOption(
        // aspectRatio: CropAspectRatio.wh16x9
      ),
    );
    if (res != null) {
      print(res.map((e) => e.path).toList());

      uploadPic(File(res[0].path));

    }
  }
  _imgFromCamera() async {
    List<Media>? res = await ImagesPicker.openCamera(

      cropOpt: CropOption(
        // aspectRatio: CropAspectRatio.wh16x9
      ),
    );
    if (res != null) {
      print(res.map((e) => e.path).toList());
      uploadPic(File(res[0].path));
    }
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        getImage();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  var namecontroller = TextEditingController();
  void _changename(context) {
    namecontroller.text = model.name;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
        ),
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 30.0),
            height: height * 0.3,
            child: new Column(
              children: <Widget>[
                Text('Edit Your Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "fh",
                    fontSize: 22,
                  ),
                ),
                SizedBox(height:  height * 0.03,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Full Name*',
                    style: TextStyle(
                      color: Color(0x80000000),
                      fontFamily: "fm",
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.015,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: CColors.lightgray),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: TextField(
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "fm",
                        fontSize: 15
                    ),
                    controller: namecontroller,
                    maxLines: 1,
                    keyboardType: TextInputType.name,

                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(border: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height:  height * 0.03,),

                ElevatedButton(
                  onPressed: (){
                    if(namecontroller.text.isNotEmpty) {
                      Navigator.of(context).pop();
                      addUser(namecontroller.text, field: "name");
                    }
                  },
                  child: Text('Update' , style: TextStyle(
                    color: Colors.white
                  ),),
                )
              ],
            ),
          );
        }
    );
  }


  late double width , height;
  late UserModel model;
  String cuid = FirebaseAuth.instance.currentUser!.uid;
  late DocumentReference reference;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    reference = FirebaseFirestore.instance.collection('Users').doc(cuid);
    return Scaffold(
      body: Container(
        height: height,
        color: CColors.bg,
        child: StreamBuilder<DocumentSnapshot>(
          stream: reference.snapshots(),
          builder: (context, snapshot) {

            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if(!snapshot.hasData || !snapshot.data!.exists){
              return SizedBox(height: 0,);
            }

            model = UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);

            return Container(
              child: Column(
                children: [
                  SizedBox(height: height * 0.03,),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.01),

                      child: Row(
                        children: [
                          topStack(),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(model.name ,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'fh',
                                            ),
                                          ),
                                        ),

                                        GestureDetector(
                                          onTap: ()=> _changename(context),
                                            child: Icon(Icons.edit_sharp, color: CColors.blue,)
                                        )
                                      ],
                                    ),

                                    SizedBox(height: 5,),
                                    Text(model.email ,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'fb',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> Calendar()));
                          },
                          leading: Icon(Icons.notifications_none,color: CColors.textblack),
                          title: Text('Calendar' , style: TextStyle(
                            color: CColors.textblack,
                            fontSize: 15,
                            fontFamily: 'FuturaHeavy',
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,color: CColors.textblack),
                        ),
                        ListTile(
                          onTap: (){
                            // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ContractionScreen()));
                          },
                          leading: Icon(Icons.notifications_none,color: CColors.textblack),
                          title: Text('Push Notifications' , style: TextStyle(
                            color: CColors.textblack,
                            fontSize: 15,
                            fontFamily: 'FuturaHeavy',
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,color: CColors.textblack),
                        ),
                        ListTile(
                          onTap: (){
                            if(Platform.isAndroid){
                              // Share.share('https://play.google.com/store/apps/details?id=com.jewelspad.shereign');
                            }
                            // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ContractionScreen()));
                          },
                          leading: Icon(Icons.share,color: CColors.textblack,),
                          title: Text('Share Application' , style: TextStyle(
                            color: CColors.textblack,

                            fontSize: 15,
                            fontFamily: 'FuturaHeavy',
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,color: CColors.textblack),
                        ),
                        ListTile(
                          onTap: (){
                            if(Platform.isAndroid){
                              // Share.share('https://play.google.com/store/apps/details?id=com.jewelspad.shereign');
                            }
                            // Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ContractionScreen()));
                          },
                          leading: Icon(Icons.star_border,color: CColors.textblack),
                          title: Text('Rate Application?' , style: TextStyle(
                            color: CColors.textblack,

                            fontSize: 15,
                            fontFamily: 'FuturaHeavy',
                          ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,color: CColors.textblack),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () async {

                            var baseDialog = BaseAlertDialog(
                                title: "Logout",
                                content: "Do you really want to logout?",
                                yesOnPressed: () async {

                                  await FirebaseAuth.instance.signOut();

                                  Navigator.pushAndRemoveUntil(
                                      context, MaterialPageRoute(builder: (BuildContext context) =>
                                      BuildProfileScreen()),
                                      ModalRoute.withName('/'));

                                },
                                noOnPressed: () {
                                  Navigator.of(context).pop();
                                },
                                yes: "Yes",
                                no: "No");
                            showDialog(context: context, builder: (BuildContext context) => baseDialog);

                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.logout , color: CColors.blue,),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: height * 0.02),
                                child: Text('Logout' , style: TextStyle(
                                  color: CColors.blue,

                                  fontSize: 15,
                                  fontFamily: 'FuturaHeavy',
                                ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget topStack(){
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle
        ),
        width: width * 0.3,
        child: GestureDetector(
          onTap: (){
            _showPicker(context);
          },
          child: Image.network(model.image,
            fit: BoxFit.cover,),
        ),
      ),
    );
  }
}
