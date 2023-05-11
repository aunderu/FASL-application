import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:myappv2/screen/class_screen/activity_room.dart';
import 'package:myappv2/screen/class_screen/addstudent.dart';
import 'package:myappv2/screen/class_screen/addstudentv2.dart';
import 'package:myappv2/screen/class_screen/class_activity.dart';
import 'package:myappv2/screen/class_screen/create_class.dart';
import 'package:myappv2/screen/class_screen/create_subjext.dart';
import 'package:myappv2/screen/class_screen/grade_page.dart';
import 'package:myappv2/screen/class_screen/menu_create.dart';
import 'package:myappv2/screen/class_screen/studentclass.dart';
import 'package:myappv2/screen/class_screen/subjectpage.dart';
import 'package:myappv2/screen/class_screen/update_class.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class ClassHomePageScreen extends StatefulWidget {
  const ClassHomePageScreen({super.key});

  @override
  State<ClassHomePageScreen> createState() => _ClassHomePageScreenState();
}

class _ClassHomePageScreenState extends State<ClassHomePageScreen> {
  // final auth = FirebaseAuth.instance;

  static const routeName = '/';
// กำนหดตัวแปรข้อมูล articles
  late Future<List<Article>> articles;
  int? id;
  String? fname;
  String? lname;
  @override
  void initState() {
    print("initState");
    super.initState();
    articles = fetchArticle();
    getCred();
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

  Future<void> delrecord(String StId, String status) async {
    // CircularProgressIndicator();
    // String? idc = widget.idclass;
    try {
      String uri = "https://fasl.chabafarm.com/api/teacher/class_room/status";
      CircularProgressIndicator();
      var res =
          await http.post(Uri.parse(uri), body: {"id": StId, "status": status});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
      } else {}
    } catch (e) {}
  }

  Future<void> deleterecord(String idclass) async {
    // CircularProgressIndicator();
    // String? idc = widget.idclass;
    try {
      String uri = "https://fasl.chabafarm.com/api/teacher/class_room/destroy";
      // CircularProgressIndicator();
      var res = await http.post(Uri.parse(uri), body: {"id": idclass});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
      } else {}
    } catch (e) {}
  }

  void _refreshData() {
    setState(() {
      articles = fetchArticle();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build"); // สำหรับทดสอบ
    return Scaffold(
      // backgroundColor: Color.fromARGB(246, 253, 253, 252),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'ติดตามนักเรียน',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         // return CreateClass();
          //         return MenuCreate();
          //       }));
          //     },
          //     icon: Icon(
          //       Icons.add,
          //       color: Colors.black,
          //     ))
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              customButton: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              customItemsHeights: [
                ...List<double>.filled(MenuItems.firstItems.length, 48),
                8,
                // ...List<double>.filled(MenuItems.secondItems.length, 48),
              ],
              items: [
                ...MenuItems.firstItems.map(
                  (item) => DropdownMenuItem<MenuItem>(
                    value: item,
                    child: MenuItems.buildItem(item),
                  ),
                ),
                const DropdownMenuItem<Divider>(
                    enabled: false, child: Divider()),
                // ...MenuItems.secondItems.map(
                //   (item) => DropdownMenuItem<MenuItem>(
                //     value: item,
                //     child: MenuItems.buildItem(item),
                //   ),
                // ),
              ],
              onChanged: (value) {
                MenuItems.onChanged(context, value as MenuItem);
              },
              itemHeight: 48,
              itemPadding: const EdgeInsets.only(left: 16, right: 16),
              dropdownWidth: 160,
              dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              dropdownElevation: 8,
              offset: const Offset(0, 8),
            ),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Article>>(
          // ชนิดของข้อมูล

          future: articles, // ข้อมูล Future
          builder: (context, snapshot) {
            print("builder"); // สำหรับทดสอบ
            print(snapshot.connectionState); // สำหรับทดสอบ
            if (snapshot.hasData) {
              // กรณีมีข้อมูล
              return Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: ElevatedButton(
                                child: Text("ประจำชั้น"),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 98, 86, 226),
                                  elevation: 0,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: OutlinedButton(
                                child: Text("รายวิชา"),
                                style: OutlinedButton.styleFrom(
                                  primary: Color.fromARGB(255, 98, 86, 226),
                                  side: BorderSide(
                                    color: Color.fromARGB(255, 98, 86, 226),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    // return CreateClass();
                                    return SubjectHomePageScreen();
                                  }));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    // ส่วนของลิสรายการ
                    child: snapshot.data!.length > 0 // กำหนดเงื่อนไขตรงนี้
                        ? ListView.separated(
                            // กรณีมีรายการ แสดงปกติ

                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              // return ListTile(
                              //   title: Text('ชั้นเรียน ' +
                              //       snapshot.data![index].class_name +
                              //       '   ห้อง ' +
                              //       snapshot.data![index].class_room),
                              //   subtitle: Text(
                              //       'ปีการศึกษา ' + snapshot.data![index].year),
                              // );
                              return InkWell(
                                onTap: () {
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return ;
                                  // }));
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ClassActivity(
                                        snapshot.data![index].id);
                                    // return AddStudent();
                                  }));
                                },
                                child: Container(
                                  height: 107,
                                  // color: Color.fromARGB(255, 255, 255, 255),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 10.0, // soften the shadow
                                        spreadRadius: 1.0, //extend the shadow
                                        offset: Offset(
                                          1.0, // Move to right 5  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text('' +
                                            snapshot.data![index].class_name +
                                            '   ห้อง ' +
                                            snapshot.data![index].class_room),
                                        subtitle: Text('ปีการศึกษา ' +
                                            snapshot.data![index].year +
                                            snapshot.data![index].status),
                                        trailing: Column(
                                          children: [
                                            if (snapshot.data![index].status ==
                                                '1') ...[
                                              IconButton(
                                                icon:
                                                    const Icon(Icons.check_box),
                                                onPressed: () {
                                                  delrecord(
                                                      snapshot.data![index].id,
                                                      "0");
                                                },
                                              ),
                                            ] else ...[
                                              IconButton(
                                                icon: const Icon(Icons
                                                    .check_box_outline_blank),
                                                onPressed: () {
                                                  delrecord(
                                                      snapshot.data![index].id,
                                                      "1");
                                                },
                                              ),
                                            ]
                                          ],
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
                                                      return UpdateClassScreen(
                                                          snapshot.data![index]
                                                              .class_name,
                                                          snapshot.data![index]
                                                              .class_room,
                                                          snapshot.data![index]
                                                              .year,
                                                          snapshot
                                                              .data![index].id);
                                                    }));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        child: const Text(
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
                                                    deleterecord(snapshot
                                                        .data![index].id);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          )
                        : const Center(
                            child: Text('No items')), // กรณีไม่มีรายการ
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              // กรณี error
              return Text('${snapshot.error}');
            }
            // กรณีสถานะเป็น waiting ยังไม่มีข้อมูล แสดงตัว loading
            return const CircularProgressIndicator();
          },
        ),
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
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return GradeScreen();
                // }));
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
      floatingActionButton: FloatingActionButton(
        // ปุ่มทดสอบสำหรับดึงข้อมูลซ้ำ
        onPressed: _refreshData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// สรัางฟังก์ชั่นดึงข้อมูล คืนค่ากลับมาเป็นข้อมูล Future ประเภท List ของ Article
Future<List<Article>> fetchArticle() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int id = pref.getInt("id")!;
  // ทำการดึงข้อมูลจาก server ตาม url ที่กำหนด
  final response = await http.get(Uri.parse(
      'https://fasl.chabafarm.com/api/teacher/class_room/cr_data/$id'));

  // เมื่อมีข้อมูลกลับมา
  if (response.statusCode == 200) {
    // ส่งข้อมูลที่เป็น JSON String data ไปทำการแปลง เป็นข้อมูล List<Article
    // โดยใช้คำสั่ง compute ทำงานเบื้องหลัง เรียกใช้ฟังก์ชั่นชื่อ parseArticles
    // ส่งข้อมูล JSON String data ผ่านตัวแปร response.body
    return compute(parseArticles, response.body);
  } else {
    // กรณี error
    throw Exception('Failed to load article');
  }
}

// ฟังก์ชั่นแปลงข้อมูล JSON String data เป็น เป็นข้อมูล List<Article>
List<Article> parseArticles(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Article>((json) => Article.fromJson(json)).toList();
}

// Data models
class Article {
  // final int userId;
  final String id;
  late final String class_name;
  late final String class_room;
  late final String year;
  late final String status;
  // final String body;

  Article({
    // required this.userId,
    required this.id,
    required this.class_name,
    required this.class_room,
    required this.year,
    required this.status,
    // required this.body,
  });

  // ส่วนของ name constructor ที่จะแปลง json string มาเป็น Article object
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // userId: json['userId'],
      id: json['id'],
      class_name: json['class_name'],
      class_room: json['class_room'],
      year: json['year'],
      status: json['status'],
      // body: json['body'],
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, share];
  // static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(
    text: 'เพิ่มชั้นเรียน',
    icon: Icons.add,
  );
  static const share = MenuItem(text: 'เพิ่มวิชา', icon: Icons.add);
  // static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black87, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        //Do something
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CreateClass();
        }));
        break;
      // case MenuItems.settings:
      //   //Do something
      //   break;
      case MenuItems.share:
        //Do something
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CreateSubject();
        }));
        break;
      // case MenuItems.logout:
      //   //Do something
      //   break;
    }
  }
}
