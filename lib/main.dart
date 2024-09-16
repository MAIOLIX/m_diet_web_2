import 'package:flutter/material.dart';
import 'image_capture_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Questo widget è la radice dell'applicazione.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDiet Web',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner:
          false, // Opzionale: rimuove il banner di debug
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MDiet Web'),
      ),
      body: Center(
        child: ImageCaptureWidget(),
      ),
    );
  }
}
