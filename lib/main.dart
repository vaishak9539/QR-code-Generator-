import 'package:flutter/material.dart';
import 'package:qrcode_generator/myhomepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
     
        colorScheme: ColorScheme.fromSeed(brightness: Brightness.light,seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Myhomepage()
    );
  }
}

