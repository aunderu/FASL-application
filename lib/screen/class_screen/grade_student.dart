import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:myappv2/screen/class_screen/GradeStudent.dart';
import 'package:myappv2/screen/class_screen/addstudentv2.dart';
import 'package:myappv2/screen/class_screen/class_activity.dart';
import 'package:myappv2/screen/class_screen/classpage.dart';
import 'package:myappv2/screen/class_screen/grade_camera.dart';
import 'package:myappv2/screen/class_screen/menu_create.dart';
import 'package:myappv2/screen/class_screen/subjectpage.dart';
import 'package:myappv2/screen/class_screen/work_room.dart';
// import 'package:myappv2/screen/welcome.dart';
import 'package:myappv2/screen/welcomev2.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:myappv2/screen/class_screen/addstudentv2.dart';

import 'homepage.dart';

// class DogService {
//   static randomDog() {
//     var url = "https://dog.ceo/api/breeds/image/random";
//     http.get(Uri.parse(url)).then((response) {
//       print("Response status: ${response.body}");
//     });
//   }
// }

class MessageDogsDao {
  String? status;
  String? message;

  MessageDogsDao({this.status, this.message});

  MessageDogsDao.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

// Future<dynamic> fetchAlbum() async {
//   final response =
//       await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception('Failed to load album');
//   }
// }

class DogService {
  static Future<MessageDogsDao> randomDog(String? idtl) async {
    var url = "https://fasl.chabafarm.com/api/teacher/grade/imashow/$idtl";
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> map = json.decode(response.body);
    MessageDogsDao msg = MessageDogsDao.fromJson(map);
    // ignore: prefer_interpolation_to_compose_strings, avoid_print
    print("URL image = " + msg.message.toString());

    return msg;
  }
}

// class DogService {
//   static randomDog() {
//     var url = "https://dog.ceo/api/breeds/image/random";
//     http.get(Uri.parse(url)).then((response) {
//       print("Response status: ${response.body}");
//     });
//   }
// }

class GradeStudent extends StatefulWidget {
  final String? idst;
  final String? idcl;
  const GradeStudent(this.idst, this.idcl, {super.key});

  @override
  State<GradeStudent> createState() => _GradeStudentState();
}

class _GradeStudentState extends State<GradeStudent> {
  late Future<dynamic> futureAlbum;
  int? id;
  String? fname;
  String? lname;

  // ignore: annotate_overrides
  void initState() {
    DogService.randomDog(widget.idst.toString());
    super.initState();
    // fetchJSON();
    // futureAlbum = fetchAlbum();
    getCred();
  }

  // ignore: unused_element
  void _refreshData() {
    setState(() {
      print("setState");
      DogService.randomDog(widget.idst.toString());
      // fetchJSON();
    });
  }

  @override
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

  File? pickedImage;
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "เลือกรูปภาพ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("กล้อง"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("แกลลอรี่"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("ยกเลิก"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    String? idc = widget.idst;
    try {
      final photo = await ImagePicker().pickImage(source: imageType);

      if (photo == null) return;

      final tempImage = File(photo.path);

      // delrecord(tempImage);
      print(tempImage);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://fasl.chabafarm.com/api/teacher/grade/update/$idc'));
      request.files.add(http.MultipartFile.fromBytes(
          'grade', File(photo.path).readAsBytesSync(),
          filename: photo.path));
      var res = await request.send();
      _refreshData();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build"); // สำหรับทดสอบ
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: const Text(
            'อัพโหลดผลการเรียน',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  onPressed: imagePickerOption,
                  icon: const Icon(Icons.add_a_photo_sharp),
                  label: const Text('อัพโหลดเกรด')),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Column(
                        children: <Widget>[
                          FutureBuilder(
                              future: DogService.randomDog(widget.idst),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  MessageDogsDao msg = snapshot.data!;
                                  // print("snap = " + msg.message.toString());
                                  if (msg.message.toString() != 'null') {
                                    return Image.network(
                                      'https://fasl.chabafarm.com/storage/file/' +
                                          msg.message.toString(),
                                      width: 500,
                                      height: 500,
                                    );
                                  } else {
                                    return Text("ไม่มีการอัพโหลด");
                                  }
                                } else {
                                  // ignore: prefer_const_constructors
                                  return CircularProgressIndicator();
                                }
                              })
                        ],
                        // children: [
                        //   Container(
                        //     decoration: BoxDecoration(
                        //       border:
                        //           Border.all(color: Colors.indigo, width: 1),
                        //       borderRadius: const BorderRadius.all(
                        //         Radius.circular(2),
                        //       ),
                        //     ),
                        //     child: pickedImage != null
                        //         ? Image.file(
                        //             pickedImage!,
                        //             width: 170,
                        //             height: 170,
                        //             // fit: BoxFit.cover,
                        //           )
                        //         : Image.network(
                        //             'https://sites.google.com/site/makur014218/_/rsrc/1516679793330/phl-kar-reiyn/narumon.longwong12.jpg',
                        //             width: 350,
                        //             height: 500,
                        //             // fit: BoxFit.cover,
                        //           ),
                        //   ),
                        // ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
