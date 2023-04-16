import 'package:flutter/material.dart';
import 'package:quotes_app/views/screens/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}
