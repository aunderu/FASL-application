import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loginv2.dart';
import '../screen/parens_screen/paren_activity.dart';
import '../screen/parens_screen/paren_grade.dart';
import '../screen/parens_screen/paren_home.dart';
import '../screen/parens_screen/paren_workv2.dart';

class ParentDrawer extends StatelessWidget {
  const ParentDrawer({
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
            accountEmail: const Text("ผู้ปกครอง"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            title: const Text('หน้าแรก'),
            onTap: () {
              Get.to((context) => const ParenHomeScreen());
            },
          ),
          ListTile(
            title: const Text('รายงานผลการเรียน'),
            onTap: () {
              Get.to((context) => const ParenGradeScreen());
            },
          ),
          ListTile(
            title: const Text('รายงานผลการเข้ากิจกรรม'),
            onTap: () {
              Get.to((context) => const ParenActivityScreen());
            },
          ),
          ListTile(
            title: const Text('รายงานการส่งงาน'),
            onTap: () {
              Get.to((context) => const ParenWorkv2Screen());
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

              Get.offAll(() => const LoginPage());
            },
          ),
        ],
      ),
    );
  }
}
