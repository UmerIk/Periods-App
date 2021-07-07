import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teish/Extras/CustomColors.dart';

import 'Checkdata.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailcontroller = TextEditingController() ;
  var passwordcontroller = TextEditingController();

  bool isloading = false;
  @override
  Widget build(BuildContext context) {

    final node = FocusScope.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: height * 0.03,),
              GestureDetector(
                onTap: ()=> Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back ,
                  color: Colors.black,
                  size: 30,
                ),
              ),
              SizedBox(height: height * 0.03,),
              Text('Login to your existing account' , style: TextStyle(
                color: CColors.textblack,
                fontFamily: "fh",
                fontSize: 22,
              ),),
              SizedBox(height: height * 0.03,),
              Text('Please enter your credentials to login to your existing account.',
                style: TextStyle(
                  color: Color(0x80000000),
                  fontFamily: "fb",
                  fontSize: 15,
              ),
              ),
              SizedBox(height: height * 0.025,),
              Text('Email*', style: TextStyle(
                color: Color(0x80000000),
                fontFamily: "fm",
                fontSize: 14,
              ),
              ),
              SizedBox(height: height * 0.01,),
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
                  decoration: InputDecoration(border: InputBorder.none,
                  ),

                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                ),
              ),


              SizedBox(height: height * 0.01,),
              Text('Password*',
                  style: TextStyle(
                  color: Color(0x80000000),
                  fontFamily: "fm",
                    fontSize: 14,
                ),
                ),

              SizedBox(height: height * 0.01,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: CColors.lightgray),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: TextField(
                  controller: passwordcontroller
                  ,
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(border: InputBorder.none,
                  ),
                  obscureText: true,

                  textInputAction: TextInputAction.done,
                  onEditingComplete: () => node.unfocus(),
                ),
              ),


              SizedBox(height: height * 0.01,),

              isloading ?
              Center(child: CircularProgressIndicator())
                  :
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                        color: CColors.pink,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text('Login',style: TextStyle(
                            color: Colors.white,
                            fontFamily: "fh",
                            fontSize: 15
                        ),
                        ),
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: CColors.pink),
                        ),
                        onPressed: () async {

                          if(!validate()){
                            return;
                          }
                          setState(() {
                            isloading = true;
                          });

                          FirebaseAuth auth = FirebaseAuth.instance;
                          auth.signInWithEmailAndPassword(
                              email: emailcontroller.text.trim(),
                              password: passwordcontroller.text.trim()
                          ).then((value){
                            Navigator.pushAndRemoveUntil(
                                context, MaterialPageRoute(builder: (BuildContext context) =>
                                CheckData()),
                                ModalRoute.withName('/'));
                          }).catchError((error){
                            FirebaseAuthException e = error;
                            Fluttertoast.showToast(msg: e.message.toString());
                            setState(() {
                              isloading = false;
                            });
                          });

                        }),
                  ),

                  SizedBox(height: height * 0.01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                        style: TextStyle(
                            color: CColors.textblack
                        ),
                      ),

                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text('Create here',
                        style: TextStyle(
                          color: CColors.pink,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool validate(){
    if(!EmailValidator.validate(emailcontroller.text.trim())){
      Fluttertoast.showToast(msg: 'Invalid Email');
      return false;
    }else if(passwordcontroller.text.trim().length < 6){
      Fluttertoast.showToast(msg: 'Password should contain 6 characters');
      return false;
    }else{
      return true;
    }

  }
}
