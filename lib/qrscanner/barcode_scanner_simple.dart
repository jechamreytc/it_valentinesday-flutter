import 'package:flutter/material.dart';
import 'package:it_valentinesday/male/male.dart';
import 'package:it_valentinesday/female/female.dart';
import 'package:it_valentinesday/session_storage.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class BarcodeScannerSimple extends StatefulWidget {
  final String myId; // The ID of the user scanning the QR code
  final String gender;
  final String name;

  const BarcodeScannerSimple({
    Key? key,
    required this.myId,
    required this.gender,
    required this.name,
  }) : super(key: key);

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  String resultMessage = '';
  bool isProcessing = false;

  // Builds the barcode display widget
  Widget _buildBarcode(Barcode? value) {
    return Text(
      value?.displayValue ?? 'Find Your Partner',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  // Handles the barcode detection logic
  void _handleBarcode(BarcodeCapture barcodes) async {
    if (!isProcessing && barcodes.barcodes.isNotEmpty) {
      setState(() {
        isProcessing = true;
        _barcode = barcodes.barcodes.first; // Update the barcode to display
      });

      final scannedId = _barcode?.displayValue ?? '';
      if (scannedId.isNotEmpty) {
        try {
          final matchResult = await _checkMatch(scannedId);

          setState(() {
            if (matchResult['status'] == 1 && matchResult['match']) {
              resultMessage = 'Match! Both users have been notified.';
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.gender == 'male'
                      ? Male(
                          name: widget.name,
                          gender: widget.gender,
                          myText: "Match Found", showMatchImage: true,
                        )
                      : Female(
                          name: widget.name,
                          gender: widget.gender,
                          myText: "Match Found", showMatchImage: true,
                        ),
                ),
              );
            } else {
              resultMessage = matchResult['status'] == 1
                  ? 'No match.'
                  : 'Error: ${matchResult['message'] ?? 'Unknown error'}';
            }
          });
        } catch (e) {
          setState(() {
            resultMessage = 'Failed to check match. Please try again.';
          });
          print('Error during _checkMatch: $e');
        }
      } else {
        setState(() {
          resultMessage = 'Invalid QR code.';
        });
      }

      setState(() {
        isProcessing = false;
      });
    }
  }

  // Checks if the scanned ID matches the current user's ID
  Future<Map<String, dynamic>> _checkMatch(String scannedId) async {
    try {
      final url = Uri.parse("${SessionStorage.url}save_data.php");
      final jsonData = {
        "id": scannedId,
        "gender": widget.gender,
      };

      final response = await http.post(
        url,
        body: {
          "operation": "checkMatch",
          "json": jsonEncode(jsonData),
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      print('Error in _checkMatch: $e');
      return {"status": 0, "message": "Failed to communicate with the server"};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mobile Scanner to detect QR codes
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          // Blurred background outside the scan area
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Scan area with red corners
          Center(
            child: Container(
              width: 250,
              height: 250,
              child: CustomPaint(
                painter: CornerPainter(),
              ),
            ),
          ),
          // Result and instructions at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBarcode(_barcode),
                  if (resultMessage.isNotEmpty)
                    Text(
                      resultMessage,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter to draw the red corners of the scan area
class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final double cornerLength = 40.0; // Length of the red corner lines

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, cornerLength)
      ..moveTo(0, 0)
      ..lineTo(cornerLength, 0)
      ..moveTo(size.width, 0)
      ..lineTo(size.width - cornerLength, 0)
      ..moveTo(size.width, 0)
      ..lineTo(size.width, cornerLength)
      ..moveTo(size.width, size.height)
      ..lineTo(size.width - cornerLength, size.height)
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, size.height - cornerLength)
      ..moveTo(0, size.height)
      ..lineTo(cornerLength, size.height)
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
