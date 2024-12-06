// import 'package:flutter/material.dart';
// import 'package:flutter_application_5/widgets/appbar.dart';


// class GenearateQr extends StatefulWidget {
//   const GenearateQr({super.key});

//   @override
//   State<GenearateQr> createState() => _GenearateQrState();
// }

// class _GenearateQrState extends State<GenearateQr> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: "QR code"),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 15,right: 15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//              QrImageView(  // Changed from QrImage to QrImageView
//               data: "",
//               version: QrVersions.auto,
//               // size: 200.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_generator/widgets/appbar.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';


class GenearateQr extends StatefulWidget {

  const GenearateQr({super.key,});

  @override
  State<GenearateQr> createState() => _GenearateQrState();
}

class _GenearateQrState extends State<GenearateQr> {
  final textController = TextEditingController();
  final screenShotController = ScreenshotController();
  String qrData = '';
  String selectedType = 'Text';

  final Map<String,TextEditingController> controllers={
    'name' : TextEditingController(),
    'phone' : TextEditingController(),
    'email' : TextEditingController(),
    'url' : TextEditingController(),
  };

  String genearateQrData(){
    switch (selectedType){
      case 'contact':
      return '''BEGIN:VCARD
      VERSION:3.0
      FN:${controllers['name']?.text}
      TEL:${controllers['phone']?.text}
      EMAIL:${controllers['email']?.text}
      END:VCARD
      ''';

      case 'url':
      String url = controllers['url']?.text??"";
      if(!url.startsWith("http://") && !url.startsWith('http://')){
        url = 'https://$url';
      }

      return url;

      default:
      return textController.text;
    }
  }
    Future<void> shareQRcode()async{
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = "${directory.path}/qr_code.png";
      final capture = await screenShotController.capture();
      if (capture==null) return null;

      File imageFile = File(imagePath);
      await imageFile.writeAsBytes(capture);
      await Share.shareXFiles([XFile(imagePath)], text: "Share QR Code"); 
    }

    Widget _buildTextField (TextEditingController controller, String label){
      return Padding(padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          
        ),
        onChanged: (value) {
          setState(() {
            qrData = genearateQrData();
          });
        },
      ),
      
      );
    }

    Widget buildInputFields(){
      switch (selectedType){
        case 'contact':
        return Column(
          children: [
            _buildTextField(controllers['name']!, "Name"),
            _buildTextField(controllers['phone']!, "Phone"),
            _buildTextField(controllers['email']!, "Email"),
          ],
        );
        case 'url':
        return _buildTextField(controllers['url']!, "URL");
        default:
        return TextField(
        controller: textController,
        decoration: InputDecoration(
          labelText: "Enter Text",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          
        ),
        onChanged: (value) {
          setState(() {
            qrData = value;
          });
        },
      );
      }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[500],
      appBar: CustomAppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: "Generate QR Code"),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SegmentedButton<String>(
                        selected: {selectedType},
                        onSelectionChanged: (Set<String>selection) {
                          setState(() {
                            selectedType = selection.first;
                            qrData = '';
                          });
                        },
                    segments: [
                    ButtonSegment(value: 'Text',
                    label: Text("Text"),
                    icon: Icon(Icons.text_fields)
                    ),
                    ButtonSegment(value: 'url',
                    label: Text("URL"),
                    icon: Icon(Icons.text_fields)
                    ),
                    ButtonSegment(value: 'contact',
                    label: Text("Contact",style: TextStyle(
                      fontSize: 13
                    ),),
                    icon: Icon(Icons.contact_page)
                    ),
                  ],),
                  SizedBox(height: 24),
                  buildInputFields()
                    ],
                  
                  ),
                ),
              ),
              SizedBox(height: 24),
              if(qrData.isNotEmpty)
              Column(
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Screenshot(child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: QrImageView(data: qrData,
                          version: QrVersions.auto,
                          size: 200,
                          errorCorrectionLevel: QrErrorCorrectLevel.H,
                          ),
                        ), controller: screenShotController)
                      ],
                    ),
                    ),
                  ),
                  SizedBox(
                    height:16,
                  ),
                  ElevatedButton.icon(onPressed: shareQRcode, label: Text("Share QR Code"),
                  icon: Icon(Icons.share),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    )
                  ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}