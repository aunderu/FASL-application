import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/class_screen/activity_room.dart';
import '../screen/class_screen/classpage.dart';
import '../screen/class_screen/grade_page.dart';
import '../screen/class_screen/work_room.dart';

class ClassDrawer extends StatelessWidget {
  const ClassDrawer({
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
            accountEmail: const Text("ครู"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: const Text('หน้าแรก'),
            onTap: () {
              Get.to((context) => const ClassHomePageScreen());
            },
          ),
          ListTile(
            title: const Text('รายงานผลการเรียน'),
            onTap: () {
              Get.to((context) => const GradeScreen());
            },
          ),
          ListTile(
            title: const Text('รายงานผลการเข้ากิจกรรม'),
            onTap: () {
              Get.to((context) => const ActivityRoom());
            },
          ),
          ListTile(
            title: const Text('รายงานการส่งงาน'),
            onTap: () {
              Get.to((context) => const WorkRoom());
            },
          ),
        ],
      ),
    );
  }
}
