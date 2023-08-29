import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/home.dart';
import '../screen/students_screen/student_activity.dart';
import '../screen/students_screen/student_grade.dart';
import '../screen/students_screen/student_home.dart';
import '../screen/students_screen/student_work.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({
    super.key,
    required this.fname,
    required this.lname,
  });

  final String? fname;
  final String? lname;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('$fname $lname'),
            accountEmail: const Text("นักเรียน"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: const Text('หน้าแรก'),
            onTap: () {
              Get.to((context) => const StudentHomeScreen());
            },
          ),
          ListTile(
            title: const Text('รายงานผลการเรียน'),
            onTap: () {
              Get.to((context) => const StudentGradeScreen());
            },
          ),
          ListTile(
            title: const Text('กิจกรรม'),
            onTap: () {
              Get.to((context) => const StudentActivityScreen());
            },
          ),
          ListTile(
            title: const Text('การส่งงาน'),
            onTap: () {

              Get.to((context) => const StudentWorkScreen());
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.logout),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('ออกจากระบบ'),
                ),
              ],
            ),
            onTap: () async {
              final SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();

              sharedPreferences.clear();

              Get.to((context) => HomeScreen());
            },
          ),
        ],
      ),
    );
  }
}
