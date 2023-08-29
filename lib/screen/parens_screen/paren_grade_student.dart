import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/parent_drawer.dart';
import '../students_screen/student_grade_img.dart';
// import 'package:myappv2/screen/class_screen/addstudentv2.dart';

class Object {
  String? id;
  String? stID;
  String? crID;
  String? grade;
  String? className;
  String? classRoom;
  String? year;

  Object(
      {this.id,
      this.stID,
      this.crID,
      this.grade,
      this.className,
      this.classRoom,
      this.year});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
      id: json['id'],
      stID: json['stID'],
      crID: json['crID'],
      grade: json['grade'],
      className: json['class_name'],
      classRoom: json['class_room'],
      year: json['year'],
    );
  }
}

class ParenGradeStudentScreen extends StatefulWidget {
  final String idstudent;
  final String fnamestudent;
  final String lnamestudent;
  const ParenGradeStudentScreen(
      this.idstudent, this.fnamestudent, this.lnamestudent,
      {super.key});

  @override
  State<ParenGradeStudentScreen> createState() =>
      _ParenGradeStudentScreenState();
}

class _ParenGradeStudentScreenState extends State<ParenGradeStudentScreen> {
  int? id;
  String? fname;
  String? lname;

  @override
  void initState() {
    // print("initState");
    super.initState();
    fetchJSON();
    getCred();
  }

  void _refreshData() {
    setState(() {
      // print("setState");
      fetchJSON();
    });
  }

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
        // print("yes");
      } else {
        // print("not");
      }
    } catch (e) {
      // print("ddd");
    }
  }

  Future<List<Object>> fetchJSON() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // id = pref.getInt("id")!;
    String idstu = widget.idstudent;
    var jsonResponse = await http
        .get(Uri.parse('https://fasl.chabafarm.com/api/student/grade/$idstu'));

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'ผลการเรียน',
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
                                  "ผลการเรียน (${widget.fnamestudent} ${widget.lnamestudent})",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 16, 14, 14),
                                    fontSize: 16.0,
                                  )),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 0, top: 8),
                            child: Row(
                              children: [
                                // Text("สีน้ำเงิน: ผ่าน / สีแดง: ยังไม่ผ่าน"),
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
                        itemCount: items.isEmpty ? 0 : items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    '${items[index].className} ห้อง${items[index].classRoom}',
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return StudentGradeImgScreen(
                                          items[index].grade.toString());
                                    }));
                                  },
                                  subtitle: Text(
                                    'ปีการศึกษา ${items[index].year}',
                                  ),
                                  // trailing: IconButton(
                                  //   icon: Icon(Icons.delete),
                                  //   onPressed: () {
                                  //     delrecord(items[index].id.toString());
                                  //   },
                                  // ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.image),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return StudentGradeImgScreen(
                                            items[index].grade);
                                      }));
                                    },
                                  ),
                                  leading: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            const Color.fromARGB(255, 242, 2, 250),
                                        child: Text(
                                            items[index]
                                                .className
                                                .toString()[0],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                            )),
                                      ),
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
      drawer: ParentDrawer(fname: fname, lname: lname),
    );
  }
}
