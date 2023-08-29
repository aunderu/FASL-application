import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/class_drawer.dart';
import 'notifygrade_page.dart';


class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  // final auth = FirebaseAuth.instance;


// กำนหดตัวแปรข้อมูล articles
  late Future<List<Article>> articles;

  String? fname;
  int? id;
  String? lname;

  @override
  void initState() {
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
      articles = fetchArticle();
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
      body: Center(
        child: FutureBuilder<List<Article>>(
          // ชนิดของข้อมูล
          future: articles, // ข้อมูล Future
          builder: (context, snapshot) {
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
                        child: const Row(
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
                    child: snapshot.data!.isNotEmpty // กำหนดเงื่อนไขตรงนี้
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
                                    title: Text('ชื่อวิชา ${snapshot.data![index].className}   ห้อง ${snapshot.data![index].classRoom}'),
                                    subtitle: Text('ปีการศึกษา ${snapshot.data![index].year}'),
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
      drawer:  ClassDrawer(fname: fname, lname: lname),
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
  // final String body;

  Article({
    // required this.userId,
    required this.id,
    required this.className,
    required this.classRoom,
    required this.year,
    // required this.body,
  });

  // ส่วนของ name constructor ที่จะแปลง json string มาเป็น Article object
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // userId: json['userId'],
      id: json['id'],
      className: json['class_name'],
      classRoom: json['class_room'],
      year: json['year'],
      // body: json['body'],
    );
  }

  late final String className;
  late final String classRoom;
  // final int userId;
  final String id;

  late final String year;
}
