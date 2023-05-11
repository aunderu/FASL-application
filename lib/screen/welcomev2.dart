// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ffi';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/grade_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myappv2/loginv2.dart';

import 'class_screen/homepage.dart';

class WelcomScreen extends StatefulWidget {
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  // late Future<int> id;
  int id = 0;
  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // final int id = pref.getInt('id')!;
    final int id = pref.getInt("id")!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("หน้าแรก")),
      body: const Center(
        child: Text('My Page!'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Rusdee Lanong'),
              accountEmail: Text("${id}"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                backgroundColor: Colors.white,
              ),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('ชั้นเรียน'),
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('รายงานการส่งงาน'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
