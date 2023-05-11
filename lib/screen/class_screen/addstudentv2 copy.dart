// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
// import 'package:myappv2/screen/class_screen/addstudent.dart';
// import 'package:myappv2/screen/class_screen/menu_create.dart';
// import 'package:myappv2/screen/class_screen/subjectpage.dart';
// // import 'package:myappv2/screen/welcome.dart';
// import 'package:myappv2/screen/welcomev2.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'homepage.dart';

// class Object {
//   int? id;
//   String? fname;
//   String? lname;
//   String? email;

//   Object({this.id, this.fname, this.lname, this.email});

//   factory Object.fromJson(Map<String, dynamic> json) {
//     return Object(
//         id: json['id'],
//         fname: json['fname'],
//         lname: json['lname'],
//         email: json['email']);
//   }
// }

// class AddStudent extends StatefulWidget {
//   final String? idclass;
//   const AddStudent(this.idclass, {super.key});

//   @override
//   State<AddStudent> createState() => _AddStudentState();
// }

// class _AddStudentState extends State<AddStudent> {
//   void initState() {
//     print("initState");
//     super.initState();
//     fetchJSON();
//     getCred();
//   }

//   void _refreshData() {
//     setState(() {
//       print("setState");
//       fetchJSON();
//     });
//   }

//   int? id = 0;
//   @override
//   void getCred() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     id = pref.getInt("id")!;
//   }

//   Future<void> delrecord(String StId) async {
//     String? idc = widget.idclass;
//     try {
//       String uri =
//           "https://fasl.chabafarm.com/api/teacher/add_student/store/$idc";

//       var res = await http.post(Uri.parse(uri), body: {"stID": StId});
//       var response = jsonDecode(res.body);
//       if (response['status'] == "success") {
//         _refreshData();
//         print("yes");
//       } else {
//         print("not");
//       }
//     } catch (e) {
//       print("ddd");
//     }
//   }

//   Future<List<Object>> fetchJSON() async {
//     String? idca = widget.idclass;
//     var jsonResponse = await http.get(
//         Uri.parse('https://fasl.chabafarm.com/api/teacher/add_student/$idca'));

//     if (jsonResponse.statusCode == 200) {
//       final jsonItems =
//           json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

//       List<Object> tempList = jsonItems.map<Object>((json) {
//         return Object.fromJson(json);
//       }).toList();

//       return tempList;
//     } else {
//       throw Exception('Failed To Load Data...');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("build"); // สำหรับทดสอบ
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('เพิ่มนักเรียน'),
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
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: FutureBuilder<List<Object>>(
//           future: fetchJSON(),
//           builder: (context, data) {
//             if (data.hasError) {
//               return Center(child: Text("${data.error}"));
//             } else if (data.hasData) {
//               var items = data.data as List<Object>;
//               return Column(
//                 children: <Widget>[
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: OutlinedButton(
//                           onPressed: () {},
//                           child: Text('นักเรียน'),
//                           style: OutlinedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: Text('+ เพิ่มนักเรียน'),
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.circular(8), // <-- Radius
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: const ClampingScrollPhysics(),
//                         itemCount: items == null ? 0 : items.length,
//                         itemBuilder: (context, index) {
//                           return Column(
//                             children: [
//                               Card(
//                                 child: ListTile(
//                                   title: Text(
//                                     items[index].fname.toString() +
//                                         '  ' +
//                                         items[index].lname.toString(),
//                                   ),
//                                   // onTap: () {
//                                   //   getItemAndNavigate(items[index].name.toString(),
//                                   //       items[index].email.toString(), context);
//                                   // },
//                                   subtitle: Text(
//                                     items[index].email.toString(),
//                                   ),
//                                   trailing: IconButton(
//                                     icon: Icon(Icons.add),
//                                     onPressed: () {
//                                       delrecord(items[index].id.toString());
//                                     },
//                                   ),
//                                   leading: CircleAvatar(
//                                     backgroundColor:
//                                         Color.fromARGB(255, 242, 2, 250),
//                                     child:
//                                         Text(items[index].fname.toString()[0],
//                                             style: const TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 22.0,
//                                             )),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         }),
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
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
//     );
//   }
// }
