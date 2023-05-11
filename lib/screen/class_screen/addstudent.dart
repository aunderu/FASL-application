// // ignore_for_file: prefer_const_constructors

// import 'dart:convert' as convert;
// import 'dart:async';
// import 'dart:convert';
// import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
// import 'package:bs_flutter_modal/bs_flutter_modal.dart';
// import 'package:bs_flutter_responsive/bs_flutter_responsive.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:get/get_connect/http/src/response/response.dart';

// import 'package:http/http.dart' as http;
// import 'package:http/http.dart';
// import 'package:myappv2/screen/class_screen/addstudent.dart';
// import 'package:myappv2/screen/class_screen/menu_create.dart';
// import 'package:myappv2/screen/class_screen/subjectpage.dart';
// // import 'package:myappv2/screen/welcome.dart';

// import 'package:myappv2/screen/welcomev2.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // select2
// import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
// // import 'package:response/response.dart';

// import 'homepage.dart';

// class Animal {
//   final int stID;

//   Animal({required this.stID});
// }

// class AddStudent extends StatefulWidget {
//   final String idclass;
//   const AddStudent(this.idclass, {super.key});

//   // AddStudent(this.idclass);

//   @override
//   State<AddStudent> createState() => _AddStudentState();
// }

// class _AddStudentState extends State<AddStudent> {
//   // final auth = FirebaseAuth.instance;
//   GlobalKey<FormState> _formState = GlobalKey<FormState>();

//   Future<Album>? _futureAlbum;

//   late Future<List<Article>> articles;
//   int? id = 1;
//   @override
//   void initState() {
//     print("initState");
//     super.initState();
//     articles = fetchArticle();
//     getCred();
//   }

//   final BsSelectBoxController _stID = BsSelectBoxController(multiple: true);

//   static const routeName = '/';
// // กำนหดตัวแปรข้อมูล articles

//   Future<BsSelectBoxResponse> selectApi(Map<String, dynamic> params) async {
//     final response =
//         await http.get(Uri.parse('https://fasl.chabafarm.com/api/student'));

//     if (response.statusCode == 200) {
//       List json = convert.jsonDecode(response.body);
//       return BsSelectBoxResponse.createFromJson(json,
//           value: (data) => data['id'],
//           renderText: (data) =>
//               Text(data['title'] + data['fname'] + '  ' + data['lname']));
//     }

//     return BsSelectBoxResponse(options: []);
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
//         // ignore: prefer_interpolation_to_compose_strings
//         title: Text('ชั้นเรียน' + widget.idclass),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   // return CreateClass();
//                   return MenuCreate();
//                 }));
//               },
//               icon: Icon(Icons.add))
//         ],
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
//                               'นักเรียนทั้งหมด', style: TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Form(
//                         key: _formState,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Row(
//                             children: [
//                               BsButton(
//                                 label: Text('นักเรียน'),
//                                 prefixIcon: Icons.add,
//                                 style: BsButtonStyle.primary,
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => BsModal(
//                                       context: context,
//                                       dialog: BsModalDialog(
//                                         child: BsModalContent(
//                                           children: [
//                                             BsModalContainer(
//                                                 title: Text('เลือกนักเรียน'),
//                                                 closeButton: true),
//                                             BsModalContainer(
//                                               child: Column(
//                                                 children: [
//                                                   BsCol(
//                                                     sizes: ColScreen(
//                                                         sm: Col.col_2),
//                                                     child: BsSelectBox(
//                                                       hintText: 'เลือกนักเรียน',
//                                                       searchable: true,
//                                                       controller: _stID,
//                                                       autoClose: false,
//                                                       alwaysUpdate: false,
//                                                       serverSide: selectApi,
//                                                     ),
//                                                   ),
//                                                   ElevatedButton(
//                                                     onPressed: () {
//                                                       setState(
//                                                         () {
//                                                           _futureAlbum =
//                                                               createAlbum(
//                                                             _stID.toString(),
//                                                             widget.idclass,
//                                                           );
//                                                         },
//                                                       );
//                                                       // Navigator.push(
//                                                       //     context,
//                                                       //     MaterialPageRoute(
//                                                       //       builder: (context) =>
//                                                       //           ClassHomePageScreen(),
//                                                       //     )
//                                                       //     );
//                                                     },
//                                                     child: const Text('บันทึก'),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),

//                           // Container(
//                           //   margin: EdgeInsets.only(bottom: 10.0),
//                           //   child: BsSelectBox(
//                           //     padding:
//                           //         EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
//                           //     hintTextLabel: 'เลือกนักเรียน',
//                           //     controller: _select3,
//                           //     serverSide: selectApi,
//                           //     searchable: true,
//                           //     dialogStyle: BsDialogBoxStyle(
//                           //       borderRadius: BorderRadius.circular(20.0),
//                           //     ),
//                           //     paddingDialog: EdgeInsets.all(15),
//                           //     marginDialog:
//                           //         EdgeInsets.only(top: 5.0, bottom: 5.0),
//                           //   ),
//                           // ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Expanded(
//                   //   // ส่วนของลิสรายการ
//                   //   child: snapshot.data!.length > 0 // กำหนดเงื่อนไขตรงนี้
//                   //       ? ListView.separated(
//                   //           // กรณีมีรายการ แสดงปกติ

//                   //           padding: const EdgeInsets.all(10),
//                   //           itemCount: snapshot.data!.length,
//                   //           itemBuilder: (context, index) {
//                   //             return InkWell(
//                   //               onTap: () {
//                   //                 Navigator.push(context,
//                   //                     MaterialPageRoute(builder: (context) {
//                   //                   return AddStudent();
//                   //                 }));
//                   //               },
//                   //               child: Container(
//                   //                 height: 70,
//                   //                 color: Color.fromARGB(255, 231, 207, 231),
//                   //                 child: ListTile(
//                   //                   title: Text('ชื่อวิชา ' +
//                   //                       snapshot.data![index].class_name +
//                   //                       '   ห้อง ' +
//                   //                       snapshot.data![index].class_room),
//                   //                   subtitle: Text('ปีการศึกษา ' +
//                   //                       snapshot.data![index].year),
//                   //                 ),
//                   //               ),
//                   //             );
//                   //           },
//                   //           separatorBuilder:
//                   //               (BuildContext context, int index) =>
//                   //                   const Divider(),
//                   //         )
//                   //       : const Center(
//                   //           child: Text('No items')), // กรณีไม่มีรายการ
//                   // ),
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
//               title: const Text('Dashboard'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return WelcomScreen();
//                 }));
//               },
//             ),
//             ListTile(
//               title: const Text('ชั้นเรียน'),
//               onTap: () {
//                 // Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 //   return AddStudent();
//                 // }));
//               },
//             ),
//             ListTile(
//               title: const Text('รายงานผลการเรียน'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('รายงานผลการเข้ากิจกรรม'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('รายงานการส่งงาน'),
//               onTap: () {
//                 Navigator.pop(context);
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

//   FutureBuilder<Album> buildFutureBuilder() {
//     return FutureBuilder<Album>(
//       future: _futureAlbum,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           // return Text(snapshot.data!.class_name!);

//         } else if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         }

//         return const CircularProgressIndicator();
//       },
//     );
//   }
// }

// Future<Album> createAlbum(String stID, String idcl) async {
//   var responsec = await http.post(
//     Uri.parse('https://fasl.chabafarm.com/api/teacher/add_student/store/$idcl'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'stID': stID,
//     }),
//   );

//   if (responsec.statusCode == 200) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     print('$stID');
//     return Album.fromJson(jsonDecode(responsec.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     print('$stID');
//     throw Exception('Failed to create album.');
//   }
// }

// class Album {
//   final String? stID;

//   const Album({
//     required this.stID,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       stID: json['stID'],
//     );
//   }
// }
// // ---------------------------------

// // สรัางฟังก์ชั่นดึงข้อมูล คืนค่ากลับมาเป็นข้อมูล Future ประเภท List ของ Article
// Future<List<Article>> fetchArticle() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   int id = pref.getInt("id")!;
//   // ทำการดึงข้อมูลจาก server ตาม url ที่กำหนด
//   final response = await http.get(Uri.parse(
//       'https://fasl.chabafarm.com/api/teacher/class_room/cr_data/$id'));

//   // เมื่อมีข้อมูลกลับมา
//   if (response.statusCode == 200) {
//     // ส่งข้อมูลที่เป็น JSON String data ไปทำการแปลง เป็นข้อมูล List<Article
//     // โดยใช้คำสั่ง compute ทำงานเบื้องหลัง เรียกใช้ฟังก์ชั่นชื่อ parseArticles
//     // ส่งข้อมูล JSON String data ผ่านตัวแปร response.body
//     print(response.body);
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
//   final String id;
//   late final String class_name;
//   late final String class_room;
//   late final String year;
//   // final String body;

//   Article({
//     // required this.userId,
//     required this.id,
//     required this.class_name,
//     required this.class_room,
//     required this.year,
//     // required this.body,
//   });

//   // ส่วนของ name constructor ที่จะแปลง json string มาเป็น Article object
//   factory Article.fromJson(Map<String, dynamic> json) {
//     return Article(
//       // userId: json['userId'],
//       id: json['id'],
//       class_name: json['class_name'],
//       class_room: json['class_room'],
//       year: json['year'],
//       // body: json['body'],
//     );
//   }
// }

// // -----------------------------


