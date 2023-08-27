import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:myappv2/loginv2.dart';
import 'package:myappv2/screen/class_screen/activity_room.dart';
// import 'package:myappv2/screen/class_screen/ParenStudentAllScreen.dart';
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
import 'package:myappv2/screen/home.dart';
import 'package:myappv2/screen/parens_screen/paren_activity.dart';
import 'package:myappv2/screen/parens_screen/paren_grade.dart';
import 'package:myappv2/screen/parens_screen/paren_home.dart';
import 'package:myappv2/screen/parens_screen/paren_work.dart';
import 'package:myappv2/screen/parens_screen/paren_workv2.dart';
import 'package:myappv2/screen/students_screen/student_activity.dart';
import 'package:myappv2/screen/students_screen/student_grade.dart';
import 'package:myappv2/screen/students_screen/student_work.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:myappv2/screen/class_screen/addstudentv2.dart';

class Object {
  int? id;
  String? act_name;
  String? act_detail;
  String? status_in_activity;

  Object({this.id, this.act_name, this.act_detail, this.status_in_activity});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
        id: json['id'],
        act_name: json['act_name'],
        act_detail: json['act_detail'],
        status_in_activity: json['status_in_activity']);
  }
}

class ParenStudentAllScreen extends StatefulWidget {
  final String idstudent;
  final String fnamestudent;
  final String lnamestudent;
  const ParenStudentAllScreen(
      this.idstudent, this.fnamestudent, this.lnamestudent,
      {super.key});

  @override
  State<ParenStudentAllScreen> createState() => _ParenStudentAllScreenState();
}

class _ParenStudentAllScreenState extends State<ParenStudentAllScreen> {
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

  Future<void> delrecord(String id) async {
    try {
      String uri =
          "https://fasl.chabafarm.com/api/teacher/add_student/store/delete/19";

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
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // id = pref.getInt("id")!;
    String idstu = widget.idstudent;
    var jsonResponse = await http
        .get(Uri.parse('https://fasl.chabafarm.com/api/student/$idstu'));

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
          'กิจกรรม/งาน',
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
                  Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  "กิจกรรมและงานทั้งหมด (" +
                                      widget.fnamestudent +
                                      " " +
                                      widget.lnamestudent +
                                      ")",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 16, 14, 14),
                                    fontSize: 22.0,
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 8),
                            child: Row(
                              children: [
                                Text("สีเขียว: ผ่าน / สีแดง: ยังไม่ผ่าน"),
                              ],
                            ),
                          )
                        ],
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
                                child: ListTile(
                                  title: Text(
                                    items[index].act_name.toString(),
                                  ),
                                  // onTap: () {
                                  //   getItemAndNavigate(items[index].name.toString(),
                                  //       items[index].email.toString(), context);
                                  // },
                                  subtitle: Text(
                                    items[index].act_detail.toString(),
                                  ),
                                  // trailing: IconButton(
                                  //   icon: Icon(Icons.delete),
                                  //   onPressed: () {
                                  //     delrecord(items[index].id.toString());
                                  //   },
                                  // ),

                                  leading: Column(
                                    children: [
                                      if (items[index]
                                              .status_in_activity
                                              .toString() ==
                                          "เข้าร่วม") ...[
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Text(
                                              items[index]
                                                  .act_name
                                                  .toString()[0],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22.0,
                                              )),
                                        ),
                                      ] else ...[
                                        CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Text(
                                              items[index]
                                                  .act_name
                                                  .toString()[0],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22.0,
                                              )),
                                        ),
                                      ]
                                    ],
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
              accountName: Text('$fname $lname'),
              accountEmail: Text("ผู้ปกครอง"),
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
                  return ParenHomeScreen();
                }));
              },
            ),
            ListTile(
              title: const Text('รายงานผลการเรียน'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ParenGradeScreen();
                }));
              },
            ),
            ListTile(
              title: const Text('กิจกรรม'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ParenActivityScreen();
                }));
              },
            ),
            ListTile(
              title: const Text('การส่งงาน'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ParenWorkv2Screen();
                }));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('ออกจากระบบ'),
                  ),
                ],
              ),
              onTap: () async {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();

                sharedPreferences.clear();

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
