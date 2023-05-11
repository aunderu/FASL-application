// // import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:ffi';

// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart';
// import 'package:myappv2/screen/class_screen/homepagev1.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:myappv2/loginv2.dart';

// import 'class_screen/homepage.dart';

// class WelcomScreen extends StatelessWidget {
//   // final auth = FirebaseAuth.instance;
//   String id = "";
//   String fname = "";
//   String lname = "";
//   String user_type = "";
//   String email = "";

//   @override
//   void initState() {
//     super.initState();
//     getCred();
//   }

//   void getCred() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     id = pref.getString("id")!;
//     fname = pref.getString("fname")!;
//     lname = pref.getString("lname")!;
//     user_type = pref.getString("user_type")!;
//     email = pref.getString("email")!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("หน้าแรก")),
//       body: const Center(
//         child: Text('My Page!'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text('Rusdee Lanong'),
//               accountEmail: Text("dddddd"),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
//                 backgroundColor: Colors.white,
//               ),
//             ),
//             ListTile(
//               title: const Text('Dashboard'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('ชั้นเรียน'),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return ClassHomePageScreen();
//                 }));
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
