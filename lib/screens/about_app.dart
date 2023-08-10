import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  static const routeName = '/about-app';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text('Callie App'),
      ),
    );
  }
}
