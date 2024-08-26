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
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _fullnamecontroller,
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            TextField(
              controller: _idnumberController,
              decoration: const InputDecoration(
                labelText: '02-xxxxxxx-xxxx',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('Male'),
                    leading: Radio<String>(
                      value: 'Male',
                      groupValue: _selectedGender,
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
                    title: Text('Female'),
                    leading: Radio<String>(
                      value: 'Female',
                      groupValue: _selectedGender,
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
            ElevatedButton(
              onPressed: () {
                create();
              },
              child: const Text("Create"),
            ),
          ],
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
                  )
                : Female(
                    name: _fullnamecontroller.text,
                    gender: _selectedGender,
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

    // try {
    //   var url;
    //   if (_selectedGender == 'Male') {
    //     url = Uri.parse("${SessionStorage.url}male.php");
    //   } else if (_selectedGender == 'Female') {
    //     url = Uri.parse("${SessionStorage.url}female.php");
    //   } else {
    //     print("Gender not selected");
    //     return;
    //   }

    //   Map<String, dynamic> jsonData = {
    //     "full_name": _fullnamecontroller.text,
    //     "id_number": _idnumberController.text,
    //     "gender": _selectedGender
    //   };

    //   var response = await http.post(
    //     url,
    //     body: jsonEncode(jsonData),
    //     headers: {"Content-Type": "application/json"},
    //   );

    //   var res = jsonDecode(response.body);

    //   if (res['status'] == 1) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => _selectedGender == 'Male' ? Male() : Female(),
    //       ),
    //     );
    //   } else {
    //     print("Error: ${res['message']}");
    //   }
    // } catch (e) {
    //   print("Exception: $e");
    // }
  }
}
