// import 'package:flutter/material.dart';
// import 'package:flutter_application_5/widgets/appbar.dart';
// import 'package:flutter_application_5/widgets/custom_text.dart';
// import 'package:flutter_application_5/widgets/custom_text_field.dart';

// class Myhomepage extends StatefulWidget {
//   const Myhomepage({super.key});

//   @override
//   State<Myhomepage> createState() => _MyhomepageState();
// }

// class _MyhomepageState extends State<Myhomepage> {
//   final textQr = TextEditingController();
//   String textQrCodeScanner = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "Generate QR code and share",
//         color: Colors.white,
//         backgroundColor: const Color(0xffFF4E88),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 20),
//           CustomTextField(
//             controller: textQr,
//             hintText: "Enter Text",
//             maxLines: 5,
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const GenearateQr(),
//                   ),
//                 );
//               },
//               child: Container(
//                 height: 50,
//                 color: const Color(0xffFF4E88),
//                 child: Center(
//                   child: CustomText(
//                     text: "Generate",
//                     size: 16,
//                     weight: FontWeight.normal,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: GestureDetector(
//               // onTap:
//               //  scanQrCode,  // Fixed: Remove the () =>
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: const Color(0xffFF4E88),
//                     width: 1.5,
//                   ),
//                 ),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.document_scanner_outlined,
//                         color: Color(0xffFF4E88),
//                       ),
//                       const SizedBox(width: 10),
//                       CustomText(
//                         text: "Scanner",
//                         size: 16,
//                         weight: FontWeight.normal,
//                         color: Color(0xffFF4E88),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           if (textQrCodeScanner.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Text(textQrCodeScanner),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrcode_generator/constant/constant.dart';
import 'package:qrcode_generator/generateqr.dart';
import 'package:qrcode_generator/scan_qr.dart';
import 'package:qrcode_generator/widgets/appbar.dart';


class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: MyColors.primery,
     appBar: CustomAppBar(
      backgroundColor: MyColors.primery,
      title:  "Generate QR and Share",
      color: MyColors.text,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           _buildFeatureButton(context,"Generate QR Code", Icons.qr_code, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GenearateQr(),));
            },),
             SizedBox(height: 60),
            _buildFeatureButton(context,"Scan QR", Icons.qr_code_scanner, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQr(),));
            },)
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String title, IconData icon,VoidCallback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        
        padding: EdgeInsets.all(20),
        height: 200,
        width: 250,
        decoration: BoxDecoration(
          color: MyColors.secondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 2,color: MyColors.text)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon,size: 90,color: Colors.white,),
            Text(title,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)
            
          ],
        ),
      ),
    );
  }
}
