import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:myappv2/registerv2.dart';
// import 'package:myappv2/screen/class_screen/classpage.dart';
// import 'package:myappv2/screen/parens_screen/paren_home.dart';
// import 'package:myappv2/screen/students_screen/student_home.dart';
// import 'package:myappv2/screen/welcome.dart';
// import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'registerv2.dart';
import 'screen/class_screen/classpage.dart';
import 'screen/parens_screen/paren_home.dart';
import 'screen/students_screen/student_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var isPassNotVisible = true;
  final _formKey = GlobalKey<FormState>();

  Future<bool> loginEmail(String email, String password) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      var response = await http.post(
        Uri.parse('https://fasl.chabafarm.com/api/login'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        SharedPreferences prefId = await SharedPreferences.getInstance();
        SharedPreferences prefFname = await SharedPreferences.getInstance();
        SharedPreferences prefLname = await SharedPreferences.getInstance();
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
        await prefId.setInt("id", data['id']);
        await prefFname.setString("fname", data['fname']);
        await prefLname.setString("lname", data['lname']);
        // await pref3.setString("user_type", data['type']);
        // await pref4.setString("email", data['email']);

        if (data['type']! == 'te') {
          Get.off(() => const ClassHomePageScreen());
        } else if (data['type']! == 'st') {
          Get.off(() => const StudentHomeScreen());
        } else {
          Get.off(() => const ParenHomeScreen());
        }
        // }

        // Get.back();

        return true;
      } else {
        Get.back();

        Get.snackbar(
          'โอ้ะ..',
          'อีเมลหรือรหัสผ่านไม่ถูกต้อง',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.back();

      Get.snackbar(
        'โอ้ะ.. ดูเหมือนว่าจะเกิดปัญหา.',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Sign Up Api'),
        // ),
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/logo_msa_no_bg.png'),
                    const SizedBox(height: 50),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[500],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'youremail@mail.com',
                        labelText: 'Email',
                        icon: Icon(Icons.email_rounded),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty || !value.contains("@")
                              ? "กรุณากรอกอีเมล"
                              : null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: const Icon(Icons.password_rounded),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: IconButton(
                            icon: isPassNotVisible
                                ? Icon(Icons.visibility_off_outlined,
                                    color: Colors.grey[500])
                                : const Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isPassNotVisible = !isPassNotVisible;
                              });
                            },
                          ),
                        ),
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
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          loginEmail(
                            emailController.text,
                            passwordController.text,
                          );

                          // loginEmail(emailController.text, passwordController.text);
                        }
                      },
                      child: Ink(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 170, 147, 214),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text('เข้าสู่ระบบ',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(
                          () => const RegisterPage(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: const Text("สมัครสมาชิก"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
