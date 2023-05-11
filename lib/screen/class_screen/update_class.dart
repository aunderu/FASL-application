import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myappv2/screen/class_screen/activity_room.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/grade_page.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_auth/firebase_auth.dart';

Future<Album> createAlbum(
  String name,
  String room,
  String year,
  String editid,
) async {
  int? id = 0;
  SharedPreferences pref = await SharedPreferences.getInstance();
  id = pref.getInt("id")!;
  print(id);
  var response = await http.post(
    Uri.parse(
        'https://fasl.chabafarm.com/api/teacher/class_room/update/$editid'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'class_name': name,
      'class_room': room,
      'year': year,
      'type': "1",
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
  final String? class_name;
  final String? class_room;
  final String? year;
  final String? type;

  const Album(
      {required this.class_name,
      required this.class_room,
      required this.year,
      required this.type});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      class_name: json['class_name'],
      class_room: json['class_room'],
      year: json['year'],
      type: json['type'],
    );
  }
}

// void main() {
//   runApp(const UpdateClassScreen());
// }

// enum SingingCharacter { lafayette, jefferson }

class UpdateClassScreen extends StatefulWidget {
  String? edt_id;
  String? edt_class_name;
  String? edt_class_room;
  String? edt_year;
  UpdateClassScreen(
      this.edt_class_name, this.edt_class_room, this.edt_year, this.edt_id,
      {super.key});

  @override
  State<UpdateClassScreen> createState() {
    return _UpdateClassScreenState();
  }
}

class _UpdateClassScreenState extends State<UpdateClassScreen> {
  // final auth = FirebaseAuth.instance;

  final TextEditingController _class_name = TextEditingController();
  final TextEditingController _class_room = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _class_teacher = TextEditingController();
  final TextEditingController _teID = TextEditingController();
  final TextEditingController _type = TextEditingController();
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
      super.initState();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _class_name.text = widget.edt_class_name.toString();
      _class_room.text = widget.edt_class_room.toString();
      _year.text = widget.edt_year.toString();
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
            'แก้ไขชั้นเรียน',
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
                accountEmail: Text("ครู"),
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
            controller: _class_name,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'ชื่อห้อง:',
            )),
        TextField(
          controller: _class_room,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'ห้อง:',
          ),
        ),
        TextField(
          controller: _year,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'ปีการศึกษา:',
          ),
        ),
        // TextField(
        //   controller: _class_teacher,
        //   decoration: const InputDecoration(hintText: 'ประเภทครู'),
        // ),
        // TextField(
        //   controller: _teID,
        //   decoration: const InputDecoration(hintText: 'รหัสครู'),
        // ),
        // TextField(
        //   controller: _type,
        //   decoration: const InputDecoration(hintText: 'ประเภท'),
        // ),
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                _futureAlbum = createAlbum(_class_name.text, _class_room.text,
                    _year.text, widget.edt_id.toString());
              },
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassHomePageScreen(),
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
