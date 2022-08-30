import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebasestorage;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:teish/Extras/CustomColors.dart';
import 'package:teish/Extras/functions.dart';
import 'package:teish/Models/JournalModel.dart';

class AddJournal extends StatefulWidget {

  DateTime date;

  AddJournal(this.date);

  @override
  _AddJournalState createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  late double width , height;

  var titlec = TextEditingController() , desc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: CColors.bg,
      body: Container(
        padding: MediaQuery.of(context).padding,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03 , vertical: height * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  GestureDetector(
                    onTap: ()=> Navigator.of(context).pop(),
                      child: ImageIcon(
                        AssetImage('assets/icons/back.png'
                        )
                        , color: Colors.black,
                      )
                  ),

                  Text(DateFormat('dd MMM,yyyy').format(widget.date),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'fh',

                    ),
                  ),


                  ImageIcon(
                    AssetImage('assets/icons/back.png'
                    )
                    , color: Colors.transparent,
                  ),
                ],
              ),
              GestureDetector(
                onTap: (){
                  _showPicker(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.03),
                  width: width * 0.8,
                  height: height * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      fit: BoxFit.cover,
                      image: _image == null ? AssetImage('assets/images/iplaceholder.jpg') : FileImage(_image!) as ImageProvider,
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(top: height * 0.01 , left: width * 0.01 , right: width * 0.01),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title'
                    ),
                    controller: titlec,
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.symmetric(vertical: height * 0.02 , horizontal: width * 0.01),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: TextField(
                      controller: desc,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Description',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    shape: StadiumBorder()
                  ),
                  onPressed: () {
                    if(titlec.text.trim().isEmpty){
                      Fluttertoast.showToast(msg: 'Please enter a title',textColor: Colors.white,backgroundColor: Colors.red);
                    }else{
                      Functions().showLoaderDialog(context);
                      if(_image != null){
                        uploadPic(_image!);
                      }else{
                        setData();
                      }
                    }
                  },
                  child: Text('Save',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              )
            ],
          ),
        ),
      ),
    );
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




  firebasestorage.FirebaseStorage _storage = firebasestorage.FirebaseStorage.instance;

  late String uid;
  Future<void> uploadPic(File file) async {

    String mills =  '${DateTime.now().millisecondsSinceEpoch}';
    var reference = await _storage.ref().child("images")
        .child(uid)
        .child(mills).putFile(file);

    if(reference.state == firebasestorage.TaskState.success){
      String url = await _storage.ref().child("images")
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(mills).getDownloadURL();

      setData(url: url);
    }else{
      Fluttertoast.showToast(msg: "Something went wrong",textColor: Colors.white,backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }

  }

  void setData({String url = ''}){
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DatabaseReference reference = FirebaseDatabase.instance.reference()
        .child("Users").child(uid).child("Journal");

    String key = reference.push().key!;
    JournalModel model = JournalModel(titlec.text.trim(), url, key, desc.text.trim(), widget.date.millisecondsSinceEpoch);
    reference.child(key).set(model.toMap()).then((value){
      Fluttertoast.showToast(msg: "Saved to Journal",textColor: Colors.white,backgroundColor: Colors.green);
      Navigator.of(context).pop();
      Future.delayed(Duration(milliseconds: 10)).then((value){
        Navigator.of(context).pop();
      });
    }).catchError((error){
      FirebaseException exception = error;
      Fluttertoast.showToast(msg: exception.message!,textColor: Colors.white,backgroundColor: Colors.red);
    });
  }
}
