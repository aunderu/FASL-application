import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/class_drawer.dart';
import 'addstudentv2.dart';
import 'create_class_activity.dart';
import 'studentclass.dart';
import 'update_class_activity.dart';


class Object {
  Object({this.id, this.fname, this.lname, this.email, this.status});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email'],
        status: json['status']);
  }

  String? email;
  String? fname;
  int? id;
  String? lname;
  String? status;
}

class ClassActivity extends StatefulWidget {
  const ClassActivity(this.idclass, {super.key});

  final String? idclass;

  @override
  State<ClassActivity> createState() => _ClassActivityState();
}

class _ClassActivityState extends State<ClassActivity> {
  String? fnamelogin;
  int? id;
  String? lnamelogin;

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

  @override
  void initState() {
    super.initState();
    fetchJSON();
    getCred();
  }

  Future<void> delrecord(String id, String status) async {
    try {
      String uri = "https://fasl.chabafarm.com/api/teacher/activity/status";

      var res =
          await http.post(Uri.parse(uri), body: {"id": id, "status": status});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
      } else {}
    } catch (e) {
      // print("ddd");
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

  Future<List<Object>> fetchJSON() async {
    String? idca = widget.idclass;
    var jsonResponse = await http.get(Uri.parse(
        'https://fasl.chabafarm.com/api/teacher/add_student/activity/class/$idca'));

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

  void _refreshData() {
    setState(() {
      fetchJSON();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('กิจกรรม'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return StudentClass(widget.idclass);
                            }));
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('นักเรียน'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return AddStudent(widget.idclass);
                            }));
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('+ เพิ่มนักเรียน'),
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
                              return CreateClassActivity(widget.idclass);
                            }));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('+ สร้าง'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 500.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.isEmpty ? 0 : items.length,
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 242, 2, 250),
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
                                                    return UpdateClassActivityScreen(
                                                        widget.idclass,
                                                        items[index].fname,
                                                        items[index].lname,
                                                        items[index]
                                                            .id
                                                            .toString());
                                                  }));
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
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
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
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
      drawer:  ClassDrawer(fname: fnamelogin, lname: lnamelogin),
    );
  }
}
