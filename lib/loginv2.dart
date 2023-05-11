// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myappv2/registerv2.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/parens_screen/paren_home.dart';
import 'package:myappv2/screen/students_screen/student_home.dart';
import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginV2 extends StatefulWidget {
  const LoginV2({Key? key}) : super(key: key);

  @override
  _LoginV2State createState() => _LoginV2State();
}

class _LoginV2State extends State<LoginV2> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, password) async {
    try {
      Response response = await post(
          Uri.parse('https://fasl.chabafarm.com/api/login'),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        SharedPreferences pref = await SharedPreferences.getInstance();
        SharedPreferences pref1 = await SharedPreferences.getInstance();
        SharedPreferences pref2 = await SharedPreferences.getInstance();
        // SharedPreferences pref3 = await SharedPreferences.getInstance();
        // SharedPreferences pref4 = await SharedPreferences.getInstance();
        // pageRoute(data['id']!);
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return WelcomScreen();
        // }));
        // ignore: avoid_print
        // print(data['fname']);
        // data['']
        // print(data);
        // if (data != null) {
        await pref.setInt("id", data['id']);
        await pref1.setString("fname", data['fname']);
        await pref2.setString("lname", data['lname']);
        // await pref3.setString("user_type", data['type']);
        // await pref4.setString("email", data['email']);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          if (data['type']! == 'te') {
            return ClassHomePageScreen();
          } else if (data['type']! == 'st') {
            return StudentHomeScreen();
          } else {
            return ParenHomeScreen();
          }
        }));
        // }

        print('Login successfully');
      } else {
        print('failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // void pageRoute(String id) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  // SharedPreferences pref1 = await SharedPreferences.getInstance();
  // SharedPreferences pref2 = await SharedPreferences.getInstance();
  // SharedPreferences pref3 = await SharedPreferences.getInstance();
  // SharedPreferences pref4 = await SharedPreferences.getInstance();

  // await pref.setString("id", id);

  // Navigator.push(context, MaterialPageRoute(builder: (context) {
  //   return WelcomScreen();
  // }));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sign Up Api'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "เข้าสู่ระบบ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                login(emailController.text.toString(),
                    passwordController.text.toString());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 170, 147, 214),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text('เข้าสู่ระบบ',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  // return RegisterScreen();
                  return RegisterV2();
                }));
              },
              child: Text("สมัครสมาชิก"),
            ),
          ],
        ),
      ),
    );
  }
}
