import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/parent_drawer.dart';

class Object {
  int? id;
  String? actName;
  String? actDetail;
  String? statusInActivity;

  Object({this.id, this.actName, this.actDetail, this.statusInActivity});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
        id: json['id'],
        actName: json['act_name'],
        actDetail: json['act_detail'],
        statusInActivity: json['status_in_activity']);
  }
}

class ParenWorkStudentScreen extends StatefulWidget {
  final String idstudent;
  final String fnamestudent;
  final String lnamestudent;
  const ParenWorkStudentScreen(
      this.idstudent, this.fnamestudent, this.lnamestudent,
      {super.key});

  @override
  State<ParenWorkStudentScreen> createState() => _ParenWorkStudentScreenState();
}

class _ParenWorkStudentScreenState extends State<ParenWorkStudentScreen> {
  int? id;
  String? fname;
  String? lname;

  @override
  void initState() {
    super.initState();
    fetchJSON();
    getCred();
  }

  void _refreshData() {
    setState(() {
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
        .get(Uri.parse('https://fasl.chabafarm.com/api/student/work/$idstu'));

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
                                  "การส่งงาน (${widget.fnamestudent} ${widget.lnamestudent})",
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
                                Text("สีน้ำเงิน: ผ่าน / สีแดง: ยังไม่ผ่าน"),
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
                                    items[index].actName.toString(),
                                  ),
                                  // onTap: () {
                                  //   getItemAndNavigate(items[index].name.toString(),
                                  //       items[index].email.toString(), context);
                                  // },
                                  subtitle: Text(
                                    items[index].actDetail.toString(),
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
                                              .statusInActivity
                                              .toString() ==
                                          "เข้าร่วม") ...[
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Text(
                                              items[index]
                                                  .actName
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
                                                  .actName
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
      drawer: ParentDrawer(fname: fname, lname: lname),
    );
  }
}
