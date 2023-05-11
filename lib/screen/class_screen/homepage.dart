// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:myapp/screen/welcome.dart';

// class ClassHomePageScreen1 extends StatelessWidget {
//   final auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("ชั้นเรียน")),
//       body: const Center(
//         child: Text('My Page!'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text('Rusdee Lanong'),
//               accountEmail: Text(auth.currentUser!.email.toString()),
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
//                 //   return ClassHomePageScreen();
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
