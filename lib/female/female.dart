import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_valentinesday/main.dart';
import 'package:it_valentinesday/qrscanner/barcode_scanner_simple.dart';
import 'package:it_valentinesday/session_storage.dart';
import 'package:qr_bar_code/qr/qr.dart';

class Female extends StatefulWidget {
  final String name;
  final String gender;
  final String myText;
  final String idNumber;
  final bool showMatchImage;

  const Female({
    Key? key,
    required this.name,
    required this.gender,
    required this.myText,
    required this.showMatchImage,
    required this.idNumber,
  }) : super(key: key);

  @override
  _FemaleState createState() => _FemaleState();
}

class _FemaleState extends State<Female> {
  String id = "";
  bool isIdFetched = false;

  final TextEditingController _passwordDifferentAccountController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    getId(); // Fetch the ID when the widget is initialized
  }

  @override
  void dispose() {
    _passwordDifferentAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/FBg.gif'), // Replace with your background image path
            fit: BoxFit.cover, // Make sure the image covers the entire screen
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title with heart icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, color: Colors.pink, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Hello, ${widget.name}!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.favorite, color: Colors.pink, size: 30),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.idNumber,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  // QR Code Card with "Scan me for your partner" text
                  if (id.isNotEmpty) ...[
                    Text(
                      'Scan me for your partner',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: <Color>[
                              Colors.pink,
                              Colors.redAccent,
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  QRCode(data: id),
                                  Icon(Icons.favorite,
                                      color:
                                          const Color.fromARGB(255, 206, 25, 12)
                                              .withOpacity(0.3),
                                      size: 200),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    CircularProgressIndicator(),
                  ],
                  SizedBox(height: 20),

                  // Scan QR Code Button with heart icon
                  ElevatedButton.icon(
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
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent, // Background color
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    icon: Icon(Icons.favorite),
                    label: Text('Scan QR Code'),
                  ),
                ],
              ),
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
