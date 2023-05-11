import 'package:flutter/material.dart';
import 'package:myappv2/loginv2.dart';
import 'package:myappv2/registerv2.dart';
// import 'package:myapp/screen/login.dart';
// import 'package:myapp/screen/register.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register/Login")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset("assets/images/logohome.png"),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text(
                  "สร้างบัญชีผู้ใช้",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    // return RegisterScreen();
                    return RegisterV2();
                  }));
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.login),
                label: Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    // return LoginScreen();
                    return LoginV2();
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
