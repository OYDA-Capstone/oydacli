import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to OYDACLI'),
        ),
        body: Center(
          child: Text('Built with love by O2🖤'),
        ),
      ),
    );
  }
}

