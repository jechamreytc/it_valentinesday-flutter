import 'package:flutter/material.dart';

class Matchpakyo extends StatefulWidget {
  const Matchpakyo({ Key? key }) : super(key: key);

  @override
  _MatchpakyoState createState() => _MatchpakyoState();
}

class _MatchpakyoState extends State<Matchpakyo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Match mo Pakyo ka?"),
    );
  }
}