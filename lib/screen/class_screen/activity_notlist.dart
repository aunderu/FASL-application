import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/class_drawer.dart';
import 'activity_list.dart';

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

class ActivityNotParticipate extends StatefulWidget {
  final String? idclass;
  final String? idactivity;
  const ActivityNotParticipate(this.idclass, this.idactivity, {super.key});

  @override
  State<ActivityNotParticipate> createState() => _ActivityNotParticipateState();
}

class _ActivityNotParticipateState extends State<ActivityNotParticipate> {
  int? id;
  String? fnamelogin;
  String? lnamelogin;

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
      fnamelogin = pref1.getString("fname")!;
      lnamelogin = pref2.getString("lname")!;
    });
  }

  Future<void> delrecord(String stId) async {
    String? idc = widget.idclass;
    String? idacta = widget.idactivity;
    try {
      String uri =
          "https://fasl.chabafarm.com/api/teacher/activity/addstudent/$idc/$idacta";

      var res = await http.post(Uri.parse(uri), body: {"stID": stId});
      var response = jsonDecode(res.body);
      if (response['status'] == "success") {
        _refreshData();
        // print("yes");
      } else {
        // print("not");
      }
    } catch (e) {
      // print("ddd");
    }
  }

  Future<List<Object>> fetchJSON() async {
    String? idca = widget.idclass;
    String? idact = widget.idactivity;
    var jsonResponse = await http.get(Uri.parse(
        'https://fasl.chabafarm.com/api/teacher/activity/student/$idca/$idact'));

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'กิจกรรมของชั้นเรียน',
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
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return CreateClass();
                              return ActivityParticipate(
                                  widget.idclass, widget.idactivity);
                            }));
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('เข้าร่วม'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // <-- Radius
                            ),
                          ),
                          child: const Text('ไม่เข้าร่วม'),
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
                                    icon: const Icon(Icons.add),
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
      drawer:  ClassDrawer(fname: fnamelogin, lname: lnamelogin),
    );
  }
}
