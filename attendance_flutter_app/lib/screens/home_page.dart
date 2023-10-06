import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WifiInfoWrapper? _wifiObject;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  int selectedIndex = 0;
  bool isSessionStarted = false;
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSessionStarted = !isSessionStarted;
                              });
                            },
                            child: isSessionStarted == true
                                ? Container(
                                    width: double.infinity,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Row(
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
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Row(
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
                                "Wifi SSID: ${_wifiObject?.ssid}",
                                style: const TextStyle(fontSize: 15),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Session Id: 123456",
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
              itemCount: dummyData.length,
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
                          Text(dummyData[index]["date"]!),
                          Text(dummyData[index]["checkIn"]!),
                          Text(dummyData[index]["studentName"]!),
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
    return const Center(
      child: Text("Student"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome Home!"),
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
