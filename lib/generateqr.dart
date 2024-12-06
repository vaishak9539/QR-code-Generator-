
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_generator/constant/constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:qrcode_generator/widgets/appbar.dart';

class GenerateQr extends StatefulWidget {
  const GenerateQr({super.key});

  @override
  State<GenerateQr> createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  final textController = TextEditingController();
  final urlController = TextEditingController();
  final screenShotController = ScreenshotController();
  String qrData = '';
  String selectedType = 'Text';

  /// Generate QR data based on selected type
  String generateQrData() {
    switch (selectedType) {
      case 'url':
        String url = urlController.text;
        if (!url.startsWith("http://") && !url.startsWith('https://')) {
          url = 'https://$url';
        }
        return url;
      default:
        return textController.text;
    }
  }

  /// Share the generated QR code
  Future<void> shareQRcode() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = "${directory.path}/qr_code.png";
    final capture = await screenShotController.capture();
    if (capture == null) return;

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(capture);
    await Share.shareXFiles([XFile(imagePath)], text: "Share QR Code");
  }

  /// Build input fields based on selected type
  Widget buildInputFields() {
    switch (selectedType) {
      case 'url':
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: TextField(
            controller: urlController,
            decoration: InputDecoration(
              labelText: "Enter URL",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (value) {
              setState(() {
                qrData = generateQrData();
              });
            },
          ),
        );
      default:
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: "Enter Text",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (value) {
              setState(() {
                 qrData = generateQrData();
              });
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primery,
      appBar: CustomAppBar(
        backgroundColor: MyColors.primery,
        foregroundColor: Colors.white,
        title: "Generate QR Code",
        color: MyColors.text,
      ),
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
                        onSelectionChanged: (Set<String> selection) {
                          setState(() {
                            selectedType = selection.first;
                            qrData = '';
                          });
                        },
                        segments: [
                          ButtonSegment(
                              value: 'Text',
                              label: Text("Text"),
                              icon: Icon(Icons.text_fields)),
                          ButtonSegment(
                              value: 'url',
                              label: Text("URL"),
                              icon: Icon(Icons.link)),
                        ],
                      ),
                      SizedBox(height: 24),
                      buildInputFields(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              if (qrData.isNotEmpty)
                Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Screenshot(
                          controller: screenShotController,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(16),
                            child: QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 200,
                              errorCorrectionLevel: QrErrorCorrectLevel.H,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: shareQRcode,
                      icon: Icon(Icons.share,),
                      label: Text("Share QR Code"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
