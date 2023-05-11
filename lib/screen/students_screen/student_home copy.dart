// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
// import 'package:myappv2/screen/class_screen/activity_room.dart';
// import 'package:myappv2/screen/class_screen/addstudent.dart';
// import 'package:myappv2/screen/class_screen/addstudentv2.dart';
// import 'package:myappv2/screen/class_screen/class_activity.dart';
// import 'package:myappv2/screen/class_screen/grade_page.dart';
// import 'package:myappv2/screen/class_screen/menu_create.dart';
// import 'package:myappv2/screen/class_screen/studentclass.dart';
// import 'package:myappv2/screen/class_screen/subjectpage.dart';
// import 'package:myappv2/screen/class_screen/work_room.dart';
// // import 'package:myappv2/screen/welcome.dart';
// import 'package:myappv2/screen/welcomev2.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // import 'package:myappv2/screen/students_screen/homepage.dart';

// class StudentHomeScreen extends StatefulWidget {
//   const StudentHomeScreen({super.key});

//   @override
//   State<StudentHomeScreen> createState() => _StudentHomeScreenState();
// }

// class _StudentHomeScreenState extends State<StudentHomeScreen> {
//   // final auth = FirebaseAuth.instance;

//   static const routeName = '/';
// // กำนหดตัวแปรข้อมูล articles
//   late Future<List<Article>> articles;
//   int? id = 0;
//   @override
//   void initState() {
//     print("initState");
//     super.initState();
//     articles = fetchArticle();
//     getCred();
//   }

//   void getCred() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     // SharedPreferences pref1 = await SharedPreferences.getInstance();
//     // SharedPreferences pref2 = await SharedPreferences.getInstance();
//     // SharedPreferences pref3 = await SharedPreferences.getInstance();
//     // SharedPreferences pref4 = await SharedPreferences.getInstance();
//     id = pref.getInt("id")!;
//     // fname = pref1.getString("fname")!;
//     // lname = pref2.getString("lname")!;
//     // user_type = pref3.getString("user_type")!;
//     // email = pref4.getString("email")!;
//   }

//   void _refreshData() {
//     setState(() {
//       print("setState");
//       articles = fetchArticle();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("build"); // สำหรับทดสอบ
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ติดตามนักเรียน'),
//         // actions: [
//         //   IconButton(
//         //       onPressed: () {
//         //         Navigator.push(context, MaterialPageRoute(builder: (context) {
//         //           // return CreateClass();
//         //           return MenuCreate();
//         //         }));
//         //       },
//         //       icon: Icon(Icons.add))
//         // ],
//       ),
//       body: Center(
//         child: FutureBuilder<List<Article>>(
//           // ชนิดของข้อมูล
//           future: articles, // ข้อมูล Future
//           builder: (context, snapshot) {
//             print("builder"); // สำหรับทดสอบ
//             print(snapshot.connectionState); // สำหรับทดสอบ
//             if (snapshot.hasData) {
//               // กรณีมีข้อมูล
//               return Column(
//                 children: [
//                   Column(
//                     children: [
//                       Container(
//                         // สร้างส่วน header ของลิสรายการ
//                         padding: const EdgeInsets.all(10.0),
//                         // decoration: BoxDecoration(
//                         //   color: Colors.teal.withAlpha(100),
//                         // ),
//                         child: Row(
//                           children: [
//                             Text(
//                               // 'จำนวน ${snapshot.data!.length} รายการ'), // แสดงจำนวนรายการ
//                               'ประจำชั้น', style: TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: ElevatedButton(
//                                 child: Text("ประจำชั้น"),
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Color.fromARGB(255, 98, 86, 226),
//                                   elevation: 0,
//                                 ),
//                                 onPressed: () {},
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: OutlinedButton(
//                                 child: Text("รายวิชา"),
//                                 style: OutlinedButton.styleFrom(
//                                   primary: Color.fromARGB(255, 98, 86, 226),
//                                   side: BorderSide(
//                                     color: Color.fromARGB(255, 98, 86, 226),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(context,
//                                       MaterialPageRoute(builder: (context) {
//                                     // return CreateClass();
//                                     return SubjectHomePageScreen();
//                                   }));
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     // ส่วนของลิสรายการ
//                     child: snapshot.data!.length > 0 // กำหนดเงื่อนไขตรงนี้
//                         ? ListView.separated(
//                             // กรณีมีรายการ แสดงปกติ

//                             padding: const EdgeInsets.all(10),
//                             itemCount: snapshot.data!.length,
//                             itemBuilder: (context, index) {
//                               // return ListTile(
//                               //   title: Text('ชั้นเรียน ' +
//                               //       snapshot.data![index].class_name +
//                               //       '   ห้อง ' +
//                               //       snapshot.data![index].class_room),
//                               //   subtitle: Text(
//                               //       'ปีการศึกษา ' + snapshot.data![index].year),
//                               // );
//                               return InkWell(
//                                 onTap: () {
//                                   // Navigator.push(context,
//                                   //     MaterialPageRoute(builder: (context) {
//                                   //   return ;
//                                   // }));
//                                   Navigator.push(context,
//                                       MaterialPageRoute(builder: (context) {
//                                     return ClassActivity(
//                                         snapshot.data![index].id.toString());
//                                     // return AddStudent();
//                                   }));
//                                 },
//                                 child: Container(
//                                   height: 70,
//                                   color: Color.fromARGB(255, 231, 207, 231),
//                                   child: ListTile(
//                                     title: Text('ชื่อวิชา ' +
//                                         snapshot.data![index].act_name +
//                                         '   ห้อง ' +
//                                         snapshot.data![index].act_detail),
//                                     subtitle: Text('ปีการศึกษา ' +
//                                         snapshot
//                                             .data![index].status_in_activity),
//                                   ),
//                                 ),
//                               );
//                             },
//                             separatorBuilder:
//                                 (BuildContext context, int index) =>
//                                     const Divider(),
//                           )
//                         : const Center(
//                             child: Text('No items')), // กรณีไม่มีรายการ
//                   ),
//                 ],
//               );
//             } else if (snapshot.hasError) {
//               // กรณี error
//               return Text('${snapshot.error}');
//             }
//             // กรณีสถานะเป็น waiting ยังไม่มีข้อมูล แสดงตัว loading
//             return const CircularProgressIndicator();
//           },
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text('Rusdee Lanong'),
//               accountEmail: Text("ครู"),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
//                 backgroundColor: Colors.white,
//               ),
//             ),
//             ListTile(
//               title: const Text('ชั้นเรียน'),
//               onTap: () {
//                 // Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 //   return GradeScreen();
//                 // }));
//               },
//             ),
//             ListTile(
//               title: const Text('รายงานผลการเรียน'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return GradeScreen();
//                 }));
//               },
//             ),
//             ListTile(
//               title: const Text('รายงานผลการเข้ากิจกรรม'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return ActivityRoom();
//                 }));
//               },
//             ),
//             ListTile(
//               title: const Text('รายงานการส่งงาน'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return WorkRoom();
//                 }));
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         // ปุ่มทดสอบสำหรับดึงข้อมูลซ้ำ
//         onPressed: _refreshData,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }

// // สรัางฟังก์ชั่นดึงข้อมูล คืนค่ากลับมาเป็นข้อมูล Future ประเภท List ของ Article
// Future<List<Article>> fetchArticle() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   int idst = pref.getInt("id")!;
//   print(idst);
//   // ทำการดึงข้อมูลจาก server ตาม url ที่กำหนด
//   final response = await http
//       .get(Uri.parse('https://fasl.chabafarm.com/api/student/activity/$idst'));

//   // เมื่อมีข้อมูลกลับมา
//   if (response.statusCode == 200) {
//     // ส่งข้อมูลที่เป็น JSON String data ไปทำการแปลง เป็นข้อมูล List<Article
//     // โดยใช้คำสั่ง compute ทำงานเบื้องหลัง เรียกใช้ฟังก์ชั่นชื่อ parseArticles
//     // ส่งข้อมูล JSON String data ผ่านตัวแปร response.body
//     return compute(parseArticles, response.body);
//   } else {
//     // กรณี error
//     throw Exception('Failed to load article');
//   }
// }

// // ฟังก์ชั่นแปลงข้อมูล JSON String data เป็น เป็นข้อมูล List<Article>
// List<Article> parseArticles(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<Article>((json) => Article.fromJson(json)).toList();
// }

// // Data models
// class Article {
//   // final int userId;
//   final int id;
//   late final String act_name;
//   late final String act_detail;
//   late final String status_in_activity;
//   // final String body;

//   Article({
//     // required this.userId,
//     required this.id,
//     required this.act_name,
//     required this.act_detail,
//     required this.status_in_activity,
//     // required this.body,
//   });

//   // ส่วนของ name constructor ที่จะแปลง json string มาเป็น Article object
//   factory Article.fromJson(Map<String, dynamic> json) {
//     return Article(
//       // userId: json['userId'],
//       id: json['id'],
//       act_name: json['act_name'],
//       act_detail: json['act_detail'],
//       status_in_activity: json['status_in_activity'],
//       // body: json['body'],
//     );
//   }
// }
