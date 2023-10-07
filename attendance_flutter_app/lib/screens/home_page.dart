import 'dart:developer';

import 'package:attendance_flutter_app/services/backend_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BackendService backendService = BackendService();
  WifiInfoWrapper? _wifiObject;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  int selectedIndex = 0;
  bool isSessionStarted = false;
  String _sessionId = "";
  bool isEndingSession = false;
  bool isStartingSession = false;
  bool isPostingAttendance = false;
  List<dynamic> responseList = [];
  String submittedSessionId = "";
  List<dynamic> notices = [
    {
      "notice": "This is a notice",
      "left": "0",
      "right": "0",
      "top": "0",
      "bottom": "0"
    }
  ];

  @override
  void initState() {
    super.initState();
    initPrefs();
    initPlatformState();
  }

  //initPrefs
  Future<void> initPrefs() async {
    prefs = await _prefs;
  }

  Future<void> initPlatformState() async {
    WifiInfoWrapper? wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
    } on PlatformException {}
    if (!mounted) return;

    setState(() {
      _wifiObject = wifiObject;
    });
  }

  final dummyData = [
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
    {"date": "12/12/2021", "checkIn": "12:00", "studentName": "John Doe"},
  ];

  _buildBody() {
    switch (selectedIndex) {
      case 0:
        return _buildTeacherBody();
      case 1:
        return _buildStudentBody();
      case 2:
        return _buildENoticeBody();
      default:
        return _buildTeacherBody();
    }
  }

  _buildTeacherBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat.yMMMMd().format(DateTime.now()),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat.Hm().format(DateTime.now()),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isSessionStarted == true
                              ? GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isEndingSession = true;
                                    });
                                    initPlatformState();
                                    if (_wifiObject != null &&
                                        _sessionId != null) {
                                      var res = await backendService.endSession(
                                          _wifiObject!.bssId, _sessionId!);
                                      if (res.data["message"] ==
                                          "Session turned off") {
                                        log(res.data.toString());
                                        setState(() {
                                          isEndingSession = false;
                                          isSessionStarted = false;
                                          _sessionId = "";
                                          responseList =
                                              res.data["active_students"];
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Session stopped successfully")));
                                      } else {
                                        setState(() {
                                          isEndingSession = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Something went wrong.")));
                                      }
                                    } else {
                                      setState(() {
                                        isEndingSession = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Error getting wifi info. Please check your wifi connection and try again.")));
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: isEndingSession == true
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.stop,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Stop Session",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isStartingSession = true;
                                    });
                                    var res =
                                        await backendService.startSession();
                                    if (res.data["message"] ==
                                        "Session started") {
                                      log(res.data.toString());
                                      setState(() {
                                        isStartingSession = false;
                                        isSessionStarted = true;
                                        _sessionId =
                                            "${res.data["session_id"]}";
                                      });
                                    } else {
                                      setState(() {
                                        isStartingSession = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Something went wrong.")));
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: isStartingSession == true
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Start Session",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                          if (isSessionStarted == true) ...[
                            const SizedBox(
                              height: 20,
                            ),
                            if (_wifiObject != null)
                              Text(
                                "Wifi SSID: ${_wifiObject?.bssId}",
                                style: const TextStyle(fontSize: 15),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (_wifiObject != null)
                              Text(
                                "Wifi IP: ${_wifiObject?.ipAddress}",
                                style: const TextStyle(fontSize: 15),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Session Id: $_sessionId",
                              style: TextStyle(fontSize: 15),
                            ),
                          ]
                        ],
                      ),
                    ))
              ],
            ),
          ),
          const Divider(height: 50, thickness: 1),
          const Text("Today's Attendance", style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 15,
          ),
          Container(
            color: Colors.indigo,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Date",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text("Check In",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text("Student Name",
                      style: TextStyle(color: Colors.white, fontSize: 16))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: responseList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.indigo),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(responseList[index]["date"]),
                          Text(responseList[index]["checkIn"]),
                          Text(responseList[index]["username"]),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  _buildStudentBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Today",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat.yMMMMd().format(DateTime.now()),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              DateFormat.Hm().format(DateTime.now()),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              submittedSessionId = value;
                            });
                          },
                          initialValue: submittedSessionId,
                          decoration: const InputDecoration(
                              hintText: "Enter the session id"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () async {
                              setState(() {
                                isPostingAttendance = true;
                              });
                              initPlatformState();
                              if (_wifiObject != null) {
                                var res = await backendService.postAttendance(
                                    _wifiObject!.bssId,
                                    submittedSessionId,
                                    "123456",
                                    "John Doe");
                                if (res != null && res.data != null) {
                                  if (res.data["message"] ==
                                      "Additional data stored successfully") {
                                    setState(() {
                                      isPostingAttendance = false;
                                      submittedSessionId = "";
                                    });
                                    log("${res.data.toString()}");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Attendance posted successfully")));
                                  } else {
                                    setState(() {
                                      isPostingAttendance = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Something went wrong.")));
                                  }
                                }
                              } else {
                                setState(() {
                                  isPostingAttendance = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Error getting wifi info. Please check your wifi connection and try again.")));
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                              child: isPostingAttendance == true
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.done_all_rounded,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Check In",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                            )),
                        if (isSessionStarted == true) ...[
                          const SizedBox(
                            height: 20,
                          ),
                          if (_wifiObject != null)
                            Text(
                              "Wifi SSID: ${_wifiObject?.bssId}",
                              style: const TextStyle(fontSize: 15),
                            ),
                        ]
                      ],
                    ),
                  ))
            ],
          ),
        ),
        // const Divider(height: 50, thickness: 1),
        // const Text("My Attendance", style: TextStyle(fontSize: 20)),
        // const SizedBox(
        //   height: 10,
        // ),
        // //12 months horizontal list
        // Container(
        //   height: 100,
        //   child: ListView.builder(
        //       shrinkWrap: true,
        //       physics: const BouncingScrollPhysics(),
        //       scrollDirection: Axis.horizontal,
        //       itemCount: 12,
        //       itemBuilder: (context, index) {
        //         return Container(
        //           margin: const EdgeInsets.only(right: 10),
        //           width: 100,
        //           decoration: BoxDecoration(
        //               color: Colors.green,
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Center(
        //               child: Text(
        //             "Month ${index + 1}",
        //             style: const TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold),
        //           )),
        //         );
        //       }),
        // ),
        // const SizedBox(
        //   height: 15,
        // ),
        // Container(
        //   color: Colors.green,
        //   child: const Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         Text("Date",
        //             style: TextStyle(color: Colors.white, fontSize: 16)),
        //         Text("Check In",
        //             style: TextStyle(color: Colors.white, fontSize: 16)),
        //         Text("Student Name",
        //             style: TextStyle(color: Colors.white, fontSize: 16))
        //       ],
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // ListView.builder(
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemCount: dummyData.length,
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Container(
        //           margin: const EdgeInsets.only(bottom: 5),
        //           decoration: BoxDecoration(
        //               border: Border.all(color: Colors.green),
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(vertical: 8.0),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               children: [
        //                 Text(dummyData[index]["date"]!),
        //                 Text(dummyData[index]["checkIn"]!),
        //                 Text(dummyData[index]["studentName"]!),
        //               ],
        //             ),
        //           ),
        //         ),
        //       );
        //     }),
      ],
    );
  }

  _buildENoticeBody() {
    return Stack(children: [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
      Positioned(
          top: 50,
          left: 100,
          child: Container(
            height: 60,
            width: 50,
            alignment: Alignment.center,
            color: Colors.yellow.shade100,
            child: Text("notice 1"),
          )),
      Positioned(
          top: 500,
          left: 100,
          child: Container(
            height: 60,
            width: 50,
            alignment: Alignment.center,
            color: Colors.yellow.shade100,
            child: Text("notice 2"),
          )),
      Positioned(
          top: 150,
          left: 300,
          child: Container(
            height: 60,
            width: 50,
            alignment: Alignment.center,
            color: Colors.yellow.shade100,
            child: Text("notice 3"),
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: selectedIndex == 0
              ? Colors.indigo
              : selectedIndex == 1
                  ? Colors.green
                  : Colors.indigo,
          title: const Text("Welcome Home!"),
        ),
        floatingActionButton: selectedIndex == 2
            ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  String left = "0", right = "0", top = "0", bottom = "0";
                  String content = "";
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Notice"),
                        content: SizedBox(
                          height: 350,
                          child: Column(
                            children: [
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    content = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                    hintText: "Enter the notice here"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    left = value;
                                  });
                                },
                                decoration:
                                    const InputDecoration(hintText: "Left"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    right = value;
                                  });
                                },
                                decoration:
                                    const InputDecoration(hintText: "Right"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    top = value;
                                  });
                                },
                                decoration:
                                    const InputDecoration(hintText: "Top"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    bottom = value;
                                  });
                                },
                                decoration:
                                    const InputDecoration(hintText: "Bottom"),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  notices.add({
                                    "notice": content,
                                    "left": left,
                                    "right": right,
                                    "top": top,
                                    "bottom": bottom
                                  });
                                });
                                Navigator.pop(context);
                              },
                              child: const Text("Add"))
                        ],
                      );
                    },
                  );
                })
            : FloatingActionButton.extended(
                onPressed: () {
                  launchUrl(Uri.parse(
                      "http://10.0.2.2:3000/canvas/9af59a31-1eed-4a47-b5bf-0509076e0d66"));
                },
                label: Text("Have any question?"),
                icon: Icon(Icons.chat),
              ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          type: BottomNavigationBarType.shifting,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Teacher", tooltip: "Teacher"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.child_care),
                label: "Student",
                tooltip: "Student"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "E-Notice",
                tooltip: "E-Notice")
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Center(child: Text("Drawer Header")),
                decoration: BoxDecoration(color: Colors.indigo),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () async {
                  await prefs!.clear();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: _buildBody(),
        ));
  }
}
