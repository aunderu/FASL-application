import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/class_drawer.dart';
import 'subjectpage.dart';

Future<Album> createAlbum(String name, String room, String year) async {
  int? id = 0;
  SharedPreferences pref = await SharedPreferences.getInstance();
  id = pref.getInt("id")!;
  var response = await http.post(
    Uri.parse('https://fasl.chabafarm.com/api/teacher/class_room/store'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'class_name': name,
      'class_room': room,
      'year': year,
      'class_teacher': "no",
      'teID': "$id",
      'type': "2",
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
  final String? className;
  final String? classRoom;
  final String? year;
  final String? classTeacher;
  final String? teID;
  final String? type;

  const Album(
      {required this.className,
      required this.classRoom,
      required this.year,
      required this.classTeacher,
      required this.teID,
      required this.type});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      className: json['class_name'],
      classRoom: json['class_room'],
      year: json['year'],
      classTeacher: json['class_teacher'],
      teID: json['teID'],
      type: json['type'],
    );
  }
}

void main() {
  runApp(const CreateSubject());
}

enum SingingCharacter { lafayette, jefferson }

class CreateSubject extends StatefulWidget {
  const CreateSubject({super.key});

  @override
  State<CreateSubject> createState() {
    return _CreateSubjectState();
  }
}

class _CreateSubjectState extends State<CreateSubject> {
  // final auth = FirebaseAuth.instance;

  final TextEditingController _className = TextEditingController();
  final TextEditingController _classRoom = TextEditingController();
  final TextEditingController _year = TextEditingController();
  final TextEditingController _classTeacher = TextEditingController();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text(
            'สร้างวิชา',
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
        drawer:  ClassDrawer(fname: fname, lname: lname),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        TextField(
          controller: _className,
          decoration: const InputDecoration(hintText: 'ชื่อห้อง'),
        ),
        TextField(
          controller: _classRoom,
          decoration: const InputDecoration(hintText: 'ห้อง'),
        ),
        TextField(
          controller: _year,
          decoration: const InputDecoration(hintText: 'ปีการศึกษา'),
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
                _futureAlbum =
                    createAlbum(_className.text, _classRoom.text, _year.text);
              },
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubjectHomePageScreen(),
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
