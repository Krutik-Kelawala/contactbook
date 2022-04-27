import 'dart:io';

import 'package:contactbook/databasehelp.dart';
import 'package:contactbook/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqlite_api.dart';

class createcontact extends StatefulWidget {
  @override
  _createcontactState createState() => _createcontactState();
}

class _createcontactState extends State<createcontact> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // TextEditingController emailid = TextEditingController();
  bool namestatus = false;
  bool phonenumberstatus = false;

  bool loadstatus = false;

  Database? db;
  String addimage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getdb();
    setState(() {
      loadstatus = true;
    });
  }

  getdb() {
    Databasehelper().Getdatabase().then((value) {
      setState(() {
        db = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double thehight = MediaQuery.of(context).size.height;
    double thewidth = MediaQuery.of(context).size.width;
    double statusbarheight = MediaQuery.of(context).padding.top;
    double navigatorheight = MediaQuery.of(context).padding.bottom;
    double appbarheight = kToolbarHeight;
    double bodyheight =
        thehight - statusbarheight - appbarheight - navigatorheight;

    return loadstatus
        ? WillPopScope(
            onWillPop: onback,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.deepOrangeAccent,
                title: Text("New Contact"),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                    child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          addimage = image!.path;
                        });
                      },
                      child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color(0xFFF1BEB0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          height: bodyheight * 0.3,
                          child: addimage != ""
                              ? Image(
                                  fit: BoxFit.cover,
                                  image: FileImage(File('image')))
                              : Container(
                                  child: Icon(
                                    Icons.account_circle,
                                    size: bodyheight * 0.25,
                                  ),
                                )),
                    ),
                    Container(
                      margin: EdgeInsets.all(bodyheight * 0.01),
                      // height: bodyheight * 0.1,
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            labelText: "Name",
                            // errorText:
                            //     namestatus ? "Please fill this field" : null,
                            hintText: "Enter Your Name"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(bodyheight * 0.01),
                      // height: bodyheight * 0.1,
                      child: TextField(
                        controller: phoneno,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.call),
                          labelText: "Phone Number",
                          // focusedBorder: OutlineInputBorder(),
                          // enabledBorder: OutlineInputBorder(
                          //     borderSide: BorderSide(color: Colors.red)),
                          errorText: phonenumberstatus
                              ? "Please fill this field"
                              : null,
                          hintText: "Enter Phone Number",
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.all(bodyheight * 0.01),
                    //   // height: bodyheight * 0.1,
                    //   child: TextField(
                    //     controller: emailid,
                    //     decoration: InputDecoration(
                    //         border: OutlineInputBorder(),
                    //         prefixIcon: Icon(Icons.email),
                    //         labelText: "Email",
                    //         hintText: "Enter Email id"),
                    //   ),
                    // ),
                    Container(
                      // height: bodyheight * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.deepOrangeAccent),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)))),
                                onPressed: () {
                                  // print("value = $name");
                                  // print("value1 = $phoneno");

                                  String pname = name.text;
                                  String pphno = phoneno.text;
                                  Databasehelper()
                                      .insertdata(pname, pphno, db!, addimage)
                                      .then((value) {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return firstpage();
                                      },
                                    ));
                                  });

                                  setState(() {
                                    if (pphno.isEmpty) {
                                      phonenumberstatus = true;
                                    } else {
                                      phonenumberstatus = false;
                                    }
                                  });
                                },
                                child: Text("Save")),
                          ),
                          // Container(
                          //   child: ElevatedButton(
                          //       style: ButtonStyle(
                          //           backgroundColor: MaterialStateProperty.all(
                          //               Colors.deepOrangeAccent),
                          //           shape: MaterialStateProperty.all(
                          //               RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.circular(20)))),
                          //       onPressed: () {
                          //         Navigator.pop(context, MaterialPageRoute(
                          //           builder: (context) {
                          //             return firstpage();
                          //           },
                          //         ));
                          //       },
                          //       child: Text("Cancel")),
                          // )
                        ],
                      ),
                    )
                  ],
                )),
              ),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  Future<bool> onback() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Discard changes"),
          content: Text("All changes will be discarded."),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return firstpage();
                    },
                  ));
                },
                child: Text("Yes")),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"))
          ],
        );
      },
    );
    // showAnimatedDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (BuildContext context) {
    //     return ClassicGeneralDialogWidget(
    //       titleText: 'Discard changes',
    //       contentText: 'All changes will be discarded.',
    //       onPositiveClick: () {
    //         Navigator.of(context).pop();
    //         Navigator.pushReplacement(context, MaterialPageRoute(
    //           builder: (context) {
    //             return firstpage();
    //           },
    //         ));
    //       },
    //       onNegativeClick: () {
    //         Navigator.of(context).pop();
    //       },
    //     );
    //   },
    //   animationType: DialogTransitionType.fadeScale,
    //   curve: Curves.fastOutSlowIn,
    //   duration: Duration(seconds: 1),
    // );

    // AwesomeDialog(
    //   context: context,
    //   dialogType: DialogType.WARNING,
    //   animType: AnimType.BOTTOMSLIDE,
    //   title: 'Discard changes',
    //   desc: 'All changes will be discarded.',
    //   btnOkOnPress: () {
    //     Navigator.pop(context);
    //
    //     Navigator.pushReplacement(context, MaterialPageRoute(
    //       builder: (context) {
    //         return firstpage();
    //       },
    //     ));
    //   },
    //   btnCancelOnPress: () {
    //     Navigator.pop(context);
    //   },
    //
    // )..show();

    return Future.value(true);
  }
}
