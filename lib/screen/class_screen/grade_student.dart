import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class DogService {
//   static randomDog() {
//     var url = "https://dog.ceo/api/breeds/image/random";
//     http.get(Uri.parse(url)).then((response) {
//       print("Response status: ${response.body}");
//     });
//   }
// }

class MessageDogsDao {
  MessageDogsDao({this.status, this.message});

  MessageDogsDao.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  String? message;
  String? status;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
  const GradeStudent(this.idst, this.idcl, {super.key});

  final String? idcl;
  final String? idst;

  @override
  State<GradeStudent> createState() => _GradeStudentState();
}

class _GradeStudentState extends State<GradeStudent> {
  String? fname;
  late Future<dynamic> futureAlbum;
  int? id;
  String? lname;
  File? pickedImage;

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

  // ignore: annotate_overrides
  void initState() {
    DogService.randomDog(widget.idst.toString());
    super.initState();
    // fetchJSON();
    // futureAlbum = fetchAlbum();
    getCred();
  }

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

  // ignore: unused_element
  void _refreshData() {
    setState(() {
      DogService.randomDog(widget.idst.toString());
      // fetchJSON();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                                      'https://fasl.chabafarm.com/storage/file/${msg.message}',
                                      width: 500,
                                      height: 500,
                                    );
                                  } else {
                                    return const Text("ไม่มีการอัพโหลด");
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
