import 'package:fairstores/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchField extends StatelessWidget {
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final Color? iconColor;
  final TextEditingController? controller;

  const CustomSearchField({
    Key? key,
    required this.onSubmitted,
    this.controller,
    this.iconColor,
    this.autofocus = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        autofocus: autofocus,
        onSubmitted: onSubmitted,
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color: kPrimary,
            )
          ),
          focusColor: kPrimary,
          prefixIcon: Icon(
            Icons.search,
            size: 14,
            color: iconColor,
          ),
          labelText: 'Search FairStores app',
          labelStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: kLabelColor
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kLabelColor,
            ),
            borderRadius: BorderRadius.circular(100)
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kLabelColor,
            ),
            borderRadius: BorderRadius.circular(100)
          ),
        )
      ),
    );
  }
}