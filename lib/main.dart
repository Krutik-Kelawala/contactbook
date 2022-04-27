import 'dart:io';

import 'package:contactbook/createcontactpg.dart';
import 'package:contactbook/databasehelp.dart';
import 'package:contactbook/editpage.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

void main() {
  runApp(MaterialApp(
    home: firstpage(),
  ));
}

class firstpage extends StatefulWidget {
  @override
  _firstpageState createState() => _firstpageState();
}

class _firstpageState extends State<firstpage> {
  Database? db;
  int? id;
  bool loadstatus = false;
  List<Map> viewlist = [];
  List<Map> searchlist = [];

  bool searchstatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      loadstatus = true;
    });
    getdata();
  }

  Future<void> getdata() {
    Databasehelper().Getdatabase().then((value) {
      setState(() {
        db = value;
      });
      Databasehelper().viewmydata(db!).then((listofmap) {
        setState(() {
          viewlist = listofmap;
        });
      });
    });
    return Future.value();
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
        ? Scaffold(
            appBar: searchstatus
                ? AppBar(
                    backgroundColor: Colors.deepOrangeAccent,
                    title: TextField(
                      decoration: InputDecoration(
                          hintText: "Search",
                          suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  searchstatus = false;
                                });
                              },
                              icon: Icon(Icons.close))),
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            searchlist = [];
                            for (int i = 0; i < viewlist.length; i++) {
                              if (viewlist[i]['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toString().toLowerCase())) {
                                searchlist.add(viewlist[i]);
                              }
                            }
                          } else {
                            setState(() {
                              searchlist = viewlist;
                            });
                          }
                        });
                      },
                    ),
                  )
                : AppBar(
                    backgroundColor: Colors.deepOrangeAccent,
                    title: Text("Contacts"),
                    actions: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              searchstatus = true;
                            });
                          },
                          icon: Icon(Icons.search))
                    ],
                  ),
            body: RefreshIndicator(
              color: Colors.black,
              onRefresh: getdata,
              child: ListView.builder(
                itemCount: searchstatus ? searchlist.length : viewlist.length,
                itemBuilder: (context, index) {
                  Map map = searchstatus ? searchlist[index] : viewlist[index];
                  return ListTile(
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 0) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return editpg(viewlist[index], db!);
                            },
                          ));
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              onTap: () {}, value: 0, child: Text("Edit")),
                          PopupMenuItem(
                              onTap: () {
                                id = viewlist[index]['id'];
                                Databasehelper().deletedata(db!, id!);

                                setState(() {});
                              },
                              value: 1,
                              child: Text("Delete"))
                        ];
                      },
                    ),
                    title: Text("${map['name']}"),
                    subtitle: Text("${viewlist[index]['phoneno']}"),
                    leading: Container(
                      height: 100,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                  File("${viewlist[index]['image']}")))),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepOrangeAccent,
              child: Icon(Icons.person_add),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return createcontact();
                  },
                ));
              },
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
