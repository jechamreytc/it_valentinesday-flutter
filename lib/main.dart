import 'dart:convert';
import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:it_valentinesday/female/female.dart';
import 'package:it_valentinesday/male/male.dart';
import 'package:it_valentinesday/not_match.dart';
import 'package:it_valentinesday/session_storage.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedGender = "";
  TextEditingController _fullnamecontroller = TextEditingController();
  TextEditingController _idnumberController = TextEditingController();
  TextEditingController _adminPasswordController = TextEditingController();
  bool _isLongPress = false;
  Timer? _timer;
  int _longPressDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/LoginBg.gif"), // Replace with your image path
                fit: BoxFit
                    .cover, // Adjust this as per your needs (cover, contain, etc.)
              ),
            ),
          ),
          // Your existing UI with form fields
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Fill Your Love Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade400,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _fullnamecontroller,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: Colors.pink.shade300),
                          prefixIcon:
                              Icon(Icons.person, color: Colors.pink.shade300),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade100),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _idnumberController,
                        decoration: InputDecoration(
                          labelText: '02-xxxx-xxxxxx',
                          labelStyle: TextStyle(color: Colors.pink.shade300),
                          prefixIcon: Icon(Icons.perm_identity,
                              color: Colors.pink.shade300),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade100),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Are you looking for',
                        style: TextStyle(
                          color: Colors.pink.shade300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Icon(
                                Icons.male,
                                color: Colors.blue.shade300,
                                size: 50,
                              ),
                              leading: Radio<String>(
                                value: 'Female',
                                groupValue: _selectedGender,
                                activeColor: Colors.pink.shade300,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Icon(
                                Icons.female,
                                color: Colors.pink.shade300,
                                size: 50,
                              ),
                              leading: Radio<String>(
                                value: 'Male',
                                groupValue: _selectedGender,
                                activeColor: Colors.blue.shade300,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onLongPress: () {
                          _isLongPress = true;
                          _longPressDuration = 0;
                          _timer =
                              Timer.periodic(Duration(seconds: 1), (timer) {
                            if (_isLongPress) {
                              setState(() {
                                _longPressDuration++;
                              });
                            } else {
                              timer.cancel();
                            }
                          });

                          Future.delayed(Duration(seconds: 3), () {
                            if (_isLongPress) {
                              // Cancel the timer before showing the dialog
                              _timer?.cancel();

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 200.0,
                                      top: 200.0,
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: AlertDialog(
                                      backgroundColor: Colors.pink.shade50,
                                      title: Text(
                                        "Welcome to Admin Mode",
                                        style: TextStyle(
                                          color: Colors.pink.shade400,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller:
                                                _adminPasswordController,
                                            decoration: InputDecoration(
                                              labelText: 'Enter Password',
                                            ),
                                            obscureText: true,
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              clearData(_timer);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.pink.shade400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).then((_) {
                                setState(() {
                                  _isLongPress = false;
                                });
                              });
                            }
                          });
                        },
                        onLongPressUp: () {
                          _isLongPress = false;
                          _timer?.cancel();
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            if (!_isLongPress) {
                              if (_fullnamecontroller.text.isEmpty ||
                                  _idnumberController.text.isEmpty ||
                                  _selectedGender.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please fill all the fields",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                create();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.pink.shade300,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Create",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void create() async {
    try {
      var url = Uri.parse("${SessionStorage.url}save_data.php");
      Map<String, dynamic> jsonData = {
        "gender": _selectedGender,
        "id_number": _idnumberController.text,
      };
      Map<String, String> requestBody = {
        "operation": "saveData",
        "json": jsonEncode(jsonData),
      };
      var response = await http.post(url, body: requestBody);
      print(response.body);
      var res = jsonDecode(response.body);
      if (res['status'] == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => _selectedGender == 'Male'
                ? Male(
                    name: _fullnamecontroller.text,
                    gender: _selectedGender,
                    myText: '',
                    idNumber: _idnumberController.text,
                    showMatchImage: false,
                  )
                : Female(
                    name: _fullnamecontroller.text,
                    gender: _selectedGender,
                    myText: '',
                    idNumber: _idnumberController.text,
                    showMatchImage: false,
                  ),
          ),
        );
      } else {
        print(
          res['message'],
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void clearData(Timer? timer) async {
    try {
      var url = Uri.parse("${SessionStorage.url}delete_data.php");
      Map<String, dynamic> jsonData = {
        "password": _adminPasswordController.text,
      };
      Map<String, String> requestBody = {
        "operation": "clearData",
        "json": jsonEncode(jsonData),
      };
      var response = await http.post(url, body: requestBody);
      var res = jsonDecode(response.body);
      if (res['status'] == 1) {
        setState(() {
          // Stop the timer if it was passed
          timer?.cancel();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Deleted successfully",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
