import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myappv2/screen/class_screen/activity_room.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/grade_page.dart';
import 'package:myappv2/screen/class_screen/subject_activity.dart';
import 'package:myappv2/screen/class_screen/subjectpage.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';

Future<Album> createAlbum(
    String act_name, String act_detail, String crID) async {
  int? id = 0;
  SharedPreferences pref = await SharedPreferences.getInstance();
  id = pref.getInt("id")!;
  var response = await http.post(
    Uri.parse(
        'https://fasl.chabafarm.com/api/teacher/add_student/store/activity/subject'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'act_name': act_name,
      'act_detail': act_detail,
      'crID': crID,
      'teID': '1',
      'type': 'work',
      'status': '1',
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final String? act_name;
  final String? act_detail;
  final String? crID;
  final String? teID;
  final String? type;
  final String? status;

  const Album({
    required this.act_name,
    required this.act_detail,
    required this.crID,
    required this.teID,
    required this.type,
    required this.status,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      act_name: json['act_name'],
      act_detail: json['act_detail'],
      crID: json['crID'],
      teID: json['teID'],
      type: json['type'],
      status: json['status'],
    );
  }
}

// void main() {
//   runApp(const CreateSubjectActivity());
// }

enum SingingCharacter { lafayette, jefferson }

class CreateSubjectActivity extends StatefulWidget {
  final String? idclass;
  const CreateSubjectActivity(this.idclass, {super.key});

  @override
  State<CreateSubjectActivity> createState() {
    return _CreateSubjectActivityState();
  }
}

class _CreateSubjectActivityState extends State<CreateSubjectActivity> {
  // final auth = FirebaseAuth.instance;

  final TextEditingController _act_name = TextEditingController();
  final TextEditingController _act_detail = TextEditingController();
  // final TextEditingController _year = TextEditingController();
  // final TextEditingController _class_teacher = TextEditingController();
  // final TextEditingController _teID = TextEditingController();
  // final TextEditingController _type = TextEditingController();
  // SingingCharacter? _character = SingingCharacter.lafayette;
  Future<Album>? _futureAlbum;
  int? id;
  String? fname;
  String? lname;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          title: const Text(
            'สร้างงาน',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('$fname $lname'),
                // accountEmail: Text(auth.currentUser!.email.toString()),
                accountEmail: Text("sss"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                  backgroundColor: Colors.white,
                ),
              ),
              ListTile(
                title: const Text('หน้าแรก'),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ActivityRoom();
                  }));
                },
              ),
              ListTile(
                title: const Text('รายงานการส่งงาน'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WorkRoom();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        TextField(
          controller: _act_name,
          decoration: const InputDecoration(hintText: 'ชื่องาน'),
        ),
        TextField(
          controller: _act_detail,
          // minLines: 4,
          // keyboardType: TextInputType.multiline,
          // maxLines: null,
          decoration: const InputDecoration(hintText: 'รายละเอียด'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                _futureAlbum = createAlbum(_act_name.text, _act_detail.text,
                    widget.idclass.toString());
              },
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectActivity(widget.idclass),
                ));
          },
          child: const Text('บันทึก'),
        ),
      ],
    );
  }

  FutureBuilder<Album> buildFutureBuilder() {
    return FutureBuilder<Album>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // return Text(snapshot.data!.class_name!);

        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
