import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:myappv2/screen/class_screen/activity_room.dart';
import 'package:myappv2/screen/class_screen/addstudent.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/menu_create.dart';
import 'package:myappv2/screen/class_screen/notifygrade_page.dart';
import 'package:myappv2/screen/class_screen/subjectpage.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
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

  void _refreshData() {
    setState(() {
      print("setState");
      articles = fetchArticle();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build"); // สำหรับทดสอบ
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
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
                      Container(
                        // สร้างส่วน header ของลิสรายการ
                        padding: const EdgeInsets.all(10.0),
                        // decoration: BoxDecoration(
                        //   color: Colors.teal.withAlpha(100),
                        // ),
                        child: Row(
                          children: [
                            Text(
                              // 'จำนวน ${snapshot.data!.length} รายการ'), // แสดงจำนวนรายการ
                              'สำหรับแจ้งผลการเรียน',
                              style: TextStyle(fontSize: 16),
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

                            padding: const EdgeInsets.all(10),
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
                                  //   return AddStudent();
                                  // }));
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return NotifyGrade(
                                        snapshot.data![index].id);
                                  }));
                                },
                                child: Container(
                                  height: 70,
                                  // color: Color.fromARGB(255, 231, 207, 231),
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
                                  child: ListTile(
                                    title: Text('ชื่อวิชา ' +
                                        snapshot.data![index].class_name +
                                        '   ห้อง ' +
                                        snapshot.data![index].class_room),
                                    subtitle: Text('ปีการศึกษา ' +
                                        snapshot.data![index].year),
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
  // final String body;

  Article({
    // required this.userId,
    required this.id,
    required this.class_name,
    required this.class_room,
    required this.year,
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
      // body: json['body'],
    );
  }
}
