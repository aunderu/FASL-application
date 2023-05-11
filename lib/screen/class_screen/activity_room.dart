import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:myappv2/screen/class_screen/activity_list.dart';
// import 'package:myappv2/screen/class_screen/ActivityRoom.dart';
import 'package:myappv2/screen/class_screen/addstudentv2.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/create_class_activity.dart';
import 'package:myappv2/screen/class_screen/create_subject_activity.dart';
import 'package:myappv2/screen/class_screen/grade_page.dart';
import 'package:myappv2/screen/class_screen/menu_create.dart';
import 'package:myappv2/screen/class_screen/student_subject.dart';
import 'package:myappv2/screen/class_screen/studentclass.dart';
import 'package:myappv2/screen/class_screen/subject_add_student.dart';
import 'package:myappv2/screen/class_screen/subjectpage.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:myappv2/screen/class_screen/addstudentv2.dart';

import 'homepage.dart';

class Object {
  String? id;
  String? act_name;
  String? act_detail;
  String? crID;

  Object({this.id, this.act_name, this.act_detail, this.crID});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
      id: json['id'],
      act_name: json['act_name'],
      act_detail: json['act_detail'],
      crID: json['crID'],
    );
  }
}

class ActivityRoom extends StatefulWidget {
  // final String? idclass;
  const ActivityRoom({super.key});

  @override
  State<ActivityRoom> createState() => _ActivityRoomState();
}

class _ActivityRoomState extends State<ActivityRoom> {
  int? id;
  String? fnamelogin;
  String? lnamelogin;
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
      fnamelogin = pref1.getString("fname")!;
      lnamelogin = pref2.getString("lname")!;
    });
  }

  Future<void> delrecord(String id) async {
    // String? idc = widget.idclass;
    try {
      String uri =
          "https://fasl.chabafarm.com/api/teacher/add_student/store/delete/1";

      var res = await http.post(Uri.parse(uri), body: {"id": id});
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
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getInt("id")!;
    // String? idca = widget.idclass;
    var jsonResponse = await http
        .get(Uri.parse('https://fasl.chabafarm.com/api/teacher/activity/$id'));

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

  @override
  Widget build(BuildContext context) {
    print("build"); // สำหรับทดสอบ
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'กิจกรรมของชั้นเรียน',
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
                                child: ListTile(
                                  title: Text(
                                    items[index].act_name.toString(),
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ActivityParticipate(
                                          items[index].crID.toString(),
                                          items[index].id.toString());
                                    }));
                                  },
                                  subtitle: Text(
                                    items[index].act_detail.toString(),
                                  ),
                                  // trailing: IconButton(
                                  //   icon: Icon(Icons.delete),
                                  //   onPressed: () {
                                  //     delrecord(items[index].id.toString());
                                  //   },
                                  // ),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 242, 2, 250),
                                    child: Text(
                                        items[index].act_name.toString()[0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                        )),
                                  ),
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
              accountName: Text('$fnamelogin $lnamelogin'),
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
                Navigator.pop(context);
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
