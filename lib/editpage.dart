import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import 'databasehelp.dart';
import 'main.dart';

class editpg extends StatefulWidget {
  Map viewlist;
  Database updatedata;

  editpg(this.viewlist, this.updatedata);

  @override
  _editpgState createState() => _editpgState();
}

class _editpgState extends State<editpg> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool namestatus = false;
  bool phonenumberstatus = false;
  bool loadapp = false;
  Database? db;
  int? id;
  String newimage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String personname = widget.viewlist['name'];
    name.text = personname;
    String personnumber = widget.viewlist['phoneno'];
    phoneno.text = personnumber;
    id = widget.viewlist['id'];

    setState(() {
      loadapp = true;
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
    return loadapp
        ? WillPopScope(
            onWillPop: onback,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.deepOrangeAccent,
                title: Text("Edit contact"),
              ),
              body: SingleChildScrollView(
                child: SafeArea(
                    child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(0xFFD7957D),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      height: bodyheight * 0.3,
                      child: InkWell(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            newimage = image!.path;
                          });
                        },
                        child: newimage != ""
                            ? Image(
                                fit: BoxFit.cover,
                                image: FileImage(File('image')))
                            : Container(
                                child: Icon(
                                  Icons.account_circle,
                                  size: bodyheight * 0.25,
                                ),
                              ),
                      ),
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

                                  Databasehelper().updatedata(pname, pphno,
                                      widget.updatedata, id!, newimage);

                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return firstpage();
                                    },
                                  ));

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
    return Future.value(true);
  }
}
