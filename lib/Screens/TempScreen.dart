import 'package:flutter/material.dart';

class TempScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temp Screen'),
      ),
      body: Center(
        child: Text('This is a temporary screen'),
      ),
    );
  }
}
