
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qrcode_generator/constant/constant.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ScanQr extends StatefulWidget {
//   const ScanQr({super.key});

//   @override
//   State<ScanQr> createState() => _ScanQrState();
// }

// class _ScanQrState extends State<ScanQr> {
//   bool hasPermission = false;
//   bool isFlashOn = false;

//   late MobileScannerController scannerController;

//   @override
//   void initState() {
//     scannerController = MobileScannerController();
//     checkPermission();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     scannerController.dispose();
//     super.dispose();
//   }

//   Future<void> checkPermission() async {
//     final status = await Permission.camera.request();
//     setState(() {
//       hasPermission = status.isGranted;
//     });
//   }

//   Future<void> processScannedData(String? data) async {
//     if (data == null) return;
//     scannerController.stop();

//     String type = "Text";
//     if (data.startsWith("http://") || data.startsWith("https://")) {
//       type = 'url';
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.6,
//         minChildSize: 0.4,
//         maxChildSize: 0.9,
//         builder: (context, scrollController) => Container(
//           decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.surface,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//           padding: EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   margin: EdgeInsets.only(bottom: 24),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               Text(
//                 "Scanner Result:",
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Expanded(
//                   child: SingleChildScrollView(
//                 controller: scrollController,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SelectableText(
//                       data,
//                       style: Theme.of(context).textTheme.bodyLarge,
//                     ),
//                     SizedBox(
//                       height: 24,
//                     ),
//                     if (type == 'url')
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           launchURL(data);
//                         },
//                         icon: Icon(Icons.open_in_new),
//                         label: Text('Open URL'),
//                         style: ElevatedButton.styleFrom(
//                             minimumSize: Size.fromHeight(50)),
//                       ),
//                   ],
//                 ),
//               )),
//               SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                       child: OutlinedButton.icon(
//                           onPressed: () {
//                             Share.share(data);
//                           },
//                           icon: Icon(Icons.share),
//                           label: Text("Share"))),
//                   SizedBox(width: 16),
//                   Expanded(
//                       child: OutlinedButton.icon(
//                           onPressed: () {
//                             Navigator.pop(context);
//                             scannerController.start();
//                           },
//                           icon: Icon(Icons.qr_code_scanner),
//                           label: Text("Scan Again"))),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> launchURL(String url) async {
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!hasPermission) {
//       return Scaffold(
//         backgroundColor: MyColors.primery,
//         appBar: AppBar(
//           backgroundColor: MyColors.primery,
//           foregroundColor: Colors.white,
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Center(
//               child: SizedBox(
//                 height: 350,
//                 child: Card(
//                   elevation: 0,
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(30),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.camera_alt_outlined,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(
//                           height: 16,
//                         ),
//                         Text("Camera Permission Is Required"),
//                         SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: checkPermission,
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.indigo,
//                               foregroundColor: Colors.white),
//                           child: Text("Grant Permission"),
//                         ),
//                         SizedBox(height: 16),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     } 
//     else {
//       return Scaffold(
//         backgroundColor: MyColors.primery,
//         appBar: AppBar(
//           title: Text("Scan QR Code"),
//           backgroundColor: MyColors.primery,
//           foregroundColor: Colors.white,
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     isFlashOn = !isFlashOn;
//                     scannerController.toggleTorch();
//                   });
//                 },
//                 icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off))
//           ],
//         ),
//         body: Stack(
//           children: [
//             MobileScanner(
//               controller: scannerController,
//               onDetect: (barcodes) {
//                 final barcode = barcodes.barcodes.first;
//                 if (barcode.rawValue != null) {
//                   final String code = barcode.rawValue!;
//                   processScannedData(code);
//                 }
//               },
//             ),
//             Positioned(
//               bottom: 24,
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Text(
//                   "Align QR Code Within The Frame",
//                   style: TextStyle(
//                     color: Colors.white,
//                     backgroundColor: Colors.black.withOpacity(0.6),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcode_generator/constant/constant.dart';
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

  Future<void> processScannedData(String? data) async {
    if (data == null) return;
    scannerController.stop();

    String type = "Text";
    if (data.startsWith("http://") || data.startsWith("https://")) {
      type = 'url';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          // Restart the scanner when the back button is pressed
          scannerController.start();
          return true;
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
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
                SizedBox(height: 16),
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
                        SizedBox(height: 24),
                        if (type == 'url')
                          ElevatedButton.icon(
                            onPressed: () {
                              launchURL(data);
                            },
                            icon: Icon(Icons.open_in_new),
                            label: Text('Open URL'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(50),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Share.share(data);
                        },
                        icon: Icon(Icons.share),
                        label: Text("Share"),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          scannerController.start();
                        },
                        icon: Icon(Icons.qr_code_scanner),
                        label: Text("Scan Again"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  @override
  Widget build(BuildContext context) {
    if (!hasPermission) {
      return Scaffold(
        backgroundColor: MyColors.primery,
        appBar: AppBar(
          backgroundColor: MyColors.primery,
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
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text("Camera Permission Is Required"),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: checkPermission,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Grant Permission"),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: MyColors.primery,
        appBar: AppBar(
          title: Text("Scan QR Code"),
          backgroundColor: MyColors.primery,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                  scannerController.toggleTorch();
                });
              },
              icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            ),
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
                  processScannedData(code);
                }
              },
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Align QR Code Within The Frame",
                  style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
