import 'package:flutter/material.dart';
import 'package:qrcode_generator/widgets/custom_text.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "Place the QR Code in the area",
                  size: 18,
                  weight: FontWeight.bold,
                  ),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  CustomText(text: "Scanning will be started automatically",
                  size: 16,
                  color: Colors.black54,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: 
                CustomText(text: "Developed by Vaishak",
                  size: 14,
                  color: Colors.black87,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}