import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myappv2/loginv2.dart';
// import 'package:myappv2/screen/class_screen/create_class.dart';
// import 'package:myappv2/screen/class_screen/create_subjext.dart';
// import 'package:myappv2/screen/class_screen/homepagev1.dart';
// import 'package:myappv2/screen/welcome.dart';

const List<String> list1 = <String>['นาย', 'นาง', 'นางสาว'];
const List<String> list2 = <String>['ครู', 'นักเรียน', 'ผู้ปกครอง'];

Future<Album> createAlbum(String title, String fname, String lname,
    String email, String user_type, String password) async {
  var response = await http.post(
    Uri.parse('https://fasl.chabafarm.com/api/register/store'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'fname': fname,
      'lname': lname,
      'email': email,
      'user_type': user_type,
      'password': password,
    }),
  );

  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    // var data = jsonDecode(response.body.toString());
    // print(data);
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final String? title;
  final String? fname;
  final String? lname;
  final String? email;
  final String? user_type;
  final String? password;

  const Album(
      {required this.title,
      required this.fname,
      required this.lname,
      required this.email,
      required this.user_type,
      required this.password});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      user_type: json['user_type'],
      password: json['password'],
    );
  }
}

void main() {
  runApp(const RegisterV2());
}

enum SingingCharacter { lafayette, jefferson }

class RegisterV2 extends StatefulWidget {
  const RegisterV2({super.key});

  @override
  State<RegisterV2> createState() {
    return _RegisterV2State();
  }
}

class _RegisterV2State extends State<RegisterV2> {
  String _title = list1.first;
  String _user_type = list2.first;
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  Future<Album>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('สมัครสมาชิก'),
        // ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20.0),
          child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("ลงทะเบียน",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          value: _title,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              _title = value!;
            });
          },
          items: list1.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextField(
          controller: _fname,
          decoration: const InputDecoration(hintText: 'ชื่อ'),
        ),
        TextField(
          controller: _lname,
          decoration: const InputDecoration(hintText: 'นามสกุล'),
        ),
        DropdownButtonFormField<String>(
          value: _user_type,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              _user_type = value!;
            });
          },
          items: list2.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextField(
          controller: _email,
          decoration: const InputDecoration(hintText: 'Email'),
        ),
        TextField(
          controller: _password,
          decoration: const InputDecoration(hintText: 'password'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: ElevatedButton(
            onPressed: () {
              setState(
                () {
                  _futureAlbum = createAlbum(_title, _fname.text, _lname.text,
                      _email.text, _user_type, _password.text);
                },
              );

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginV2(),
                  ));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 170, 147, 214),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text('ลงทะเบียน',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            // child: const Text('ลงทะเบียน'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              // return RegisterScreen();
              return LoginV2();
            }));
          },
          child: Text("เข้าสู่ระบบ"),
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
