import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/class_drawer.dart';
import 'grade_student.dart';

class Object {
  int? id;
  String? fname;
  String? lname;
  String? email;
  String? grade;

  Object({this.id, this.fname, this.lname, this.email, this.grade});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email'],
        grade: json['grade']);
  }
}

class NotifyGrade extends StatefulWidget {
  final String? idclass;
  const NotifyGrade(this.idclass, {super.key});

  @override
  State<NotifyGrade> createState() => _NotifyGradeState();
}

class _NotifyGradeState extends State<NotifyGrade> {
  int? id;
  String? fname;
  String? lname;

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

  Future<List<Object>> fetchJSON() async {
    String? idca = widget.idclass;
    var jsonResponse = await http.get(Uri.parse(
        'https://fasl.chabafarm.com/api/teacher/add_student/student_in_class/$idca'));

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
  void initState() {
    super.initState();
    fetchJSON();
    // futureAlbum = fetchAlbum();
    getCred();
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
      body: FutureBuilder<List<Object>>(
        future: fetchJSON(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            var items = data.data as List<Object>;
            return ListView.builder(
                itemCount: items.isEmpty ? 0 : items.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(
                      '${items[index].fname}  ${items[index].lname}',
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return GradeStudent(
                            items[index].id.toString(), widget.idclass);
                        // return AddStudent();
                      }));
                    },
                    subtitle: Text(
                      items[index].email.toString(),
                    ),
                    trailing: IconButton(
                      icon: Column(
                        children: [
                          if (items[index].grade.toString() != 'null') ...[
                            const Icon(Icons.check),
                          ] else ...[
                            const Icon(Icons.warning),
                          ]
                        ],
                      ),
                      onPressed: () {
                        // delrecord(items[index].id.toString());
                      },
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 242, 2, 250),
                      child: Text(items[index].fname.toString()[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          )),
                    ),
                  ));
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer:  ClassDrawer(fname: fname, lname: lname),
      floatingActionButton: FloatingActionButton(
        // ปุ่มทดสอบสำหรับดึงข้อมูลซ้ำ
        onPressed: _refreshData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
