
import 'package:flutter/cupertino.dart';
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
           _buildFeatureButton(context,"Generate QR Code",
            // Icons.qr_code,
            CupertinoIcons.qrcode,
             () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateQr(),));
            },),
             SizedBox(height: 60),
            _buildFeatureButton(context,"Scan QR",
            //  Icons.qr_code_scanner,
            CupertinoIcons.qrcode_viewfinder,
              () {
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
