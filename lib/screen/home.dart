import 'package:flutter/material.dart';

import '../loginv2.dart';
import '../registerv2.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register/Login")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset("assets/images/logohome.png"),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text(
                  "สร้างบัญชีผู้ใช้",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    // return RegisterScreen();
                    return const RegisterPage();
                  }));
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    // return LoginScreen();
                    return const LoginPage();
                  }));
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
