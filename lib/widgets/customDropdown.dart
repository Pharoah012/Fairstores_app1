import 'package:fairstores/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdown extends ConsumerWidget {
  final StateProvider<String> currentValue;
  final List<String> items;

  const CustomDropdown({
    Key? key,
    required this.currentValue,
    required this.items
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 56,
      width: MediaQuery.of(context).size.width * 0.87,
      child: DropdownButtonFormField<String>(
          validator: ((value) {
            if (value!.isEmpty) {
              return null;
            } else {
              return null;
            }
          }),
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: kPrimary,
                  )),
              focusColor: kPrimary,
              labelStyle: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: const Color(0xff8B8380)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xffE5E5E5),
                  ),
                  borderRadius:
                  BorderRadius.circular(10))),
          hint: const Text("Select School"),
          items: items.map((value) {
            return DropdownMenuItem<String>(
                child: Text(value), value: value);
          }).toList(),
          isExpanded: true,
          onChanged: (value) {
            ref.read(currentValue.notifier).state = value!;
          }),
    );
  }
}
