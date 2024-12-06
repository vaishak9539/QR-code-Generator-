
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final Color? color;
  final double? letterSpacing;
  int? maxLines;
  TextOverflow? overflow;

   CustomText({
    required this.text,
     this.size,
     this.weight,
     this.color,
    this.maxLines,
    this.letterSpacing,
    this.overflow,
    super.key
   });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: letterSpacing,
          
        )
      ),
      
    );
  }
}