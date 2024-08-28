import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:it_valentinesday/qrscanner/barcode_scanner_simple.dart';
import 'package:it_valentinesday/session_storage.dart';
import 'package:qr_bar_code/qr/qr.dart';

class Female extends StatefulWidget {
  final String name;
  final String gender;
  final String myText;
  final bool showMatchImage;

  const Female({
    Key? key,
    required this.name,
    required this.gender,
    required this.myText,
    required this.showMatchImage,
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
  void dispose() {
    super.dispose();
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
                if (widget.showMatchImage) ...[
                  // Show the image if showImage or showMatchImage is true
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/heart.jpg',
                    height: 100,
                    width: 100,
                  ),
                ] else ...[
                  // Only show these widgets if showImage is false and showMatchImage is false
                  Text('Female'),
                  Text('Hello ' + widget.name + '!'),
                  if (id.isNotEmpty) ...[
                    Text('Your ID: $id'),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 300,
                      child: QRCode(data: id),
                    ),
                  ] else ...[
                    CircularProgressIndicator(),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (id.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BarcodeScannerSimple(
                              myId: id,
                              gender: widget.gender,
                              name: widget.name,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please wait until the ID is fetched.'),
                          ),
                        );
                      }
                    },
                    child: Text('Scan QR Code'),
                  ),
                  SizedBox(height: 20),
                  Text(widget.myText),
                ],
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
          id = responseData['id'].toString();
          isIdFetched = true;
        });
      } else {
        print("Failed to fetch ID: ${responseData['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
