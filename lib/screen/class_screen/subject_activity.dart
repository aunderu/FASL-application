import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:myappv2/screen/class_screen/activity_room.dart';
// import 'package:myappv2/screen/class_screen/SubjectActivity.dart';
import 'package:myappv2/screen/class_screen/addstudentv2.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/create_subject_activity.dart';
import 'package:myappv2/screen/class_screen/grade_page.dart';
import 'package:myappv2/screen/class_screen/menu_create.dart';
import 'package:myappv2/screen/class_screen/student_subject.dart';
import 'package:myappv2/screen/class_screen/subject_add_student.dart';
import 'package:myappv2/screen/class_screen/subjectpage.dart';
import 'package:myappv2/screen/class_screen/update_class_subject.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:myappv2/screen/class_screen/addstudentv2.dart';

import 'homepage.dart';

class Object {
  int? id;
  String? fname;
  String? lname;
  String? email;
  String? status;

  Object({this.id, this.fname, this.lname, this.email, this.status});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email'],
        status: json['status']);
  }
}

class SubjectActivity extends StatefulWidget {
  final String? idclass;
  const SubjectActivity(this.idclass, {super.key});

  @override
  State<SubjectActivity> createState() => _SubjectActivityState();
}

class _SubjectActivityState extends State<SubjectActivity> {
  int? id;
  String? fname;
  String? lname;

  void initState() {
    print("initState");
    super.initState();
    fetchJSON();
    getCred();
  }

  void _refreshData() {
    setState(() {
      print("setState");
      fetchJSON();
    });
  }

  @override
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    SharedPreferences pref2 = await SharedPreferences.getInstance();
    // SharedPreferences pref4 = await SharedPreferences.getInstance();

    setState(() {
      id = pref.getInt("id")!;
      fname = pref1.getString("fname")!;
      lname = pref2.getString("lname")!;
    });
  }

  Future<void> delrecord(String id, String status) async {
    // String? idc = widget.idclass;
    try {
      String uri = "https://fasl.chabafarm.com/api/teacher/activity/status";

      var res =
          await http.post(Uri.parse(uri), body: {"id": id, "status": status});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
        print("yes");
      } else {
        print("not");
      }
    } catch (e) {
      print("ddd");
    }
  }

  Future<List<Object>> fetchJSON() async {
    String? idca = widget.idclass;
    print(idca);
    var jsonResponse = await http.get(Uri.parse(
        'https://fasl.chabafarm.com/api/teacher/add_student/activity/$idca'));

    if (jsonResponse.statusCode == 200) {
      final jsonItems =
          json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

      List<Object> tempList = jsonItems.map<Object>((json) {
        return Object.fromJson(json);
      }).toList();

      return tempList;
    } else {
      throw Exception('Failed To Load Data...');
    }
  }

  Future<void> deleterecord(String idclass) async {
    try {
      String uri = "https://fasl.chabafarm.com/api/teacher/activity/destroy";
      var res = await http.post(Uri.parse(uri), body: {"id": idclass});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
      } else {}
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'งานของชั้นเรียน',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(context, MaterialPageRoute(builder: (context) {
        //           // return CreateClass();
        //           return MenuCreate();
        //         }));
        //       },
        //       icon: Icon(Icons.add))
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Object>>(
          future: fetchJSON(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as List<Object>;
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('งานของชั้นเรียน'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return StudentSubject(widget.idclass);
                            }));
                          },
                          child: Text('นักเรียน'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return CreateStudentSubject(widget.idclass);
                            }));
                          },
                          child: Text('+ เพิ่มนักเรียน'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // ignore: prefer_const_constructors
                  Divider(
                    color: Colors.black45,
                    indent: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return CreateSubjectActivity(widget.idclass);
                            }));
                          },
                          child: Text('+ สร้าง'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 500.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items == null ? 0 : items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        items[index].fname.toString(),
                                      ),
                                      // onTap: () {
                                      //   getItemAndNavigate(items[index].name.toString(),
                                      //       items[index].email.toString(), context);
                                      // },
                                      subtitle: Text(
                                        items[index].lname.toString(),
                                      ),
                                      // trailing: IconButton(
                                      //   icon: Icon(Icons.delete),
                                      //   onPressed: () {
                                      //     delrecord(items[index].id.toString());
                                      //   },
                                      // ),
                                      trailing: Column(
                                        children: [
                                          if (items[index].status.toString() ==
                                              '1') ...[
                                            IconButton(
                                              icon: const Icon(Icons.check_box),
                                              onPressed: () {
                                                delrecord(
                                                    items[index].id.toString(),
                                                    "0");
                                              },
                                            ),
                                          ] else ...[
                                            IconButton(
                                              icon: const Icon(Icons
                                                  .check_box_outline_blank),
                                              onPressed: () {
                                                delrecord(
                                                    items[index].id.toString(),
                                                    "1");
                                              },
                                            ),
                                          ]
                                        ],
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            Color.fromARGB(255, 242, 2, 250),
                                        child: Text(
                                            items[index].fname.toString()[0],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                            )),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              height: 35,
                                              color: Colors.yellow,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    // return CreateClass();
                                                    return UpdateClassSubjectScreen(
                                                        widget.idclass,
                                                        items[index].fname,
                                                        items[index].lname,
                                                        items[index]
                                                            .id
                                                            .toString());
                                                  }));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Text(
                                                        "แก้ไขข้อมูล",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          child: Container(
                                              height: 35,
                                              color: Colors.red,
                                              child: TextButton(
                                                onPressed: () {
                                                  deleterecord(items[index]
                                                      .id
                                                      .toString());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Text(
                                                        "ลบข้อมูล",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // ปุ่มทดสอบสำหรับดึงข้อมูลซ้ำ
        onPressed: _refreshData,
        child: const Icon(Icons.refresh),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('$fname $lname'),
              accountEmail: Text("ครู"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              title: const Text('หน้าแรก'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ClassHomePageScreen();
                }));
              },
            ),
            ListTile(
              title: const Text('รายงานผลการเรียน'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GradeScreen();
                }));
              },
            ),
            ListTile(
              title: const Text('รายงานผลการเข้ากิจกรรม'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ActivityRoom();
                }));
              },
            ),
            ListTile(
              title: const Text('รายงานการส่งงาน'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WorkRoom();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
