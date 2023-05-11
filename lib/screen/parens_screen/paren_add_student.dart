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
import 'package:myappv2/screen/class_screen/class_activity.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/grade_page.dart';
// import 'package:myappv2/screen/class_screen/ParenAddStudentScreen.dart';
import 'package:myappv2/screen/class_screen/menu_create.dart';
import 'package:myappv2/screen/class_screen/studentclass.dart';
import 'package:myappv2/screen/class_screen/subjectpage.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
import 'package:myappv2/screen/home.dart';
import 'package:myappv2/screen/parens_screen/paren_activity.dart';
import 'package:myappv2/screen/parens_screen/paren_grade.dart';
import 'package:myappv2/screen/parens_screen/paren_home.dart';
import 'package:myappv2/screen/parens_screen/paren_student.dart';
import 'package:myappv2/screen/parens_screen/paren_work.dart';
import 'package:myappv2/screen/parens_screen/paren_workv2.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'homepage.dart';

class Object {
  int? id;
  String? fname;
  String? lname;
  String? email;

  Object({this.id, this.fname, this.lname, this.email});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email']);
  }
}

class ParenAddStudentScreen extends StatefulWidget {
  const ParenAddStudentScreen({super.key});

  @override
  State<ParenAddStudentScreen> createState() => _ParenAddStudentScreenState();
}

class _ParenAddStudentScreenState extends State<ParenAddStudentScreen> {
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

  Future<void> delrecord(String StId) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      id = pref.getInt("id")!;
      String uri =
          "https://fasl.chabafarm.com/api/parent/add_student/store/$id";

      var res = await http.post(Uri.parse(uri), body: {"stID": StId});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
        print("yes");
      } else {
        print("not");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<Object>> fetchJSON() async {
    // String? idca = widget.idclass;
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // id = pref.getInt("id")!;
    var jsonResponse = await http
        .get(Uri.parse('https://fasl.chabafarm.com/api/parent/NotStudent/$id'));

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
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'เลือกบุตรหลาน',
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
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return ParenStudentScreen();
                            }));
                          },
                          child: Text('บุตรหลาน'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('+ เพิ่มบุตรหลาน'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black45,
                    indent: 16.0,
                  ),
                  SizedBox(
                    height: 560.0,
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
                                    items[index].fname.toString() +
                                        '  ' +
                                        items[index].lname.toString(),
                                  ),
                                  // onTap: () {
                                  //   getItemAndNavigate(items[index].name.toString(),
                                  //       items[index].email.toString(), context);
                                  // },
                                  subtitle: Text(
                                    items[index].email.toString(),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      delrecord(items[index].id.toString());
                                    },
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 242, 2, 250),
                                    child:
                                        Text(items[index].fname.toString()[0],
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
              title: const Text('รายงานผลการเข้ากิจกรรม'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ParenActivityScreen();
                }));
              },
            ),
            ListTile(
              title: const Text('รายงานการส่งงาน'),
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
                  return LoginV2();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
