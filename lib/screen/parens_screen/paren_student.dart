import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/parent_drawer.dart';
import 'paren_add_student.dart';

// import 'homepage.dart';

class Object {
  int? id;
  String? fname;
  String? lname;
  String? email;

  Object({this.id, this.fname, this.lname, this.email});

  factory Object.fromJson(Map<String, dynamic> json) {
    return Object(
        id: json['id'],
        fname: json['fname'],
        lname: json['lname'],
        email: json['email']);
  }
}

class ParenStudentScreen extends StatefulWidget {
  const ParenStudentScreen({super.key});

  @override
  State<ParenStudentScreen> createState() => _ParenStudentScreenState();
}

class _ParenStudentScreenState extends State<ParenStudentScreen> {
  int? id;
  String? fname;
  String? lname;

  @override
  void initState() {
    super.initState();
    fetchJSON();
    getCred();
  }

  void _refreshData() {
    setState(() {
      fetchJSON();
    });
  }

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

  Future<void> delrecord(String stId) async {
    try {
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // id = pref.getInt("id")!;
      String uri = "https://fasl.chabafarm.com/api/parent/show/ParenDelStudent";

      var res = await http.post(Uri.parse(uri), body: {"stID": stId});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
        // print("yes");
      } else {
        // print("not");
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<List<Object>> fetchJSON() async {
    // String? idca = widget.idclass;
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getInt("id")!;
    var jsonResponse =
        await http.get(Uri.parse('https://fasl.chabafarm.com/api/parent/$id'));

    if (jsonResponse.statusCode == 200) {
      final jsonItems =
          json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

      List<Object> tempList = jsonItems.map<Object>((json) {
        return Object.fromJson(json);
      }).toList();

      return tempList;
    } else {
      throw Exception('Failed To Load Data...');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("build"); // สำหรับทดสอบ
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'เลือกบุตรหลาน',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Navigator.push(context, MaterialPageRoute(builder: (context) {
        //           // return CreateClass();
        //           return MenuCreate();
        //         }));
        //       },
        //       icon: Icon(Icons.add))
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Object>>(
          future: fetchJSON(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(child: Text("${data.error}"));
            } else if (data.hasData) {
              var items = data.data as List<Object>;
              return Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   // return CreateClass();
                            //   return StudentClass(widget.idclass);
                            // }));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('บุตรหลาน'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return const ParenAddStudentScreen();
                            }));
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          child: const Text('+ เพิ่มบุตรหลาน'),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black45,
                    indent: 16.0,
                  ),
                  SizedBox(
                    height: 560.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.isEmpty ? 0 : items.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    '${items[index].fname}  ${items[index].lname}',
                                  ),
                                  // onTap: () {
                                  //   getItemAndNavigate(items[index].name.toString(),
                                  //       items[index].email.toString(), context);
                                  // },
                                  subtitle: Text(
                                    items[index].email.toString(),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      delrecord(items[index].id.toString());
                                    },
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        const Color.fromARGB(255, 242, 2, 250),
                                    child:
                                        Text(items[index].fname.toString()[0],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                            )),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      drawer: ParentDrawer(fname: fname, lname: lname),
    );
  }
}

