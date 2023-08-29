import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/class_drawer.dart';
import 'class_activity.dart';
import 'create_class.dart';
import 'create_subjext.dart';
import 'subjectpage.dart';
import 'update_class.dart';

class ClassHomePageScreen extends StatefulWidget {
  const ClassHomePageScreen({super.key});

  @override
  State<ClassHomePageScreen> createState() => _ClassHomePageScreenState();
}

class _ClassHomePageScreenState extends State<ClassHomePageScreen> {
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

  Future<void> delrecord(String stId, String status) async {
    // CircularProgressIndicator();
    // String? idc = widget.idclass;
    try {
      String uri = "https://fasl.chabafarm.com/api/teacher/class_room/status";
      const CircularProgressIndicator();
      var res =
          await http.post(Uri.parse(uri), body: {"id": stId, "status": status});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
      } else {}
    } catch (e) {
      // print("error");
    }
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
    } catch (e) {
      // print("error");
    }
  }

  void _refreshData() {
    setState(() {
      articles = fetchArticle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(246, 253, 253, 252),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
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
              // customItemsHeights: [
              //   ...List<double>.filled(MenuItems.firstItems.length, 48),
              //   8,
              //   // ...List<double>.filled(MenuItems.secondItems.length, 48),
              // ],
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 98, 86, 226),
                                  elevation: 0,
                                ),
                                onPressed: () {},
                                child: const Text("ประจำชั้น"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color.fromARGB(255, 98, 86, 226), side: const BorderSide(
                                    color: Color.fromARGB(255, 98, 86, 226),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    // return CreateClass();
                                    return const SubjectHomePageScreen();
                                  }));
                                },
                                child: const Text("รายวิชา"),
                              ),
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
                                        title: Text('${snapshot.data![index].className}   ห้อง ${snapshot.data![index].classRoom}'),
                                        subtitle: Text('ปีการศึกษา ${snapshot.data![index].year}${snapshot.data![index].status}'),
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
                                                              .className,
                                                          snapshot.data![index]
                                                              .classRoom,
                                                          snapshot.data![index]
                                                              .year,
                                                          snapshot
                                                              .data![index].id);
                                                    }));
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets
                                                                .all(0),
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
                                                    deleterecord(snapshot
                                                        .data![index].id);
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
    required this.status,
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
      status: json['status'],
      // body: json['body'],
    );
  }

  late final String className;
  late final String classRoom;
  // final int userId;
  final String id;

  late final String status;
  late final String year;
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final IconData icon;
  final String text;
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
          return const CreateClass();
        }));
        break;
      // case MenuItems.settings:
      //   //Do something
      //   break;
      case MenuItems.share:
        //Do something
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const CreateSubject();
        }));
        break;
      // case MenuItems.logout:
      //   //Do something
      //   break;
    }
  }
}
