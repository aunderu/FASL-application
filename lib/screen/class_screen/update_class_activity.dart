import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/class_drawer.dart';
import 'class_activity.dart';

Future<Album> createAlbum(
    String actName, String actDetail, String crID) async {
  // int? id = 0;
  // SharedPreferences pref = await SharedPreferences.getInstance();
  // id = pref.getInt("id")!;
  var response = await http.post(
    Uri.parse('https://fasl.chabafarm.com/api/teacher/activity/update/$crID'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'act_name': actName,
      'act_detail': actDetail,
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
  final String? actName;
  final String? actDetail;
  final String? crID;
  final String? teID;
  final String? type;
  final String? status;

  const Album({
    required this.actName,
    required this.actDetail,
    required this.crID,
    required this.teID,
    required this.type,
    required this.status,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      actName: json['act_name'],
      actDetail: json['act_detail'],
      crID: json['crID'],
      teID: json['teID'],
      type: json['type'],
      status: json['status'],
    );
  }
}

// void main() {
//   runApp(const UpdateClassActivityScreen());
// }

enum SingingCharacter { lafayette, jefferson }

class UpdateClassActivityScreen extends StatefulWidget {
  final String? idclass;
  final String? editactivity;
  final String? editdetail;
  final String? editid;

  const UpdateClassActivityScreen(
      this.idclass, this.editactivity, this.editdetail, this.editid,
      {super.key});

  @override
  State<UpdateClassActivityScreen> createState() {
    return _UpdateClassActivityScreenState();
  }
}

class _UpdateClassActivityScreenState extends State<UpdateClassActivityScreen> {
  // final auth = FirebaseAuth.instance;

  final TextEditingController _actName = TextEditingController();
  final TextEditingController _actDetail = TextEditingController();
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

    // print(fname);
    // lname = pref2.getString("lname")!;
    // user_type = pref3.getString("user_type")!;
    // email = pref4.getString("email")!;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _actName.text = widget.editactivity.toString();
      _actDetail.text = widget.editdetail.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'กิจกรรม',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Text(
            'แก้ไขกิจกรรม',
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
          controller: _actName,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'ชื่อกิจกรรม:',
          ),
        ),
        TextField(
          controller: _actDetail,
          // minLines: 4,
          // keyboardType: TextInputType.multiline,
          // maxLines: null,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'รายละเอียด:',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(
              () {
                _futureAlbum = createAlbum(
                    _actName.text, _actDetail.text, widget.editid.toString());
              },
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassActivity(widget.idclass),
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
