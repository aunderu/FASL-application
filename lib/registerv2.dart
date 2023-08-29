import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'loginv2.dart';
// import 'package:myappv2/screen/class_screen/create_class.dart';
// import 'package:myappv2/screen/class_screen/create_subjext.dart';
// import 'package:myappv2/screen/class_screen/homepagev1.dart';
// import 'package:myappv2/screen/welcome.dart';

const List<String> list1 = <String>['นาย', 'นาง', 'นางสาว'];
const List<String> list2 = <String>['ครู', 'นักเรียน', 'ผู้ปกครอง'];

class Album {
  final String? title;
  final String? fname;
  final String? lname;
  final String? email;
  final String? userType;
  final String? password;

  const Album(
      {required this.title,
      required this.fname,
      required this.lname,
      required this.email,
      required this.userType,
      required this.password});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      userType: json['user_type'],
      password: json['password'],
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  String? _title;
  String? _userType;
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  var isPassNotVisible = true;
  final _formKey = GlobalKey<FormState>();

  Future<bool> createAlbum(
    String title,
    String fname,
    String lname,
    String email,
    String userType,
    String password,
  ) async {
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
        'user_type': userType,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // var data = jsonDecode(response.body.toString());
      // print(data);
      Get.back();
      Get.snackbar(
        'เยี่ยม!',
        'คุณสมัครเรียบร้อยแล้ว กรอกอีเมลและรหัสผ่านเพื่อเข้าสู่ระบบ',
        snackPosition: SnackPosition.BOTTOM,
      );
      // return Album.fromJson(jsonDecode(response.body));
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Get.back();
      Get.snackbar(
        'โอ๊ะ..',
        'ดูเหมือนไม่สามารถสมัครไอดีของคุณได้ กรุณาสมัครอีกครั้งในภายหลัง',
        snackPosition: SnackPosition.BOTTOM,
      );
      // throw Exception('Failed to create album.');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(key: _formKey, child: buildColumn()),
              // (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
            ),
          ),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "ลงทะเบียน",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[500],
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: _userType,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          hint: const Text('คุณตำแหน่งไหนในระบบนี้?'),
          onChanged: (value) => setState(() => _userType = value!),
          validator: (value) => value == null ? 'กรุณาเลือกตำแหน่ง' : null,
          items: list2.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        DropdownButtonFormField<String>(
          value: _title,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          hint: const Text('คำนำหน้า'),
          onChanged: (value) => setState(() => _title = value!),
          validator: (value) => value == null ? 'กรุณาเลือกคำนำหน้า' : null,
          items: list1.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        TextFormField(
          controller: _fname,
          decoration: const InputDecoration(hintText: 'ชื่อ'),
          keyboardType: TextInputType.name,
          onSaved: (String? value) {},
          validator: (value) => value!.isEmpty ? "กรุณากรอกชื่อของคุณ" : null,
        ),
        TextFormField(
          controller: _lname,
          decoration: const InputDecoration(hintText: 'นามสกุล'),
          keyboardType: TextInputType.name,
          onSaved: (String? value) {},
          validator: (value) =>
              value!.isEmpty ? "กรุณากรอกนามสกุลของคุณ" : null,
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _email,
          decoration: const InputDecoration(hintText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          onSaved: (String? value) {},
          validator: (value) =>
              value!.isEmpty || !value.contains("@") ? "กรุณากรอกอีเมล" : null,
        ),
        TextFormField(
          controller: _password,
          decoration: const InputDecoration(
            hintText: 'Password',
          ),
          obscureText: isPassNotVisible,
          keyboardType: TextInputType.visiblePassword,
          onSaved: (String? value) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอกรหัสผ่านของคุณ';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _confirmPassword,
          decoration: const InputDecoration(
            hintText: 'Confirm Password',
          ),
          obscureText: isPassNotVisible,
          keyboardType: TextInputType.visiblePassword,
          onSaved: (String? value) {},
          validator: (val) {
            if (val!.isEmpty) return 'กรุณากรอกรหัสผ่านของคุณ';
            if (val != _password.text) return 'รหัสผ่านไม่ตรงกัน';
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 170, 147, 214),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
                createAlbum(
                  _title!,
                  _fname.text,
                  _lname.text,
                  _email.text,
                  _userType!,
                  _password.text,
                ).then((value) {
                  if (value == true) {
                    Get.off(() => const LoginPage());
                  }
                });
              }

              // Get.off(() => const LoginPage());
            },
            child: const Center(
              child: Text(
                'ลงทะเบียน',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            // child: const Text('ลงทะเบียน'),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("เข้าสู่ระบบ"),
        ),
      ],
    );
  }

  // FutureBuilder<Album> buildFutureBuilder() {
  //   return FutureBuilder<Album>(
  //     future: _futureAlbum,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         // return Text(snapshot.data!.class_name!);
  //       } else if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       }

  //       return const CircularProgressIndicator();
  //     },
  //   );
  // }
}
