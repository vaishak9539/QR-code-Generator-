import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as contacts;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  bool hasPermission = false;
  bool isFlashOn = false;

  late MobileScannerController scannerController;

  @override
  void initState() {
    scannerController = MobileScannerController();
    checkPermission();
    super.initState();
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  Future<void> checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      hasPermission = status.isGranted;
    });
  }

  Future<void> processScanneData(String? data) async {
    if (data == null) return;
    scannerController.stop();

    String type = "Text";
    if (data.startsWith('BEGIN:VCARD')) {
      type = 'contact';
    } else if (data.startsWith("http://") || data.startsWith("https://")) {
      type = 'url';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Scanner Result:",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(
                height: 16,
              ),
              Expanded(
                  child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      data,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    if (type == 'url')
                      ElevatedButton.icon(
                        onPressed: () {
                          // launchURL(data)
                        },
                        icon: Icon(Icons.open_in_new),
                        label: Text('open URL'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50)),
                      ),
                    if (type == 'contact')
                      ElevatedButton.icon(
                        onPressed: () {
                          // saveContact(data)
                        },
                        icon: Icon(Icons.open_in_new),
                        label: Text('Save Contact'),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50)),
                      ),
                  ],
                ),
              )),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton.icon(
                          onPressed: () {
                            Share.share(data);
                          },
                          icon: Icon(Icons.share),
                          label: Text("Share"))),
                  SizedBox(height: 16),
                  Expanded(
                      child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            scannerController.start();
                          },
                          icon: Icon(Icons.qr_code_scanner),
                          label: Text("Scan Again"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> saveContact(String vcarData) async {
    final lines = vcarData.split("\n");
    String? name, phone, email;
    for (var line in lines) {
      if (line.startsWith('FN:')) name = line.substring(3);
      if (line.startsWith('TEL:')) phone = line.substring(4);
      if (line.startsWith('EMAIL:')) email = line.substring(5);
    }
    final contact = contacts.Contact()
      ..name.first = name ?? ''
      ..phones = [contacts.Phone(phone ?? '')]
      ..emails = [contacts.Email(email ?? '')];

      try {
        await contact.insert();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contact Saved!")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed!")));
      }
  }


  @override
  Widget  build(BuildContext context) {
    if(!hasPermission){
      return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(

          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 350,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                      size: 64,
                      color: Colors.grey,
                      ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Camera Permission Is Required"),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: checkPermission,
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors. indigo,
                        foregroundColor: Colors.white
                       ),
                       child: Text("Grant Permission"),
                       ),
                       SizedBox(height: 16),
                    ],
                  ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }else{
      return Scaffold(
         backgroundColor: Colors.indigo,
        appBar: AppBar(
          title: Text("Scan QR Code"),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          actions: [
            IconButton(onPressed: () {
              setState(() {
                
                isFlashOn = !isFlashOn;
                scannerController.toggleTorch();
              });
            }, icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off))
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: scannerController,
              onDetect: (barcodes) {
                final barcode = barcodes.barcodes.first;
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!;
                  processScanneData(code);
                }
              },
            ),
            Positioned(
              bottom:24,
              left: 0,
              right: 0,

              child: 
              Center(child: Text(
                "Align QR Code Within The frame",
                style: TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              )
            )
          ],
        ),
      );
    }
  }
}