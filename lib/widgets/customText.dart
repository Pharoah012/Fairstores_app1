import 'package:fairstores/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isMediumWeight;
  final double fontSize;
  final Color? color;
  final bool isCenter;
  final TextOverflow? overflow;
  final double? lineHeight;

  const CustomText({
    Key? key,
    required this.text,
    this.isBold = false,
    this.fontSize = 14.0,
    this.color = kLabelColor,
    this.isMediumWeight = false,
    this.isCenter = false,
    this.overflow,
    this.lineHeight
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: isCenter ? TextAlign.center : null,
      overflow: overflow,
      style: GoogleFonts.manrope(
      fontSize: fontSize,
        fontWeight: isBold
          ? FontWeight.w700
          : isMediumWeight
            ? FontWeight.w600
            : FontWeight.w400,
        color: color,
        height: lineHeight
      )
    );
  }
}
