// import 'package:flutter/material.dart';
// import 'package:qrcode_generator/constant/constant.dart';

// class QRScannerOverlay extends StatelessWidget {
//   final Color overlayColour;

//   const QRScannerOverlay({required this.overlayColour, Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final width = constraints.maxWidth;
//         final height = constraints.maxHeight;
//         final overlaySize = width * 0.8;

//         return Stack(
//           children: [
//             Container(
//               color: overlayColour.withOpacity(0.7),
//               // color: MyColors.text,
//             ),
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 width: overlaySize,
//                 height: overlaySize,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.white, width: 2),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.transparent,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


