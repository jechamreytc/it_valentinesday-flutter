import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:it_valentinesday/female/female.dart';
import 'package:it_valentinesday/male/male.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
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
                      labelText: '02-xxxxxxx-xxxx',
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
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            'Are you looking for a Girl?',
                            style: TextStyle(color: Colors.pink.shade400),
                          ),
                          leading: Radio<String>(
                            value: 'Male',
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
                          title: Text(
                            'Are you looking for a Boy?',
                            style: TextStyle(color: Colors.pink.shade400),
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
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      create();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void create() async {
    try {
      var url = Uri.parse("${SessionStorage.url}save_data.php");
      Map<String, dynamic> jsonData = {"gender": _selectedGender};
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
                    showMatchImage: false,
                  )
                : Female(
                    name: _fullnamecontroller.text,
                    gender: _selectedGender,
                    myText: '',
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
}
