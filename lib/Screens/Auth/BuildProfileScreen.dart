import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Models/UserModel.dart';

import 'Checkdata.dart';
import 'LoginScreen.dart';
class BuildProfileScreen extends StatefulWidget {


  @override
  _BuildProfileScreenState createState() => _BuildProfileScreenState();
}

class _BuildProfileScreenState extends State<BuildProfileScreen> {
  firebasestorage.FirebaseStorage _storage = firebasestorage.FirebaseStorage.instance;

  var namecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  late String url;
  late String uid;

  var isloading = false;
  Future<void> uploadPic(File file) async {
    uid = FirebaseAuth.instance.currentUser!.uid;
    String mills =  '${DateTime.now().millisecondsSinceEpoch}';
    var reference = await _storage.ref().child("images")
        .child(uid)
        .child(mills).putFile(file);

    if(reference.state == firebasestorage.TaskState.success){
      url = await _storage.ref().child("images")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(mills).getDownloadURL();

      addUser();
    }else{
      setState(() {
        isloading = false;
      });
    }

  }
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future addUser() async{
    UserModel model = UserModel(
        uid ,  passwordcontroller.text.trim() ,
        FirebaseAuth.instance.currentUser == null ?
        emailcontroller.text.trim() : FirebaseAuth.instance.currentUser!.email!
        , namecontroller.text.trim() ,
        formattedDate ,  url);
    await firestore.collection('Users').doc(uid).set(model.toMap())
        .then((value) => {
          Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (BuildContext context) => CheckData()),
          ModalRoute.withName('/')),
          print('userAdded')
        })
        .catchError((error) => {
          setState(() {
            isloading = false;
          }),
          print(error),
        });
  }
  File? _image;
  Future getImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      cropOpt: CropOption(
        // aspectRatio: CropAspectRatio.wh16x9
      ),
    );
    if (res != null) {
      print(res.map((e) => e.path).toList());

      setState(() {
        _image = File(res[0].path);
      });
      // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
      // print(status);
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

      setState(() {
        _image = File(res[0].path);
      });
      // bool status = await ImagesPicker.saveImageToAlbum(File(res[0]?.path));
      // print(status);
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


  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  _selectDate(BuildContext context) async {
    print(DateTime.now().year);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      });
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: height * 0.03,),

                Text(
                  FirebaseAuth.instance.currentUser != null
                      ? 'Add your Information' :
                  'Build your profile'
                  , style: TextStyle(
                  color: CColors.textblack,
                  fontFamily: "fh",
                  fontSize: 22,
                ),),
                SizedBox(height: height * 0.02,),
                Text('Please enter your personal information will help to track your cycle easily.',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontFamily: "fb",
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: height * 0.025,),

                Container(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      // getImage();
                      _showPicker(context);
                    },

                    child: CircleAvatar(
                        radius: width * 0.125,
                        backgroundColor: Colors.transparent,
                        child:  _image == null ?
                            ClipOval(child: Image(image: AssetImage('assets/images/cameraplaceholder.png'),fit: BoxFit.cover, width: width * 0.25, height: width * 0.25,))
                          :ClipOval(child: Image(image: FileImage(_image!) , fit: BoxFit.cover, width: width * 0.25, height: width * 0.25,)),
                    ),
                  ),
                ),


                SizedBox(height: height * 0.025,),
                Text('Full Name*',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontFamily: "fm",
                    fontSize: 14,
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

                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(border: InputBorder.none,
                    ),
                  ),
                ),

                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
                SizedBox(height: height * 0.02,),
                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
                Text('Email*',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontFamily: "fm",
                    fontSize: 14,
                  ),),
                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
                SizedBox(height: height * 0.015,),
                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
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
                    controller: emailcontroller,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus(),
                    decoration: InputDecoration(border: InputBorder.none,
                    ),
                  ),
                ),


                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
                SizedBox(height: height * 0.02,),
                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
                Text('Password*',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontFamily: "fm",
                    fontSize: 14,
                  ),),
                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
                SizedBox(height: height * 0.015,),
                FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
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
                    controller: passwordcontroller
                    ,
                    maxLines: 1,
                    decoration: InputDecoration(border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.visiblePassword,

                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => node.unfocus(),
                    obscureText: true,
                  ),
                ),


                SizedBox(height: height * 0.02,),

                Text('Date of Birth*',
                  style: TextStyle(
                    color: Color(0x80000000),
                    fontFamily: "fm",
                    fontSize: 14,
                  ),),
                SizedBox(height: height * 0.015,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: CColors.lightgray),
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: 12),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formattedDate,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "fm",
                            fontSize: 15
                        ),
                        maxLines: 1,
                      ),

                      GestureDetector(
                        onTap: (){
                          node.unfocus();
                          _selectDate(context);
                        },
                        child: Icon(Icons.calendar_today,
                        color: CColors.blue,),
                      )
                    ],
                  ),
                ),

                SizedBox(height: height * 0.05,),
                isloading ?
                    Center(child: CircularProgressIndicator())
                :
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape:  StadiumBorder(),
                        ), child: Text(
                            FirebaseAuth.instance.currentUser != null
                                ? 'Update' :
                            'Register'
                            ,style: TextStyle(
                              color: Colors.white,
                            fontFamily: "fh",
                            fontSize: 15
                          ),
                          ),

                          onPressed: () async {

                            if(!validate()){
                              return;
                            }
                            setState(() {
                              isloading = true;
                            });
                            if(FirebaseAuth.instance.currentUser != null){
                              uploadPic(_image!);
                              return;
                            }
                            FirebaseAuth auth = FirebaseAuth.instance;
                            auth.createUserWithEmailAndPassword(
                                email: emailcontroller.text.trim(),
                                password: passwordcontroller.text.trim()
                            ).then((value){
                              uploadPic(_image!);
                            }).catchError((error){
                              setState(() {
                                isloading = false;
                              });

                              FirebaseAuthException e = error;
                              Fluttertoast.showToast(msg: e.message.toString());
                            });
                          }),
                    ),

                    SizedBox(height: height * 0.0,),
                    FirebaseAuth.instance.currentUser != null
                    ? SizedBox() :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?',
                          style: TextStyle(
                            color: CColors.textblack
                          ),
                        ),

                        TextButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> LoginScreen()));
                        }, child: Text('Signin here',
                            style: TextStyle(
                              fontFamily: "fm",
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ) ,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate(){
    if(_image == null){
      Fluttertoast.showToast(msg: 'Please select an Image');
      return false;
    }else
    if(namecontroller.text.trim().isEmpty){
      Fluttertoast.showToast(msg: 'Invalid name');
      return false;
    }else
    if(!EmailValidator.validate(emailcontroller.text.trim())
        && FirebaseAuth.instance.currentUser == null){
      Fluttertoast.showToast(msg: 'Invalid Email');
      return false;
    }else if(passwordcontroller.text.trim().length < 6
        && FirebaseAuth.instance.currentUser == null){
      Fluttertoast.showToast(msg: 'Password should contain 6 characters');
      return false;
    }else{
      return true;
    }

  }
}