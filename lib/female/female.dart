import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:it_valentinesday/qrscanner/barcode_scanner_simple.dart';
import 'package:it_valentinesday/session_storage.dart';
import 'package:qr_bar_code/qr/qr.dart'; // Ensure this package is included

class Female extends StatefulWidget {
  final String name;
  final String gender;

  const Female({
    Key? key,
    required this.name,
    required this.gender,
  }) : super(key: key);

  @override
  _FemaleState createState() => _FemaleState();
}

class _FemaleState extends State<Female> {
  String id = "";
  bool isIdFetched = false;

  @override
  void initState() {
    super.initState();
    getId(); // Fetch the ID when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Female'),
                Text('Hello ' + widget.name + '!'),
                if (id.isNotEmpty) ...[
                  Text('Your ID: $id'), // Display the fetched ID
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 300,
                    child: QRCode(data: id),
                  ), // Insert the ID into the QR code
                ] else ...[
                  CircularProgressIndicator(), // Show a loading indicator while fetching the ID
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (id.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BarcodeScannerSimple(
                              myId: id, gender: widget.gender),
                        ),
                      );
                    } else {
                      // Optionally, you can show an error message if the ID is not available
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please wait until the ID is fetched.'),
                        ),
                      );
                    }
                  },
                  child: Text('Scan QR Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getId() async {
    try {
      var url = Uri.parse("${SessionStorage.url}save_data.php");
      Map<String, dynamic> jsonData = {
        "gender": widget.gender,
      };
      Map<String, String> requestBody = {
        "operation": "getId",
        "json": jsonEncode(jsonData),
      };

      var response = await http.post(url, body: requestBody);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        setState(() {
          id = responseData['id'].toString(); // Update the ID in the state
          isIdFetched = true; // Indicate that the ID is fetched
        });
      } else {
        print("Failed to fetch ID: ${responseData['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
