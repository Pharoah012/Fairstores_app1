import 'package:fairstores/constants.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchField extends StatefulWidget {

  const CustomSearchField({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Search(),
                )
            );
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: kPrimary,
                )),
            focusColor: kPrimary,
            prefixIcon: const Icon(
              Icons.search,
              size: 14,
            ),
            labelText: 'Search FairStores app',
            labelStyle: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: const Color(0xff8B8380)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffE5E5E5),
                ),
                borderRadius: BorderRadius.circular(100)
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xffE5E5E5),
                ),
                borderRadius: BorderRadius.circular(100)
            ),
          )
      ),
    );
  }
}
